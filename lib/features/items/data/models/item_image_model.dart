import '../../domain/entities/item_image.dart';

class ItemImageModel extends ItemImage {
  const ItemImageModel({
    required super.id,
    required super.itemId,
    required super.url,
    required super.displayOrder,
  });

  factory ItemImageModel.fromRemote(Map<String, dynamic> data) {
    return ItemImageModel(
      id: data['id'] as String,
      itemId: data['item_id'] as String,
      url: data['url'] as String,
      displayOrder: (data['display_order'] as num?)?.toInt() ?? 0,
    );
  }
}
