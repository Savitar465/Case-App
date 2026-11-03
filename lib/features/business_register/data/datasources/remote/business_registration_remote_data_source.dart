import 'dart:developer' as developer;

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../../market/data/models/category_model.dart';
import '../../../../market/domain/entities/category.dart';
import '../../../domain/entities/business_draft.dart';
import '../../../domain/entities/day_schedule.dart';
import '../../../domain/entities/editable_business.dart';
import '../../../domain/entities/editable_photo.dart';
import 'catalog_remote_data_source.dart';

class BusinessRegistrationRemoteDataSource {
  BusinessRegistrationRemoteDataSource(this._client)
    : _catalog = CatalogRemoteDataSource(_client);

  final SupabaseClient _client;

  /// Owns item/offer inserts and photo uploads, shared with catalog
  /// management.
  final CatalogRemoteDataSource _catalog;

  static const String _schema = 'public';
  static const String _businessesTable = 'businesses';
  static const String _categoriesTable = 'categories';
  static const String _imagesTable = 'business_images';
  static const String _itemsTable = 'items';
  static const String _offersTable = 'offers';
  static const String _imagesBucket = 'vikus';
  static const String _defaultCountryCode = '+591';
  static const Uuid _uuid = Uuid();

  Future<List<MarketCategory>> getCategories() async {
    try {
      final rows =
          await _client
                  .schema(_schema)
                  .from(_categoriesTable)
                  .select()
                  .order('order', ascending: true)
              as List<dynamic>;
      return rows
          .whereType<Map<String, dynamic>>()
          .map(CategoryModel.fromRemote)
          .toList();
    } on PostgrestException catch (error) {
      throw BusinessRegistrationException(error.message);
    }
  }

  Future<String> publish(BusinessDraft draft) async {
    final user = _client.auth.currentUser;
    if (user == null) {
      throw const BusinessRegistrationException(
        'Inicia sesión para registrar tu negocio',
      );
    }

    final id = _uuid.v4();
    final payload = <String, dynamic>{
      'id': id,
      'owner_id': user.id,
      ..._businessFields(draft),
      'status': 'pending',
      'created_by': user.id,
      'created_at': DateTime.now().toIso8601String(),
    };
    payload.removeWhere((_, value) => value == null);

    try {
      final row = await _client
          .schema(_schema)
          .from(_businessesTable)
          .insert(payload)
          .select('id')
          .single();
      final businessId = row['id'] as String;
      await _uploadPhotos(businessId, draft.photos);
      await _catalog.insertCatalog(
        businessId: businessId,
        userId: user.id,
        categoryId: draft.category?.id,
        items: [...draft.services, ...draft.products],
      );
      return businessId;
    } on PostgrestException catch (error) {
      throw BusinessRegistrationException(error.message);
    } on StorageException catch (error) {
      throw BusinessRegistrationException(error.message);
    }
  }

  /// Loads an owned, non-deleted business and its photos for the edit form.
  Future<EditableBusiness> fetchBusinessForEdit(String businessId) async {
    final user = _requireUser();
    try {
      final row = await _client
          .schema(_schema)
          .from(_businessesTable)
          .select('*, categories(*)')
          .eq('id', businessId)
          .eq('owner_id', user.id)
          .neq('status', 'deleted')
          .maybeSingle();
      if (row == null) {
        throw const BusinessRegistrationException(
          'No encontramos este negocio',
        );
      }
      final imageRows =
          await _client
                  .schema(_schema)
                  .from(_imagesTable)
                  .select()
                  .eq('business_id', businessId)
                  .order('is_cover', ascending: false)
                  .order('display_order', ascending: true)
              as List<dynamic>;
      return EditableBusiness(
        id: businessId,
        draft: _draftFromRow(row),
        photos: imageRows
            .whereType<Map<String, dynamic>>()
            .map(_photoFromRow)
            .toList(),
      );
    } on PostgrestException catch (error) {
      throw BusinessRegistrationException(error.message);
    }
  }

  /// Updates the business row, then applies photo changes in order:
  /// delete removed rows, upload new photos, and rewrite order/cover flags.
  /// The status column is intentionally not touched.
  Future<void> updateBusiness({
    required String businessId,
    required BusinessDraft draft,
    List<EditablePhoto>? photos,
    List<EditablePhoto>? removedPhotos,
  }) async {
    final user = _requireUser();
    try {
      await _client
          .schema(_schema)
          .from(_businessesTable)
          .update({
            ..._businessFields(draft),
            'updated_by': user.id,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', businessId);
      if (photos == null) return;

      final removed = removedPhotos ?? const <EditablePhoto>[];
      final removedIds = [
        for (final photo in removed)
          if (photo.id != null) photo.id!,
      ];
      if (removedIds.isNotEmpty) {
        await _client
            .schema(_schema)
            .from(_imagesTable)
            .delete()
            .inFilter('id', removedIds);
        await _removeStorageObjects([
          for (final photo in removed)
            if (photo.storagePath != null) photo.storagePath!,
        ]);
      }

      for (var i = 0; i < photos.length; i++) {
        final photo = photos[i];
        final localPath = photo.localPath;
        if (localPath != null) {
          await _client.schema(_schema).from(_imagesTable).insert({
            'business_id': businessId,
            'url': await _uploadBusinessPhoto(businessId, localPath),
            'is_cover': i == 0,
            'display_order': i,
          });
        } else {
          await _client
              .schema(_schema)
              .from(_imagesTable)
              .update({'is_cover': i == 0, 'display_order': i})
              .eq('id', photo.id!);
        }
      }
    } on PostgrestException catch (error) {
      throw BusinessRegistrationException(error.message);
    } on StorageException catch (error) {
      throw BusinessRegistrationException(error.message);
    }
  }

  /// Soft delete: rows referencing the business (reviews, follows, plans...)
  /// have non-cascading FKs, and every listing already filters
  /// `status = 'deleted'`. Items and offers are deactivated so the offer
  /// feeds (which filter on `is_active`) drop them too.
  Future<void> deleteBusiness(String businessId) async {
    final user = _requireUser();
    try {
      await _client
          .schema(_schema)
          .from(_businessesTable)
          .update({
            'status': 'deleted',
            'updated_by': user.id,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', businessId)
          .eq('owner_id', user.id);
      await _client
          .schema(_schema)
          .from(_offersTable)
          .update({'is_active': false})
          .eq('business_id', businessId);
      await _client
          .schema(_schema)
          .from(_itemsTable)
          .update({'is_active': false})
          .eq('business_id', businessId);
    } on PostgrestException catch (error) {
      throw BusinessRegistrationException(error.message);
    }
  }

  User _requireUser() {
    final user = _client.auth.currentUser;
    if (user == null) {
      throw const BusinessRegistrationException(
        'Inicia sesión para administrar tu negocio',
      );
    }
    return user;
  }

  /// Best-effort cleanup: the image rows are already gone, so an orphaned
  /// object only wastes storage and must not fail the save.
  Future<void> _removeStorageObjects(List<String> paths) async {
    if (paths.isEmpty) return;
    try {
      await _client.storage.from(_imagesBucket).remove(paths);
    } on StorageException catch (error) {
      developer.log(
        'Could not remove business photos: ${error.message}',
        name: 'BusinessRegistration',
      );
    }
  }

  /// Uploads each picked photo to the `vikus` bucket and records a
  /// `business_images` row. The first photo becomes the cover. Storage paths
  /// (not public URLs) are stored, matching how reads resolve them.
  Future<void> _uploadPhotos(String businessId, List<String> paths) async {
    if (paths.isEmpty) return;
    final rows = <Map<String, dynamic>>[];
    for (var i = 0; i < paths.length; i++) {
      rows.add({
        'business_id': businessId,
        'url': await _uploadBusinessPhoto(businessId, paths[i]),
        'is_cover': i == 0,
        'display_order': i,
      });
    }
    await _client.schema(_schema).from(_imagesTable).insert(rows);
  }

  /// Uploads one device photo and returns its bucket object path.
  Future<String> _uploadBusinessPhoto(String businessId, String path) =>
      _catalog.uploadPhoto(folder: businessId, localPath: path);

  /// Columns shared by insert (publish) and update (edit). Empty optional
  /// fields map to null so clearing a field in the edit form clears it.
  Map<String, dynamic> _businessFields(BusinessDraft draft) => {
    'name': draft.name.trim(),
    'description': _nullIfEmpty(draft.description),
    'category_id': draft.category?.id,
    'address': draft.address.trim(),
    'latitude': draft.latitude ?? 0,
    'longitude': draft.longitude ?? 0,
    'whatsapp': _fullWhatsapp(draft),
    'phone': _nullIfEmpty(draft.phone),
    'email': _nullIfEmpty(draft.email),
    'website': _nullIfEmpty(draft.website),
    'social_networks': _socialNetworks(draft),
    'schedule': _schedule(draft),
  };

  String? _fullWhatsapp(BusinessDraft draft) {
    final number = draft.whatsapp.trim();
    if (number.isEmpty) return null;
    // A number typed with its own country code is stored as-is.
    if (number.startsWith('+')) return number;
    return '${draft.whatsappCountryCode}$number';
  }

  BusinessDraft _draftFromRow(Map<String, dynamic> row) {
    final social = _jsonMap(row['social_networks']);
    final schedule = _jsonMap(row['schedule']);
    final categoryRow = row['categories'];
    var latitude = _toDouble(row['latitude']);
    var longitude = _toDouble(row['longitude']);
    // publish() stores 0/0 when no pin was chosen.
    if (latitude == 0 && longitude == 0) latitude = longitude = null;

    var whatsapp = (row['whatsapp'] as String?)?.trim() ?? '';
    if (whatsapp.startsWith(_defaultCountryCode)) {
      whatsapp = whatsapp.substring(_defaultCountryCode.length);
    }

    String text(Object? value) => value?.toString().trim() ?? '';

    return BusinessDraft(
      name: text(row['name']),
      description: text(row['description']),
      category: categoryRow is Map<String, dynamic>
          ? CategoryModel.fromRemote(categoryRow)
          : null,
      address: text(row['address']),
      latitude: latitude,
      longitude: longitude,
      whatsappCountryCode: _defaultCountryCode,
      whatsapp: whatsapp,
      phone: text(row['phone']),
      email: text(row['email']),
      website: text(row['website']),
      tiktok: text(social['tiktok']),
      facebook: text(social['facebook']),
      instagram: text(social['instagram']),
      schedule: [
        for (final day in DaySchedule.defaultWeek())
          _dayFromJson(day, schedule[day.day]),
      ],
    );
  }

  /// Reads both schedule shapes found in the table: the list of
  /// `{open, close}` shifts (current; an empty list means closed) and the
  /// older single-range `{is_open, open, close}` written by the wizard.
  /// Every shift is kept, so split schedules survive an edit.
  DaySchedule _dayFromJson(DaySchedule fallback, Object? json) {
    TimeRange? rangeOf(Map<dynamic, dynamic> map) {
      final open = map['open']?.toString();
      final close = map['close']?.toString();
      if (open == null || close == null) return null;
      return TimeRange(open: open, close: close);
    }

    if (json is Map) {
      final range = rangeOf(json);
      return fallback.copyWith(
        isOpen: json['is_open'] as bool? ?? fallback.isOpen,
        ranges: range == null ? null : [range],
      );
    }
    if (json is List) {
      final ranges = [
        for (final entry in json.whereType<Map<dynamic, dynamic>>())
          ?rangeOf(entry),
      ];
      if (ranges.isEmpty) return fallback.copyWith(isOpen: false);
      return fallback.copyWith(isOpen: true, ranges: ranges);
    }
    return fallback;
  }

  EditablePhoto _photoFromRow(Map<String, dynamic> row) {
    final raw = row['url'] as String? ?? '';
    final isExternal = raw.startsWith('http://') || raw.startsWith('https://');
    return EditablePhoto.remote(
      id: row['id'] as String,
      url: isExternal
          ? raw
          : _client.storage.from(_imagesBucket).getPublicUrl(raw),
      storagePath: isExternal ? null : raw,
    );
  }

  Map<String, dynamic> _jsonMap(Object? value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return value.cast<String, dynamic>();
    return const {};
  }

  double? _toDouble(Object? value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '');
  }

  Map<String, dynamic>? _socialNetworks(BusinessDraft draft) {
    final map = <String, dynamic>{};
    void put(String key, String value) {
      if (value.trim().isNotEmpty) map[key] = value.trim();
    }

    put('tiktok', draft.tiktok);
    put('facebook', draft.facebook);
    put('instagram', draft.instagram);
    return map.isEmpty ? null : map;
  }

  Map<String, dynamic> _schedule(BusinessDraft draft) {
    return {for (final day in draft.schedule) day.day: day.toJson()};
  }

  String? _nullIfEmpty(String value) =>
      value.trim().isEmpty ? null : value.trim();
}

class BusinessRegistrationException implements Exception {
  const BusinessRegistrationException(this.message);

  final String message;

  @override
  String toString() => message;
}
