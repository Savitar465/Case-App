import 'package:equatable/equatable.dart';

import 'discount_type.dart';

class Offer extends Equatable {
  const Offer({
    required this.id,
    required this.businessId,
    required this.title,
    required this.description,
    required this.discountType,
    required this.discountValue,
    required this.startDate,
    required this.endDate,
    required this.isActive,
    required this.createdAt,
    required this.createdBy,
    this.imageUrl,
    this.updatedAt,
    this.updatedBy,
  });

  final String id;
  final String businessId;
  final String title;
  final String description;
  final DiscountType discountType;
  final double discountValue;
  final DateTime startDate;
  final DateTime endDate;
  final String? imageUrl;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String createdBy;
  final String? updatedBy;

  @override
  List<Object?> get props => [
    id,
    businessId,
    title,
    description,
    discountType,
    discountValue,
    startDate,
    endDate,
    imageUrl,
    isActive,
    createdAt,
    updatedAt,
    createdBy,
    updatedBy,
  ];
}
