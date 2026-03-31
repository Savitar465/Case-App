import 'package:equatable/equatable.dart';

import '../../domain/entities/inventory_location.dart';
import '../../domain/entities/inventory_stock.dart';

class InventoryStockModel extends Equatable {
  const InventoryStockModel({
    required this.productId,
    required this.productName,
    required this.locationId,
    required this.locationType,
    required this.quantityOnHand,
    this.quantityReserved = 0,
    this.locationName,
    this.unit,
    this.updatedAt,
  });

  final String productId;
  final String productName;
  final String locationId;
  final String locationType;
  final double quantityOnHand;
  final double quantityReserved;
  final String? locationName;
  final String? unit;
  final DateTime? updatedAt;

  InventoryStock toEntity() {
    return InventoryStock(
      productId: productId,
      productName: productName,
      unit: unit,
      locationId: locationId,
      locationType: InventoryLocationTypeX.fromLabel(locationType),
      locationName: locationName,
      quantityOnHand: quantityOnHand,
      quantityReserved: quantityReserved,
      updatedAt: updatedAt,
    );
  }

  InventoryStockModel copyWith({
    String? productId,
    String? productName,
    String? locationId,
    String? locationType,
    double? quantityOnHand,
    double? quantityReserved,
    String? locationName,
    String? unit,
    DateTime? updatedAt,
  }) {
    return InventoryStockModel(
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      locationId: locationId ?? this.locationId,
      locationType: locationType ?? this.locationType,
      quantityOnHand: quantityOnHand ?? this.quantityOnHand,
      quantityReserved: quantityReserved ?? this.quantityReserved,
      locationName: locationName ?? this.locationName,
      unit: unit ?? this.unit,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory InventoryStockModel.fromData({
    required String productId,
    required String productName,
    required String locationId,
    required String locationType,
    required double quantityOnHand,
    double quantityReserved = 0,
    String? locationName,
    String? unit,
    DateTime? updatedAt,
  }) {
    return InventoryStockModel(
      productId: productId,
      productName: productName,
      locationId: locationId,
      locationType: locationType,
      quantityOnHand: quantityOnHand,
      quantityReserved: quantityReserved,
      locationName: locationName,
      unit: unit,
      updatedAt: updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        productId,
        productName,
        locationId,
        locationType,
        quantityOnHand,
        quantityReserved,
        locationName,
        unit,
        updatedAt,
      ];
}

