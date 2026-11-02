import '../../domain/entities/plan_business.dart';

class PlanBusinessModel extends PlanBusiness {
  const PlanBusinessModel({
    required super.id,
    required super.name,
    super.address = '',
    super.imageUrl,
    super.isPro = false,
    super.proExpiresAt,
  });

  factory PlanBusinessModel.fromRemote(
    Map<String, dynamic> json, {
    String? Function(String?)? resolveImageUrl,
  }) {
    String? resolvedImage;
    final rawUrl = json['image_url'] ?? json['url'];
    if (rawUrl != null) {
      resolvedImage = resolveImageUrl != null
          ? resolveImageUrl(rawUrl as String?)
          : rawUrl as String?;
    } else if (json['business_images'] is List &&
        (json['business_images'] as List).isNotEmpty) {
      final images = json['business_images'] as List;
      final cover = images.firstWhere(
        (img) => img is Map && img['is_cover'] == true,
        orElse: () => images.first,
      );
      if (cover is Map) {
        final imgUrl = cover['url'] ?? cover['image_url'];
        if (imgUrl != null) {
          resolvedImage = resolveImageUrl != null
              ? resolveImageUrl(imgUrl as String?)
              : imgUrl as String?;
        }
      }
    }

    DateTime? proExpiresAt;
    final rawExpiry = json['pro_expires_at'];
    if (rawExpiry != null) {
      if (rawExpiry is DateTime) {
        proExpiresAt = rawExpiry;
      } else {
        proExpiresAt = DateTime.tryParse(rawExpiry.toString())?.toUtc();
      }
    }

    return PlanBusinessModel(
      id: json['id'] as String,
      name: (json['name'] as String?) ?? 'Negocio',
      address: (json['address'] as String?) ?? '',
      imageUrl: resolvedImage,
      isPro: json['is_pro'] as bool? ?? false,
      proExpiresAt: proExpiresAt,
    );
  }
}
