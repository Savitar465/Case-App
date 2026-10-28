import 'dart:math' as math;

import 'package:equatable/equatable.dart';

import 'discount_type.dart';

/// An active offer with the business and item data the "Ofertas" tab shows:
/// prices, stock, category, location and WhatsApp contact.
class OfferDetail extends Equatable {
  const OfferDetail({
    required this.id,
    required this.businessId,
    required this.businessName,
    required this.title,
    required this.discountType,
    required this.discountValue,
    required this.endDate,
    this.description = '',
    this.imageUrl,
    this.categoryName,
    this.categoryIcon,
    this.businessWhatsapp,
    this.businessLatitude,
    this.businessLongitude,
    this.originalPrice,
    this.currency = 'Bs',
    this.stock,
    this.dailyStartMinute,
    this.dailyEndMinute,
    this.repeatWeekdays = const [],
  });

  final String id;
  final String businessId;
  final String businessName;
  final String title;
  final String description;
  final DiscountType discountType;
  final double discountValue;

  /// Last moment the offer is valid (local time).
  final DateTime endDate;
  final String? imageUrl;
  final String? categoryName;

  /// Material icon code point as stored in `categories.icon` (`0xe532`).
  final String? categoryIcon;
  final String? businessWhatsapp;
  final double? businessLatitude;
  final double? businessLongitude;

  /// Price of the linked item before the discount, when there is one.
  final double? originalPrice;
  final String currency;

  /// Units left of the linked item; `null` when the business doesn't track it.
  final int? stock;

  /// Daily window of flash offers, in minutes since midnight.
  final int? dailyStartMinute;
  final int? dailyEndMinute;

  /// `DateTime.weekday` values the flash window repeats on (empty = every day).
  final List<int> repeatWeekdays;

  bool get isFlash => dailyEndMinute != null;

  /// Price after the discount, when the offer is linked to a priced item.
  double? get finalPrice {
    final price = originalPrice;
    if (price == null) return null;
    final result = switch (discountType) {
      DiscountType.percentage => price * (1 - discountValue / 100),
      DiscountType.fixedAmount => price - discountValue,
      DiscountType.unknown => price,
    };
    return math.max(0, result);
  }

  /// Discount as a whole percentage for the "-20%" badge, if computable.
  int? get discountPercent {
    if (discountType == DiscountType.percentage) return discountValue.round();
    final price = originalPrice;
    if (discountType == DiscountType.fixedAmount &&
        price != null &&
        price > 0) {
      return (discountValue / price * 100).round();
    }
    return null;
  }

  /// When the offer stops being available as seen from [now]: the end of
  /// today's flash window if that comes first, otherwise [endDate].
  DateTime endsAt(DateTime now) {
    final endMinute = dailyEndMinute;
    if (endMinute == null) return endDate;
    final today = DateTime(now.year, now.month, now.day);
    final windowEnd = today.add(Duration(minutes: endMinute));
    return windowEnd.isBefore(endDate) ? windowEnd : endDate;
  }

  /// Whether the offer can be taken at [now] (validity period + flash window).
  bool isAvailableAt(DateTime now) {
    if (!now.isBefore(endDate)) return false;
    final startMinute = dailyStartMinute;
    final endMinute = dailyEndMinute;
    if (endMinute == null) return true;
    if (repeatWeekdays.isNotEmpty && !repeatWeekdays.contains(now.weekday)) {
      return false;
    }
    final minute = now.hour * 60 + now.minute;
    return minute >= (startMinute ?? 0) && minute < endMinute;
  }

  /// Great-circle distance to the business, or `null` without coordinates.
  double? distanceMetersTo(double latitude, double longitude) {
    final lat = businessLatitude;
    final lng = businessLongitude;
    if (lat == null || lng == null) return null;
    const earthRadius = 6371000.0;
    double rad(double deg) => deg * math.pi / 180;
    final dLat = rad(latitude - lat);
    final dLng = rad(longitude - lng);
    final a =
        math.pow(math.sin(dLat / 2), 2) +
        math.cos(rad(lat)) *
            math.cos(rad(latitude)) *
            math.pow(math.sin(dLng / 2), 2);
    return earthRadius * 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
  }

  @override
  List<Object?> get props => [
    id,
    businessId,
    businessName,
    title,
    description,
    discountType,
    discountValue,
    endDate,
    imageUrl,
    categoryName,
    categoryIcon,
    businessWhatsapp,
    businessLatitude,
    businessLongitude,
    originalPrice,
    currency,
    stock,
    dailyStartMinute,
    dailyEndMinute,
    repeatWeekdays,
  ];
}
