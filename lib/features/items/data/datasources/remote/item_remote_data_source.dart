import 'dart:developer' as developer;

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/item_image_model.dart';
import '../../models/item_model.dart';

class ItemRemoteDataSource {
  ItemRemoteDataSource(this._client);

  final SupabaseClient _client;

  static const String _schema = 'public';
  static const String _table = 'items';
  static const String _imagesTable = 'item_images';
  static const String _imagesBucket = 'vikus';

  Future<List<ItemModel>> fetchItems(String businessId) async {
    try {
      final rows =
          await _client
                  .schema(_schema)
                  .from(_table)
                  .select()
                  .eq('business_id', businessId)
                  .order('created_at', ascending: false)
              as List<dynamic>;
      final items = rows.whereType<Map<String, dynamic>>().toList();
      if (items.isEmpty) return const <ItemModel>[];

      final ids = items.map((row) => row['id'] as String).toList();
      final imagesByItem = await _fetchImagesGrouped(ids);

      return items
          .map(
            (row) => ItemModel.fromRemote(
              row,
              images: imagesByItem[row['id'] as String] ?? const [],
            ),
          )
          .toList();
    } on PostgrestException catch (error) {
      throw ItemRemoteException(error.message);
    }
  }

  Future<ItemModel?> fetchItemById(String id) async {
    try {
      final row = await _client
          .schema(_schema)
          .from(_table)
          .select()
          .eq('id', id)
          .maybeSingle();
      if (row == null) return null;
      final images = await _fetchImagesGrouped([id]);
      return ItemModel.fromRemote(row, images: images[id] ?? const []);
    } on PostgrestException catch (error) {
      throw ItemRemoteException(error.message);
    }
  }

  Future<Map<String, List<ItemImageModel>>> _fetchImagesGrouped(
    List<String> itemIds,
  ) async {
    if (itemIds.isEmpty) return const {};
    try {
      final rows =
          await _client
                  .schema(_schema)
                  .from(_imagesTable)
                  .select()
                  .inFilter('item_id', itemIds)
                  .order('display_order', ascending: true)
              as List<dynamic>;
      final grouped = <String, List<ItemImageModel>>{};
      for (final raw in rows.whereType<Map<String, dynamic>>()) {
        final model = _resolveImageUrl(ItemImageModel.fromRemote(raw));
        grouped.putIfAbsent(model.itemId, () => <ItemImageModel>[]).add(model);
      }
      return grouped;
    } on PostgrestException catch (error) {
      developer.log(
        'fetchItemImages PostgrestException: ${error.message}',
        name: 'ItemImages',
        error: error,
      );
      throw ItemRemoteException(error.message);
    }
  }

  ItemImageModel _resolveImageUrl(ItemImageModel image) {
    final raw = image.url;
    if (raw.isEmpty ||
        raw.startsWith('http://') ||
        raw.startsWith('https://')) {
      return image;
    }
    final resolved = _client.storage.from(_imagesBucket).getPublicUrl(raw);
    return ItemImageModel(
      id: image.id,
      itemId: image.itemId,
      url: resolved,
      displayOrder: image.displayOrder,
    );
  }
}

class ItemRemoteException implements Exception {
  const ItemRemoteException(this.message);

  final String message;

  @override
  String toString() => message;
}
