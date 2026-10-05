import '../../domain/entities/favorite_entry.dart';
import '../../domain/entities/favorite_kind.dart';

typedef ImageUrlResolver = String Function(String raw);

class FavoriteEntryModel extends FavoriteEntry {
  const FavoriteEntryModel({
    required super.kind,
    required super.targetId,
    required super.businessId,
    required super.title,
    super.subtitle,
    super.imageUrl,
    super.price,
    super.currency,
    super.savedAt,
  });

  /// `business_follows` row embedding `businesses(..., business_images(...))`.
  static FavoriteEntryModel? fromFollowRow(
    Map<String, dynamic> row,
    ImageUrlResolver resolveImageUrl,
  ) {
    final business = row['businesses'] as Map<String, dynamic>?;
    if (business == null) return null;
    final id = business['id'] as String;
    return FavoriteEntryModel(
      kind: FavoriteKind.business,
      targetId: id,
      businessId: id,
      title: business['name'] as String? ?? '',
      subtitle: business['address'] as String?,
      imageUrl: _firstImage(business['business_images'], resolveImageUrl),
      savedAt: _readDate(row['created_at']),
    );
  }

  /// `favorites` row embedding `items(..., businesses(name), item_images(...))`.
  static FavoriteEntryModel? fromItemRow(
    Map<String, dynamic> row,
    ImageUrlResolver resolveImageUrl,
  ) {
    final item = row['items'] as Map<String, dynamic>?;
    if (item == null) return null;
    final business = item['businesses'] as Map<String, dynamic>?;
    return FavoriteEntryModel(
      kind: item['type'] == 'service'
          ? FavoriteKind.service
          : FavoriteKind.product,
      targetId: item['id'] as String,
      businessId: item['business_id'] as String,
      title: item['name'] as String? ?? '',
      subtitle: business?['name'] as String?,
      imageUrl: _firstImage(item['item_images'], resolveImageUrl),
      price: (item['price'] as num?)?.toDouble(),
      currency: item['currency'] as String?,
      savedAt: _readDate(row['created_at']),
    );
  }

  /// `offer_favorites` row embedding `offers(..., businesses(name))`.
  static FavoriteEntryModel? fromOfferRow(
    Map<String, dynamic> row,
    ImageUrlResolver resolveImageUrl,
  ) {
    final offer = row['offers'] as Map<String, dynamic>?;
    if (offer == null) return null;
    final business = offer['businesses'] as Map<String, dynamic>?;
    final image = offer['image_url'] as String?;
    return FavoriteEntryModel(
      kind: FavoriteKind.offer,
      targetId: offer['id'] as String,
      businessId: offer['business_id'] as String,
      title: offer['title'] as String? ?? '',
      subtitle: business?['name'] as String?,
      imageUrl: image == null || image.isEmpty ? null : resolveImageUrl(image),
      savedAt: _readDate(row['created_at']),
    );
  }

  static String? _firstImage(dynamic rows, ImageUrlResolver resolve) {
    final images =
        (rows as List<dynamic>? ?? const [])
            .whereType<Map<String, dynamic>>()
            .where((r) => (r['url'] as String?)?.isNotEmpty ?? false)
            .toList()
          ..sort((a, b) {
            final cover =
                (b['is_cover'] == true ? 1 : 0) -
                (a['is_cover'] == true ? 1 : 0);
            if (cover != 0) return cover;
            return ((a['display_order'] as num?) ?? 0).compareTo(
              (b['display_order'] as num?) ?? 0,
            );
          });
    return images.isEmpty ? null : resolve(images.first['url'] as String);
  }

  static DateTime? _readDate(dynamic value) =>
      value == null ? null : DateTime.tryParse(value.toString());
}
