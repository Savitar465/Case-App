import '../../domain/entities/item.dart';
import '../../domain/entities/item_image.dart';
import '../../domain/entities/item_type.dart';

class ItemModel extends Item {
  const ItemModel({
    required super.id,
    required super.businessId,
    required super.type,
    required super.name,
    required super.price,
    required super.currency,
    required super.isActive,
    required super.createdAt,
    required super.createdBy,
    super.description,
    super.duration,
    super.categoryId,
    super.updatedAt,
    super.updatedBy,
    super.images,
  });

  factory ItemModel.fromRemote(
    Map<String, dynamic> data, {
    List<ItemImage> images = const [],
  }) {
    return ItemModel(
      id: data['id'] as String,
      businessId: data['business_id'] as String,
      type: itemTypeFromLabel(data['type'] as String?),
      name: data['name'] as String,
      description: data['description'] as String?,
      price: _readDouble(data['price']) ?? 0,
      currency: data['currency'] as String? ?? 'USD',
      duration: (data['duration'] as num?)?.toInt(),
      categoryId: data['category_id']?.toString(),
      isActive: data['is_active'] as bool? ?? true,
      images: images,
      createdAt: _readDateTime(data['created_at']) ?? DateTime.now().toUtc(),
      updatedAt: _readDateTime(data['updated_at']),
      createdBy: data['created_by'] as String? ?? '',
      updatedBy: data['updated_by'] as String?,
    );
  }

  static double? _readDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }

  static DateTime? _readDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    return DateTime.tryParse(value.toString())?.toUtc();
  }
}
