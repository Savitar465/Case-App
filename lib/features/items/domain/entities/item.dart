import 'package:equatable/equatable.dart';

import 'item_image.dart';
import 'item_type.dart';

class Item extends Equatable {
  const Item({
    required this.id,
    required this.businessId,
    required this.type,
    required this.name,
    required this.price,
    required this.currency,
    required this.isActive,
    required this.createdAt,
    required this.createdBy,
    this.description,
    this.duration,
    this.categoryId,
    this.updatedAt,
    this.updatedBy,
    this.images = const [],
  });

  final String id;
  final String businessId;
  final ItemType type;
  final String name;
  final String? description;
  final double price;
  final String currency;
  final int? duration;
  final String? categoryId;
  final bool isActive;
  final List<ItemImage> images;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String createdBy;
  final String? updatedBy;

  @override
  List<Object?> get props => [
    id,
    businessId,
    type,
    name,
    description,
    price,
    currency,
    duration,
    categoryId,
    isActive,
    images,
    createdAt,
    updatedAt,
    createdBy,
    updatedBy,
  ];
}
