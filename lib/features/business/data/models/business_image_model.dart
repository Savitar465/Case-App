import '../../domain/entities/business_image.dart';

class BusinessImageModel extends BusinessImage {
  const BusinessImageModel({
    required super.id,
    required super.businessId,
    required super.url,
    required super.isCover,
    required super.displayOrder,
    required super.createdAt,
  });

  factory BusinessImageModel.fromRemote(Map<String, dynamic> data) {
    return BusinessImageModel(
      id: data['id'] as String,
      businessId: data['business_id'] as String,
      url: data['url'] as String,
      isCover: data['is_cover'] as bool? ?? false,
      displayOrder: (data['display_order'] as num?)?.toInt() ?? 0,
      createdAt:
          DateTime.tryParse(data['created_at']?.toString() ?? '')?.toUtc() ??
          DateTime.now().toUtc(),
    );
  }
}
