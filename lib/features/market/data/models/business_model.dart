import 'package:market_app/features/market/domain/entities/business.dart';

class BusinessModel extends Business {
  const BusinessModel({
    required super.id,
    required super.name,
    required super.address,
    super.description,
    super.phone,
    super.isPro,
    super.isFeatured,
    super.status,
    super.viewsCount,
    super.imageUrl,
    super.createdAt,
    super.updatedAt,
  });

  factory BusinessModel.fromRemote(Map<String, dynamic> json) {
    return BusinessModel(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      description: json['description'] as String?,
      phone: json['phone'] as String?,
      isPro: json['is_pro'] as bool? ?? false,
      isFeatured: json['is_featured'] as bool? ?? false,
      status: json['status'] as String? ?? 'pending',
      viewsCount: json['views_count'] as int? ?? 0,
      imageUrl: json['image_url'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)?.toUtc()
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'] as String)?.toUtc()
          : null,
    );
  }
}
