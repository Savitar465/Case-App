import 'package:equatable/equatable.dart';

/// An active offer as shown in the home "Ofertas cerca de ti" carousel.
class HomeOffer extends Equatable {
  const HomeOffer({
    required this.id,
    required this.businessId,
    required this.businessName,
    required this.title,
    required this.discountType,
    required this.discountValue,
    required this.endDate,
    this.description = '',
    this.imageUrl,
    this.isFlash = false,
  });

  final String id;
  final String businessId;
  final String businessName;
  final String title;
  final String description;

  /// Raw `discount_type` label (`percentage`, `fixed_amount`, `2x1`, ...).
  final String discountType;
  final double discountValue;
  final DateTime endDate;
  final String? imageUrl;

  /// Flash offers are tied to a daily time window.
  final bool isFlash;

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
    isFlash,
  ];
}
