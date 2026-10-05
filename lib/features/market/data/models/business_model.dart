import 'package:market_app/features/market/domain/entities/business.dart';
import 'package:market_app/features/market/domain/entities/opening_hours.dart';

class BusinessModel extends Business {
  const BusinessModel({
    required super.id,
    required super.name,
    required super.address,
    super.categoryId,
    super.description,
    super.phone,
    super.latitude,
    super.longitude,
    super.isPro,
    super.isFeatured,
    super.status,
    super.viewsCount,
    super.imageUrls,
    super.rating,
    super.reviewCount,
    super.openingHours,
    super.createdAt,
    super.updatedAt,
  });

  /// Parses a `businesses` row that embeds `business_images(...)` and
  /// `reviews(rating,status)`. [resolveImageUrl] turns storage paths into
  /// public URLs.
  factory BusinessModel.fromRemote(
    Map<String, dynamic> json, {
    required String Function(String raw) resolveImageUrl,
  }) {
    final images =
        (json['business_images'] as List<dynamic>? ?? const [])
            .whereType<Map<String, dynamic>>()
            .where((row) => (row['url'] as String?)?.isNotEmpty ?? false)
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

    final ratings = (json['reviews'] as List<dynamic>? ?? const [])
        .whereType<Map<String, dynamic>>()
        .where((row) => (row['status'] as String? ?? 'active') == 'active')
        .map((row) => (row['rating'] as num?)?.toDouble())
        .whereType<double>()
        .toList();

    return BusinessModel(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String? ?? '',
      categoryId: json['category_id'] as String?,
      description: json['description'] as String?,
      phone: json['phone'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      isPro: json['is_pro'] as bool? ?? false,
      isFeatured: json['is_featured'] as bool? ?? false,
      status: json['status'] as String? ?? 'pending',
      viewsCount: (json['views_count'] as num?)?.toInt() ?? 0,
      imageUrls: [
        for (final row in images) resolveImageUrl(row['url'] as String),
      ],
      rating: ratings.isEmpty
          ? 0
          : ratings.reduce((a, b) => a + b) / ratings.length,
      reviewCount: ratings.length,
      openingHours: _parseSchedule(json['schedule']),
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)?.toUtc()
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'] as String)?.toUtc()
          : null,
    );
  }

  static const _weekdays = {
    'monday': DateTime.monday,
    'tuesday': DateTime.tuesday,
    'wednesday': DateTime.wednesday,
    'thursday': DateTime.thursday,
    'friday': DateTime.friday,
    'saturday': DateTime.saturday,
    'sunday': DateTime.sunday,
  };

  /// The `schedule` jsonb exists in two shapes in the live data:
  ///   * wizard:  `{"monday": {"is_open": true, "open": "8:00", "close": "19:00"}}`
  ///   * legacy:  `{"monday": [{"open": "08:00", "close": "14:00"}, ...]}`
  static OpeningHours _parseSchedule(dynamic raw) {
    if (raw is! Map) return const OpeningHours();
    final days = <int, List<OpeningRange>>{};
    raw.forEach((key, value) {
      final weekday = _weekdays[key.toString().toLowerCase()];
      if (weekday == null) return;
      final entries = switch (value) {
        final List<dynamic> list => list,
        final Map<dynamic, dynamic> map when map['is_open'] != false => [map],
        _ => const <dynamic>[],
      };
      final ranges = <OpeningRange>[];
      for (final entry in entries.whereType<Map<dynamic, dynamic>>()) {
        final open = _parseMinutes(entry['open']);
        var close = _parseMinutes(entry['close']);
        if (open == null || close == null) continue;
        if (close <= open) close += 1440;
        ranges.add(OpeningRange(openMinutes: open, closeMinutes: close));
      }
      if (ranges.isNotEmpty) days[weekday] = ranges;
    });
    return OpeningHours(days);
  }

  static int? _parseMinutes(dynamic value) {
    final parts = value?.toString().split(':');
    if (parts == null || parts.length < 2) return null;
    final h = int.tryParse(parts[0].trim());
    final m = int.tryParse(parts[1].trim());
    if (h == null || m == null) return null;
    return h * 60 + m;
  }
}
