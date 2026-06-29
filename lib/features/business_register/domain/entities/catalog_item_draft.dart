import 'package:equatable/equatable.dart';

/// Whether a catalog entry is a service or a product (the two forms in the
/// designs share the same shape).
enum CatalogItemKind { service, product }

extension CatalogItemKindX on CatalogItemKind {
  String get singular =>
      this == CatalogItemKind.service ? 'servicio' : 'producto';
  String get title => this == CatalogItemKind.service ? 'Servicio' : 'Producto';
}

/// A service or product the owner adds during registration (designs img_9 /
/// img_10).
class CatalogItemDraft extends Equatable {
  const CatalogItemDraft({
    required this.id,
    required this.kind,
    required this.name,
    this.price,
    this.hasDiscount = false,
    this.discountPrice,
    this.description,
    this.photoCount = 0,
  });

  final String id;
  final CatalogItemKind kind;
  final String name;
  final double? price;
  final bool hasDiscount;
  final double? discountPrice;
  final String? description;
  final int photoCount;

  @override
  List<Object?> get props => [
    id,
    kind,
    name,
    price,
    hasDiscount,
    discountPrice,
    description,
    photoCount,
  ];
}
