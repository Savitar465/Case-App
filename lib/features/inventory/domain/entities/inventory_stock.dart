import 'package:equatable/equatable.dart';

import 'inventory_location.dart';

class InventoryStock extends Equatable {
  const InventoryStock({
    required this.productId,
    required this.productName,
    required this.locationId,
    required this.locationType,
    required this.quantityOnHand,
    this.quantityReserved = 0,
    this.locationName,
    this.updatedAt,
    this.unit,
  });

  final String productId;
  final String productName;
  final String? unit;
  final String locationId;
  final InventoryLocationType locationType;
  final String? locationName;
  final double quantityOnHand;
  final double quantityReserved;
  final DateTime? updatedAt;

  InventoryStock copyWith({
    String? productId,
    String? productName,
    String? unit,
    String? locationId,
    InventoryLocationType? locationType,
    String? locationName,
    double? quantityOnHand,
    double? quantityReserved,
    DateTime? updatedAt,
  }) {
    return InventoryStock(
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      unit: unit ?? this.unit,
      locationId: locationId ?? this.locationId,
      locationType: locationType ?? this.locationType,
      locationName: locationName ?? this.locationName,
      quantityOnHand: quantityOnHand ?? this.quantityOnHand,
      quantityReserved: quantityReserved ?? this.quantityReserved,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        productId,
        productName,
        unit,
        locationId,
        locationType,
        locationName,
        quantityOnHand,
        quantityReserved,
        updatedAt,
      ];
}
