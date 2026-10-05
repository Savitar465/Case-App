import 'dart:math' as math;

import 'package:equatable/equatable.dart';

import 'opening_hours.dart';

class Business extends Equatable {
  const Business({
    required this.id,
    required this.name,
    required this.address,
    this.categoryId,
    this.description,
    this.phone,
    this.latitude,
    this.longitude,
    this.isPro = false,
    this.isFeatured = false,
    this.status = 'pending',
    this.viewsCount = 0,
    this.imageUrls = const [],
    this.rating = 0,
    this.reviewCount = 0,
    this.openingHours = const OpeningHours(),
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String name;
  final String address;
  final String? categoryId;
  final String? description;
  final String? phone;
  final double? latitude;
  final double? longitude;
  final bool isPro;
  final bool isFeatured;
  final String status;
  final int viewsCount;

  /// Public image URLs, cover first.
  final List<String> imageUrls;

  /// Average review rating (0 when there are no reviews).
  final double rating;
  final int reviewCount;
  final OpeningHours openingHours;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  String? get coverUrl => imageUrls.isEmpty ? null : imageUrls.first;

  bool get hasLocation =>
      latitude != null &&
      longitude != null &&
      !(latitude == 0 && longitude == 0);

  /// Great-circle distance in meters to the given point, or null when this
  /// business has no stored location.
  double? distanceMetersTo(double lat, double lng) {
    if (!hasLocation) return null;
    const earthRadius = 6371000.0;
    double rad(double deg) => deg * math.pi / 180;
    final dLat = rad(lat - latitude!);
    final dLng = rad(lng - longitude!);
    final a =
        math.pow(math.sin(dLat / 2), 2) +
        math.cos(rad(latitude!)) *
            math.cos(rad(lat)) *
            math.pow(math.sin(dLng / 2), 2);
    return earthRadius * 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
  }

  @override
  List<Object?> get props => [
    id,
    name,
    address,
    categoryId,
    description,
    phone,
    latitude,
    longitude,
    isPro,
    isFeatured,
    status,
    viewsCount,
    imageUrls,
    rating,
    reviewCount,
    openingHours,
    createdAt,
    updatedAt,
  ];
}
