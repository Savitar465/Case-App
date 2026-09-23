import 'dart:io';

import 'package:flutter/material.dart' show TimeOfDay;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../../market/data/models/category_model.dart';
import '../../../../market/domain/entities/category.dart';
import '../../../domain/entities/business_draft.dart';
import '../../../domain/entities/catalog_item_draft.dart';

class BusinessRegistrationRemoteDataSource {
  BusinessRegistrationRemoteDataSource(this._client);

  final SupabaseClient _client;

  static const String _schema = 'public';
  static const String _businessesTable = 'businesses';
  static const String _categoriesTable = 'categories';
  static const String _imagesTable = 'business_images';
  static const String _itemsTable = 'items';
  static const String _itemImagesTable = 'item_images';
  static const String _offersTable = 'offers';
  static const String _currency = 'BOB';
  static const String _imagesBucket = 'vikus';
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
      'name': draft.name.trim(),
      'category_id': draft.category?.id,
      'address': draft.address.trim(),
      'latitude': draft.latitude ?? 0,
      'longitude': draft.longitude ?? 0,
      'whatsapp': _fullWhatsapp(draft),
      'website': _nullIfEmpty(draft.website),
      'social_networks': _socialNetworks(draft),
      'schedule': _schedule(draft),
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
      await _insertCatalog(
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

  /// Uploads each picked photo to the `vikus` bucket and records a
  /// `business_images` row. The first photo becomes the cover. Storage paths
  /// (not public URLs) are stored, matching how reads resolve them.
  Future<void> _uploadPhotos(String businessId, List<String> paths) async {
    if (paths.isEmpty) return;
    final rows = <Map<String, dynamic>>[];
    for (var i = 0; i < paths.length; i++) {
      final file = File(paths[i]);
      final extension = _extensionOf(paths[i]);
      final objectPath = '$businessId/${_uuid.v4()}.$extension';
      await _client.storage
          .from(_imagesBucket)
          .upload(
            objectPath,
            file,
            fileOptions: FileOptions(contentType: _contentType(extension)),
          );
      rows.add({
        'business_id': businessId,
        'url': objectPath,
        'is_cover': i == 0,
        'display_order': i,
      });
    }
    await _client.schema(_schema).from(_imagesTable).insert(rows);
  }

  /// Inserts the services/products added in the wizard, their photos, and a
  /// row in `offers` for each flash offer. Item ids are generated client-side
  /// so images and offers can reference them without a round-trip per item.
  Future<void> _insertCatalog({
    required String businessId,
    required String userId,
    required String? categoryId,
    required List<CatalogItemDraft> items,
  }) async {
    if (items.isEmpty) return;
    final now = DateTime.now().toIso8601String();

    final itemRows = [
      for (final item in items)
        <String, dynamic>{
          'id': item.id,
          'business_id': businessId,
          'type': item.kind.name,
          'name': item.name,
          'description': item.description,
          'price': item.price ?? 0,
          'currency': _currency,
          'category_id': ?categoryId,
          'stock': item.quantity,
          'is_active': true,
          'created_by': userId,
          'created_at': now,
        },
    ];
    await _client.schema(_schema).from(_itemsTable).insert(itemRows);

    final photoPaths = <String, String>{};
    for (final item in items) {
      final path = item.photoPath;
      if (path == null) continue;
      final extension = _extensionOf(path);
      final objectPath = '$businessId/items/${item.id}.$extension';
      await _client.storage
          .from(_imagesBucket)
          .upload(
            objectPath,
            File(path),
            fileOptions: FileOptions(contentType: _contentType(extension)),
          );
      photoPaths[item.id] = objectPath;
    }
    if (photoPaths.isNotEmpty) {
      await _client.schema(_schema).from(_itemImagesTable).insert([
        for (final entry in photoPaths.entries)
          {'item_id': entry.key, 'url': entry.value, 'display_order': 0},
      ]);
    }

    final offerRows = [
      for (final item in items)
        if (item.offerType == OfferType.flash && item.flashOffer != null)
          _offerRow(
            businessId: businessId,
            userId: userId,
            item: item,
            offer: item.flashOffer!,
            imagePath: photoPaths[item.id],
            createdAt: now,
          ),
    ];
    if (offerRows.isNotEmpty) {
      await _client.schema(_schema).from(_offersTable).insert(offerRows);
    }
  }

  /// Maps a flash offer onto the existing `offers` shape: a `fixed_amount`
  /// discount of (normal price − flash price), so current offer views render
  /// it unchanged, plus the item link and daily window/repeat days.
  Map<String, dynamic> _offerRow({
    required String businessId,
    required String userId,
    required CatalogItemDraft item,
    required FlashOffer offer,
    required String? imagePath,
    required String createdAt,
  }) {
    String timeOf(TimeOfDay t) =>
        '${t.hour.toString().padLeft(2, '0')}:'
        '${t.minute.toString().padLeft(2, '0')}:00';
    DateTime at(DateTime day, TimeOfDay t) =>
        DateTime(day.year, day.month, day.day, t.hour, t.minute);

    final discount = ((item.price ?? 0) - (offer.price ?? 0)).clamp(
      0,
      double.infinity,
    );
    return {
      'business_id': businessId,
      'item_id': item.id,
      'title': item.name,
      'description': item.description ?? '',
      'discount_type': 'fixed_amount',
      'discount_value': discount,
      'start_date': at(offer.startDate, offer.startTime).toIso8601String(),
      'end_date': at(offer.endDate, offer.endTime).toIso8601String(),
      'start_time': timeOf(offer.startTime),
      'end_time': timeOf(offer.endTime),
      'repeat_days': offer.repeatWeekdays.toList()..sort(),
      'image_url': ?imagePath,
      'is_active': true,
      'created_by': userId,
      'created_at': createdAt,
    };
  }

  String _extensionOf(String path) {
    final dot = path.lastIndexOf('.');
    if (dot == -1 || dot == path.length - 1) return 'jpg';
    final extension = path.substring(dot + 1).toLowerCase();
    return extension.length > 4 ? 'jpg' : extension;
  }

  String _contentType(String extension) => switch (extension) {
    'png' => 'image/png',
    'webp' => 'image/webp',
    'heic' => 'image/heic',
    'gif' => 'image/gif',
    _ => 'image/jpeg',
  };

  String? _fullWhatsapp(BusinessDraft draft) {
    final number = draft.whatsapp.trim();
    if (number.isEmpty) return null;
    return '${draft.whatsappCountryCode}$number';
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
