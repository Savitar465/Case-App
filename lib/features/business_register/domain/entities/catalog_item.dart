import 'package:equatable/equatable.dart';

import 'catalog_item_draft.dart';

/// A stored product or service, as the owner manages it.
class CatalogItem extends Equatable {
  const CatalogItem({
    required this.id,
    required this.businessId,
    required this.kind,
    required this.name,
    required this.price,
    required this.isActive,
    this.description,
    this.stock,
    this.photoUrl,
    this.photoStoragePath,
    this.imageId,
  });

  final String id;
  final String businessId;
  final CatalogItemKind kind;
  final String name;
  final double price;

  /// Paused items stay in the owner's list but are hidden from customers.
  final bool isActive;
  final String? description;

  /// Available quantity; null means unlimited.
  final int? stock;

  /// Public URL of the item's first photo, if any.
  final String? photoUrl;

  /// Bucket path of that photo (null for external URLs).
  final String? photoStoragePath;

  /// `item_images.id` of that photo.
  final String? imageId;

  @override
  List<Object?> get props => [
    id,
    businessId,
    kind,
    name,
    price,
    isActive,
    description,
    stock,
    photoUrl,
    photoStoragePath,
    imageId,
  ];
}
