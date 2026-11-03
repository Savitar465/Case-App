import 'dart:developer' as developer;
import 'dart:io';

import 'package:flutter/material.dart' show TimeOfDay;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../domain/entities/catalog_item.dart';
import '../../../domain/entities/catalog_item_draft.dart';
import '../../../domain/entities/catalog_offer.dart';

/// Products, services and flash offers of a business, plus the storage
/// upload helper shared with business registration.
///
/// [insertCatalog] and [uploadPhoto] let Postgrest/Storage exceptions
/// escape (the registration publish maps them); the owner-facing methods
/// wrap them into [CatalogRemoteException].
class CatalogRemoteDataSource {
  CatalogRemoteDataSource(this._client);

  final SupabaseClient _client;

  static const String _schema = 'public';
  static const String _businessesTable = 'businesses';
  static const String _itemsTable = 'items';
  static const String _itemImagesTable = 'item_images';
  static const String _offersTable = 'offers';
  static const String _currency = 'BOB';
  static const String _imagesBucket = 'vikus';
  static const Uuid _uuid = Uuid();

  // ── Owner-facing reads ────────────────────────────────────────────────
  Future<List<CatalogItem>> fetchItems(String businessId) {
    return _guard(() async {
      final rows =
          await _client
                  .schema(_schema)
                  .from(_itemsTable)
                  .select('*, item_images(id, url, display_order)')
                  .eq('business_id', businessId)
                  .order('created_at', ascending: false)
              as List<dynamic>;
      return rows.whereType<Map<String, dynamic>>().map(_itemFromRow).toList();
    });
  }

  Future<List<CatalogOffer>> fetchOffers(String businessId) {
    return _guard(() async {
      final rows =
          await _client
                  .schema(_schema)
                  .from(_offersTable)
                  .select('*, items(name, price)')
                  .eq('business_id', businessId)
                  .order('created_at', ascending: false)
              as List<dynamic>;
      return rows.whereType<Map<String, dynamic>>().map(_offerFromRow).toList();
    });
  }

  // ── Owner-facing writes ───────────────────────────────────────────────
  Future<void> addItem(String businessId, CatalogItemDraft draft) {
    return _guard(() async {
      final user = _requireUser();
      final business = await _client
          .schema(_schema)
          .from(_businessesTable)
          .select('category_id')
          .eq('id', businessId)
          .single();
      await insertCatalog(
        businessId: businessId,
        userId: user.id,
        categoryId: business['category_id'] as String?,
        items: [draft],
      );
    });
  }

  Future<void> updateItem(CatalogItem item, CatalogItemDraft draft) {
    return _guard(() async {
      final user = _requireUser();
      await _client
          .schema(_schema)
          .from(_itemsTable)
          .update({
            'name': draft.name,
            'description': draft.description,
            'price': draft.price ?? 0,
            'stock': draft.quantity,
            'updated_by': user.id,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', item.id);

      final newPhoto = draft.photoPath;
      if (newPhoto != null) {
        final objectPath = await uploadPhoto(
          folder: '${item.businessId}/items',
          localPath: newPhoto,
        );
        final imageId = item.imageId;
        if (imageId != null) {
          await _client
              .schema(_schema)
              .from(_itemImagesTable)
              .update({'url': objectPath})
              .eq('id', imageId);
        } else {
          await _client.schema(_schema).from(_itemImagesTable).insert({
            'item_id': item.id,
            'url': objectPath,
            'display_order': 0,
          });
        }
        await _removeObjects([?item.photoStoragePath]);
      } else if (draft.clearPhoto && item.imageId != null) {
        await _client
            .schema(_schema)
            .from(_itemImagesTable)
            .delete()
            .eq('id', item.imageId!);
        await _removeObjects([?item.photoStoragePath]);
      }
    });
  }

  Future<void> setItemActive(String itemId, {required bool isActive}) {
    return _guard(() async {
      final user = _requireUser();
      await _client
          .schema(_schema)
          .from(_itemsTable)
          .update({
            'is_active': isActive,
            'updated_by': user.id,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', itemId);
    });
  }

  /// Images, offers and favorites cascade (migration 20261104).
  Future<void> deleteItem(CatalogItem item) {
    return _guard(() async {
      _requireUser();
      await _client
          .schema(_schema)
          .from(_itemsTable)
          .delete()
          .eq('id', item.id);
      await _removeObjects([?item.photoStoragePath]);
    });
  }

  Future<void> saveOffer({
    required CatalogItem item,
    required FlashOffer offer,
    String? offerId,
  }) {
    return _guard(() async {
      final user = _requireUser();
      final now = DateTime.now().toIso8601String();
      final row = offerRow(
        businessId: item.businessId,
        itemId: item.id,
        title: item.name,
        description: item.description,
        normalPrice: item.price,
        offer: offer,
        imagePath: item.photoStoragePath,
      );
      final offers = _client.schema(_schema).from(_offersTable);
      if (offerId == null) {
        await offers.insert({
          ...row,
          'is_active': true,
          'created_by': user.id,
          'created_at': now,
        });
      } else {
        await offers
            .update({...row, 'updated_by': user.id, 'updated_at': now})
            .eq('id', offerId);
      }
    });
  }

  Future<void> setOfferActive(String offerId, {required bool isActive}) {
    return _guard(() async {
      final user = _requireUser();
      await _client
          .schema(_schema)
          .from(_offersTable)
          .update({
            'is_active': isActive,
            'updated_by': user.id,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', offerId);
    });
  }

  Future<void> deleteOffer(String offerId) {
    return _guard(() async {
      _requireUser();
      await _client
          .schema(_schema)
          .from(_offersTable)
          .delete()
          .eq('id', offerId);
    });
  }

  // ── Shared with registration ──────────────────────────────────────────
  /// Inserts the services/products, their photos, and a row in `offers` for
  /// each flash offer. Item ids are generated client-side so images and
  /// offers can reference them without a round-trip per item.
  Future<void> insertCatalog({
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
      photoPaths[item.id] = await uploadPhoto(
        folder: '$businessId/items',
        localPath: path,
        name: item.id,
      );
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
          {
            ...offerRow(
              businessId: businessId,
              itemId: item.id,
              title: item.name,
              description: item.description,
              normalPrice: item.price ?? 0,
              offer: item.flashOffer!,
              imagePath: photoPaths[item.id],
            ),
            'is_active': true,
            'created_by': userId,
            'created_at': now,
          },
    ];
    if (offerRows.isNotEmpty) {
      await _client.schema(_schema).from(_offersTable).insert(offerRows);
    }
  }

  /// Uploads a device photo to `vikus/<folder>/<name>.<ext>` (random name by
  /// default) and returns the object path stored in the image tables.
  Future<String> uploadPhoto({
    required String folder,
    required String localPath,
    String? name,
  }) async {
    final extension = _extensionOf(localPath);
    final objectPath = '$folder/${name ?? _uuid.v4()}.$extension';
    await _client.storage
        .from(_imagesBucket)
        .upload(
          objectPath,
          File(localPath),
          fileOptions: FileOptions(contentType: _contentType(extension)),
        );
    return objectPath;
  }

  /// Maps a flash offer onto the existing `offers` shape: a `fixed_amount`
  /// discount of (normal price − flash price), so current offer views render
  /// it unchanged, plus the item link and daily window/repeat days.
  Map<String, dynamic> offerRow({
    required String businessId,
    required String itemId,
    required String title,
    required String? description,
    required double normalPrice,
    required FlashOffer offer,
    required String? imagePath,
  }) {
    String timeOf(TimeOfDay t) =>
        '${t.hour.toString().padLeft(2, '0')}:'
        '${t.minute.toString().padLeft(2, '0')}:00';
    DateTime at(DateTime day, TimeOfDay t) =>
        DateTime(day.year, day.month, day.day, t.hour, t.minute);

    final discount = (normalPrice - (offer.price ?? 0)).clamp(
      0,
      double.infinity,
    );
    return {
      'business_id': businessId,
      'item_id': itemId,
      'title': title,
      'description': description ?? '',
      'discount_type': 'fixed_amount',
      'discount_value': discount,
      'start_date': at(offer.startDate, offer.startTime).toIso8601String(),
      'end_date': at(offer.endDate, offer.endTime).toIso8601String(),
      'start_time': timeOf(offer.startTime),
      'end_time': timeOf(offer.endTime),
      'repeat_days': offer.repeatWeekdays.toList()..sort(),
      'image_url': ?imagePath,
    };
  }

  // ── Mapping ───────────────────────────────────────────────────────────
  CatalogItem _itemFromRow(Map<String, dynamic> row) {
    final images =
        (row['item_images'] as List<dynamic>? ?? const [])
            .whereType<Map<String, dynamic>>()
            .toList()
          ..sort(
            (a, b) => ((a['display_order'] as num?) ?? 0).compareTo(
              (b['display_order'] as num?) ?? 0,
            ),
          );
    final image = images.isEmpty ? null : images.first;
    final raw = image?['url'] as String?;
    return CatalogItem(
      id: row['id'] as String,
      businessId: row['business_id'] as String,
      kind: row['type'] == CatalogItemKind.service.name
          ? CatalogItemKind.service
          : CatalogItemKind.product,
      name: row['name'] as String? ?? '',
      description: row['description'] as String?,
      price: (row['price'] as num?)?.toDouble() ?? 0,
      stock: (row['stock'] as num?)?.toInt(),
      isActive: row['is_active'] as bool? ?? true,
      photoUrl: _publicUrl(raw),
      photoStoragePath: _isExternal(raw) ? null : raw,
      imageId: image?['id'] as String?,
    );
  }

  CatalogOffer _offerFromRow(Map<String, dynamic> row) {
    final item = row['items'] as Map<String, dynamic>?;
    final value = (row['discount_value'] as num?)?.toDouble() ?? 0;
    final normal = (item?['price'] as num?)?.toDouble() ?? 0;
    final flash = row['discount_type'] == 'percentage'
        ? normal * (1 - value / 100)
        : normal - value;

    final start = _parseDate(row['start_date']);
    final end = _parseDate(row['end_date']);
    final startTime =
        _parseTime(row['start_time']) ?? TimeOfDay.fromDateTime(start);
    final endTime = _parseTime(row['end_time']) ?? TimeOfDay.fromDateTime(end);

    return CatalogOffer(
      id: row['id'] as String,
      itemId: row['item_id'] as String?,
      itemName: item?['name'] as String? ?? row['title'] as String? ?? '',
      normalPrice: normal,
      flashPrice: flash < 0 ? 0 : flash,
      isActive: row['is_active'] as bool? ?? true,
      imageUrl: _publicUrl(row['image_url'] as String?),
      schedule: FlashOffer(
        price: flash < 0 ? 0 : flash,
        startDate: DateTime(start.year, start.month, start.day),
        endDate: DateTime(end.year, end.month, end.day),
        startTime: startTime,
        endTime: endTime,
        repeatWeekdays: {
          for (final day in row['repeat_days'] as List<dynamic>? ?? const [])
            if (day is num) day.toInt(),
        },
      ),
    );
  }

  DateTime _parseDate(Object? value) =>
      DateTime.tryParse(value?.toString() ?? '') ?? DateTime.now();

  TimeOfDay? _parseTime(Object? value) {
    final parts = value?.toString().split(':');
    if (parts == null || parts.length < 2) return null;
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return null;
    return TimeOfDay(hour: hour, minute: minute);
  }

  bool _isExternal(String? raw) =>
      raw != null && (raw.startsWith('http://') || raw.startsWith('https://'));

  String? _publicUrl(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    if (_isExternal(raw)) return raw;
    return _client.storage.from(_imagesBucket).getPublicUrl(raw);
  }

  // ── Helpers ───────────────────────────────────────────────────────────
  User _requireUser() {
    final user = _client.auth.currentUser;
    if (user == null) {
      throw const CatalogRemoteException(
        'Inicia sesión para administrar tu negocio',
      );
    }
    return user;
  }

  Future<T> _guard<T>(Future<T> Function() run) async {
    try {
      return await run();
    } on PostgrestException catch (error) {
      throw CatalogRemoteException(error.message);
    } on StorageException catch (error) {
      throw CatalogRemoteException(error.message);
    }
  }

  /// Best-effort cleanup: the rows are already updated, so an orphaned
  /// object only wastes storage and must not fail the operation.
  Future<void> _removeObjects(List<String> paths) async {
    if (paths.isEmpty) return;
    try {
      await _client.storage.from(_imagesBucket).remove(paths);
    } on StorageException catch (error) {
      developer.log(
        'Could not remove catalog photos: ${error.message}',
        name: 'Catalog',
      );
    }
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
}

class CatalogRemoteException implements Exception {
  const CatalogRemoteException(this.message);

  final String message;

  @override
  String toString() => message;
}
