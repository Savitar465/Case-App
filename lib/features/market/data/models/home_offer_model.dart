import 'package:market_app/features/market/domain/entities/home_offer.dart';

class HomeOfferModel extends HomeOffer {
  const HomeOfferModel({
    required super.id,
    required super.businessId,
    required super.businessName,
    required super.title,
    required super.discountType,
    required super.discountValue,
    required super.endDate,
    super.description,
    super.imageUrl,
    super.isFlash,
  });

  /// Parses an `offers` row that embeds `businesses(name)`.
  factory HomeOfferModel.fromRemote(Map<String, dynamic> json, {
    required String Function(String raw) resolveImageUrl,
  }) {
    final business = json['businesses'] as Map<String, dynamic>?;
    final image = json['image_url'] as String?;
    return HomeOfferModel(
      id: json['id'] as String,
      businessId: json['business_id'] as String,
      businessName: business?['name'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      discountType: json['discount_type'] as String? ?? '',
      discountValue: (json['discount_value'] as num?)?.toDouble() ?? 0,
      endDate:
      DateTime.tryParse(json['end_date']?.toString() ?? '') ??
          DateTime.now(),
      imageUrl: image == null || image.isEmpty ? null : resolveImageUrl(image),
      isFlash: json['item_id'] != null || json['start_time'] != null,
    );
  }
}
