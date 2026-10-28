import '../../domain/entities/discount_type.dart';
import '../../domain/entities/offer_detail.dart';

class OfferDetailModel extends OfferDetail {
  const OfferDetailModel({
    required super.id,
    required super.businessId,
    required super.businessName,
    required super.title,
    required super.discountType,
    required super.discountValue,
    required super.endDate,
    super.description,
    super.imageUrl,
    super.categoryName,
    super.categoryIcon,
    super.businessWhatsapp,
    super.businessLatitude,
    super.businessLongitude,
    super.originalPrice,
    super.currency,
    super.stock,
    super.dailyStartMinute,
    super.dailyEndMinute,
    super.repeatWeekdays,
  });

  /// Builds from an `offers` row selected with
  /// `businesses(name, whatsapp, latitude, longitude, categories(name_es, icon))`
  /// and `items(price, currency, stock)`. [imageUrl] is already resolved.
  factory OfferDetailModel.fromRemote(
    Map<String, dynamic> json, {
    String? imageUrl,
  }) {
    final business = json['businesses'] as Map<String, dynamic>? ?? const {};
    final category = business['categories'] as Map<String, dynamic>?;
    final item = json['items'] as Map<String, dynamic>?;
    final currency = (item?['currency'] as String?)?.trim();
    return OfferDetailModel(
      id: json['id'] as String,
      businessId: json['business_id'] as String,
      businessName: (business['name'] as String?) ?? 'Negocio',
      title: (json['title'] as String?) ?? '',
      description: (json['description'] as String?) ?? '',
      discountType: discountTypeFromLabel(json['discount_type'] as String?),
      discountValue: _readDouble(json['discount_value']) ?? 0,
      // `timestamp without time zone`: the stored value is local wall time.
      endDate:
          DateTime.tryParse(json['end_date']?.toString() ?? '') ??
          DateTime.now(),
      imageUrl: imageUrl,
      categoryName: category?['name_es'] as String?,
      categoryIcon: category?['icon'] as String?,
      businessWhatsapp: business['whatsapp'] as String?,
      businessLatitude: _readDouble(business['latitude']),
      businessLongitude: _readDouble(business['longitude']),
      originalPrice: _readDouble(item?['price']),
      currency: _currencyLabel(currency),
      stock: (item?['stock'] as num?)?.toInt(),
      dailyStartMinute: _readMinute(json['start_time']),
      dailyEndMinute: _readMinute(json['end_time']),
      repeatWeekdays: (json['repeat_days'] as List<dynamic>? ?? const [])
          .map((day) => int.tryParse(day.toString()))
          .whereType<int>()
          .toList(),
    );
  }

  static String _currencyLabel(String? currency) {
    if (currency == null || currency.isEmpty) return 'Bs';
    return switch (currency.toUpperCase()) {
      'BOB' || 'BS' => 'Bs',
      'USD' => r'$',
      _ => currency,
    };
  }

  static double? _readDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }

  /// `HH:mm:ss` → minutes since midnight.
  static int? _readMinute(dynamic value) {
    if (value == null) return null;
    final parts = value.toString().split(':');
    if (parts.length < 2) return null;
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return null;
    return hour * 60 + minute;
  }
}
