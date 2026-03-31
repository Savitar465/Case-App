import 'package:equatable/equatable.dart';

import 'inventory_location.dart';

enum InventoryMovementType {
  purchaseIn,
  saleOut,
  transferOut,
  transferIn,
  adjustment,
}

extension InventoryMovementTypeX on InventoryMovementType {
  String get label => switch (this) {
        InventoryMovementType.purchaseIn => 'purchase_in',
        InventoryMovementType.saleOut => 'sale_out',
        InventoryMovementType.transferOut => 'transfer_out',
        InventoryMovementType.transferIn => 'transfer_in',
        InventoryMovementType.adjustment => 'adjustment',
      };

  static InventoryMovementType fromLabel(String value) {
    switch (value) {
      case 'sale_out':
        return InventoryMovementType.saleOut;
      case 'transfer_out':
        return InventoryMovementType.transferOut;
      case 'transfer_in':
        return InventoryMovementType.transferIn;
      case 'adjustment':
        return InventoryMovementType.adjustment;
      case 'purchase_in':
      default:
        return InventoryMovementType.purchaseIn;
    }
  }
}

class PurchaseLine extends Equatable {
  const PurchaseLine({
    required this.productId,
    required this.quantity,
    required this.unitCost,
    double? lineTotal,
  }) : lineTotal = lineTotal ?? quantity * unitCost;

  final String productId;
  final double quantity;
  final double unitCost;
  final double lineTotal;

  @override
  List<Object?> get props => [productId, quantity, unitCost, lineTotal];
}

class Purchase extends Equatable {
  const Purchase({
    required this.id,
    required this.locationId,
    required this.locationType,
    required this.date,
    this.referenceCode,
    this.supplierName,
    this.createdByEmployeeId,
    this.notes,
    this.lines = const [],
  });

  final String id;
  final String locationId;
  final InventoryLocationType locationType;
  final DateTime date;
  final String? referenceCode;
  final String? supplierName;
  final String? createdByEmployeeId;
  final String? notes;
  final List<PurchaseLine> lines;

  double get totalCost => lines.fold(0, (value, line) => value + line.lineTotal);

  @override
  List<Object?> get props => [
        id,
        locationId,
        locationType,
        date,
        referenceCode,
        supplierName,
        createdByEmployeeId,
        notes,
        lines,
      ];
}

class SaleLine extends Equatable {
  const SaleLine({
    required this.productId,
    required this.quantity,
    required this.unitPrice,
    double? lineTotal,
  }) : lineTotal = lineTotal ?? quantity * unitPrice;

  final String productId;
  final double quantity;
  final double unitPrice;
  final double lineTotal;

  @override
  List<Object?> get props => [productId, quantity, unitPrice, lineTotal];
}

class Sale extends Equatable {
  const Sale({
    required this.id,
    required this.storeId,
    required this.date,
    this.referenceCode,
    this.customerName,
    this.createdByEmployeeId,
    this.notes,
    this.lines = const [],
  });

  final String id;
  final String storeId;
  final DateTime date;
  final String? referenceCode;
  final String? customerName;
  final String? createdByEmployeeId;
  final String? notes;
  final List<SaleLine> lines;

  double get totalAmount => lines.fold(0, (value, line) => value + line.lineTotal);

  @override
  List<Object?> get props => [
        id,
        storeId,
        date,
        referenceCode,
        customerName,
        createdByEmployeeId,
        notes,
        lines,
      ];
}

class TransferLine extends Equatable {
  const TransferLine({
    required this.productId,
    required this.quantity,
  });

  final String productId;
  final double quantity;

  @override
  List<Object?> get props => [productId, quantity];
}

class InventoryTransfer extends Equatable {
  const InventoryTransfer({
    required this.id,
    required this.originLocationId,
    required this.originLocationType,
    required this.destinationLocationId,
    required this.destinationLocationType,
    required this.date,
    this.requestedByEmployeeId,
    this.status = 'completed',
    this.notes,
    this.lines = const [],
  });

  final String id;
  final String originLocationId;
  final InventoryLocationType originLocationType;
  final String destinationLocationId;
  final InventoryLocationType destinationLocationType;
  final DateTime date;
  final String? requestedByEmployeeId;
  final String status;
  final String? notes;
  final List<TransferLine> lines;

  bool get isCompleted => status == 'completed';

  @override
  List<Object?> get props => [
        id,
        originLocationId,
        originLocationType,
        destinationLocationId,
        destinationLocationType,
        date,
        requestedByEmployeeId,
        status,
        notes,
        lines,
      ];
}

class InventoryMovement extends Equatable {
  const InventoryMovement({
    required this.id,
    required this.productId,
    required this.locationId,
    required this.locationType,
    required this.quantity,
    required this.movementType,
    this.referenceType,
    this.referenceId,
    this.createdBy,
    required this.occurredAt,
    this.notes,
  });

  final String id;
  final String productId;
  final String? locationId;
  final InventoryLocationType? locationType;
  final double quantity;
  final InventoryMovementType movementType;
  final String? referenceType;
  final String? referenceId;
  final String? createdBy;
  final DateTime occurredAt;
  final String? notes;

  @override
  List<Object?> get props => [
        id,
        productId,
        locationId,
        locationType,
        quantity,
        movementType,
        referenceType,
        referenceId,
        createdBy,
        occurredAt,
        notes,
      ];
}
