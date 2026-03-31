import 'package:equatable/equatable.dart';

import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart';
import '../../domain/entities/inventory_location.dart';
import '../../domain/entities/inventory_transaction.dart';

class PurchaseLineModel extends Equatable {
  const PurchaseLineModel({
    required this.productId,
    required this.quantity,
    required this.unitCost,
    required this.lineTotal,
  });

  final String productId;
  final double quantity;
  final double unitCost;
  final double lineTotal;

  PurchaseLine toEntity() => PurchaseLine(
        productId: productId,
        quantity: quantity,
        unitCost: unitCost,
        lineTotal: lineTotal,
      );

  @override
  List<Object?> get props => [productId, quantity, unitCost, lineTotal];
}

class PurchaseModel extends Equatable {
  const PurchaseModel({
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
  final String locationType;
  final DateTime date;
  final String? referenceCode;
  final String? supplierName;
  final String? createdByEmployeeId;
  final String? notes;
  final List<PurchaseLineModel> lines;

  double get totalCost =>
      lines.fold(0, (value, line) => value + line.lineTotal);

  Purchase toEntity() => Purchase(
        id: id,
        locationId: locationId,
        locationType: InventoryLocationTypeX.fromLabel(locationType),
        date: date,
        referenceCode: referenceCode,
        supplierName: supplierName,
        createdByEmployeeId: createdByEmployeeId,
        notes: notes,
        lines: lines.map((line) => line.toEntity()).toList(),
      );

  factory PurchaseModel.fromEntity(Purchase entity) {
    return PurchaseModel(
      id: entity.id,
      locationId: entity.locationId,
      locationType: entity.locationType.label,
      date: entity.date,
      referenceCode: entity.referenceCode,
      supplierName: entity.supplierName,
      createdByEmployeeId: entity.createdByEmployeeId,
      notes: entity.notes,
      lines: entity.lines
          .map(
            (line) => PurchaseLineModel(
              productId: line.productId,
              quantity: line.quantity,
              unitCost: line.unitCost,
              lineTotal: line.lineTotal,
            ),
          )
          .toList(),
    );
  }

  PurchaseHeadersTableCompanion toHeaderCompanion({DateTime? timestamp}) {
    final now = timestamp ?? DateTime.now().toUtc();
    return PurchaseHeadersTableCompanion(
      id: Value(id),
      locationId: Value(locationId),
      locationType: Value(locationType),
      supplierName: Value(supplierName),
      referenceCode: Value(referenceCode),
      createdByEmployeeId: Value(createdByEmployeeId),
      purchaseDate: Value(date),
      totalCost: Value(totalCost),
      notes: Value(notes),
      createdAt: Value(now),
      updatedAt: Value(now),
    );
  }

  List<PurchaseItemsTableCompanion> toItemsCompanions() {
    return lines
        .map(
          (line) => PurchaseItemsTableCompanion(
            id: Value('${id}_${line.productId}'),
            purchaseId: Value(id),
            productId: Value(line.productId),
            quantity: Value(line.quantity),
            unitCost: Value(line.unitCost),
            totalCost: Value(line.lineTotal),
          ),
        )
        .toList();
  }

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

class SaleLineModel extends Equatable {
  const SaleLineModel({
    required this.productId,
    required this.quantity,
    required this.unitPrice,
    required this.lineTotal,
  });

  final String productId;
  final double quantity;
  final double unitPrice;
  final double lineTotal;

  SaleLine toEntity() => SaleLine(
        productId: productId,
        quantity: quantity,
        unitPrice: unitPrice,
        lineTotal: lineTotal,
      );

  @override
  List<Object?> get props => [productId, quantity, unitPrice, lineTotal];
}

class SaleModel extends Equatable {
  const SaleModel({
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
  final List<SaleLineModel> lines;

  double get totalAmount =>
      lines.fold(0, (value, line) => value + line.lineTotal);

  Sale toEntity() => Sale(
        id: id,
        storeId: storeId,
        date: date,
        referenceCode: referenceCode,
        customerName: customerName,
        createdByEmployeeId: createdByEmployeeId,
        notes: notes,
        lines: lines.map((line) => line.toEntity()).toList(),
      );

  factory SaleModel.fromEntity(Sale entity) {
    return SaleModel(
      id: entity.id,
      storeId: entity.storeId,
      date: entity.date,
      referenceCode: entity.referenceCode,
      customerName: entity.customerName,
      createdByEmployeeId: entity.createdByEmployeeId,
      notes: entity.notes,
      lines: entity.lines
          .map(
            (line) => SaleLineModel(
              productId: line.productId,
              quantity: line.quantity,
              unitPrice: line.unitPrice,
              lineTotal: line.lineTotal,
            ),
          )
          .toList(),
    );
  }

  SalesHeadersTableCompanion toHeaderCompanion({DateTime? timestamp}) {
    final now = timestamp ?? DateTime.now().toUtc();
    return SalesHeadersTableCompanion(
      id: Value(id),
      storeId: Value(storeId),
      referenceCode: Value(referenceCode),
      customerName: Value(customerName),
      createdByEmployeeId: Value(createdByEmployeeId),
      saleDate: Value(date),
      totalAmount: Value(totalAmount),
      notes: Value(notes),
      createdAt: Value(now),
      updatedAt: Value(now),
    );
  }

  List<SalesItemsTableCompanion> toItemsCompanions() {
    return lines
        .map(
          (line) => SalesItemsTableCompanion(
            id: Value('${id}_${line.productId}'),
            saleId: Value(id),
            productId: Value(line.productId),
            quantity: Value(line.quantity),
            unitPrice: Value(line.unitPrice),
            totalPrice: Value(line.lineTotal),
          ),
        )
        .toList();
  }

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

class TransferLineModel extends Equatable {
  const TransferLineModel({
    required this.productId,
    required this.quantity,
  });

  final String productId;
  final double quantity;

  TransferLine toEntity() =>
      TransferLine(productId: productId, quantity: quantity);

  @override
  List<Object?> get props => [productId, quantity];
}

class TransferModel extends Equatable {
  const TransferModel({
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
  final String originLocationType;
  final String destinationLocationId;
  final String destinationLocationType;
  final DateTime date;
  final String? requestedByEmployeeId;
  final String status;
  final String? notes;
  final List<TransferLineModel> lines;

  InventoryTransfer toEntity() => InventoryTransfer(
        id: id,
        originLocationId: originLocationId,
        originLocationType: InventoryLocationTypeX.fromLabel(originLocationType),
        destinationLocationId: destinationLocationId,
        destinationLocationType:
            InventoryLocationTypeX.fromLabel(destinationLocationType),
        date: date,
        requestedByEmployeeId: requestedByEmployeeId,
        status: status,
        notes: notes,
        lines: lines.map((line) => line.toEntity()).toList(),
      );

  factory TransferModel.fromEntity(InventoryTransfer entity) {
    return TransferModel(
      id: entity.id,
      originLocationId: entity.originLocationId,
      originLocationType: entity.originLocationType.label,
      destinationLocationId: entity.destinationLocationId,
      destinationLocationType: entity.destinationLocationType.label,
      date: entity.date,
      requestedByEmployeeId: entity.requestedByEmployeeId,
      status: entity.status,
      notes: entity.notes,
      lines: entity.lines
          .map(
            (line) => TransferLineModel(
              productId: line.productId,
              quantity: line.quantity,
            ),
          )
          .toList(),
    );
  }

  TransferHeadersTableCompanion toHeaderCompanion({DateTime? timestamp}) {
    final now = timestamp ?? DateTime.now().toUtc();
    return TransferHeadersTableCompanion(
      id: Value(id),
      originLocationId: Value(originLocationId),
      originLocationType: Value(originLocationType),
      destinationLocationId: Value(destinationLocationId),
      destinationLocationType: Value(destinationLocationType),
      requestedByEmployeeId: Value(requestedByEmployeeId),
      transferDate: Value(date),
      status: Value(status),
      notes: Value(notes),
      createdAt: Value(now),
      updatedAt: Value(now),
    );
  }

  List<TransferItemsTableCompanion> toItemsCompanions() {
    return lines
        .map(
          (line) => TransferItemsTableCompanion(
            id: Value('${id}_${line.productId}'),
            transferId: Value(id),
            productId: Value(line.productId),
            quantity: Value(line.quantity),
          ),
        )
        .toList();
  }

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

class InventoryMovementModel extends Equatable {
  const InventoryMovementModel({
    required this.id,
    required this.productId,
    this.locationId,
    this.locationType,
    required this.quantity,
    required this.movementType,
    this.referenceType,
    this.referenceId,
    this.createdBy,
    required this.occurredAt,
    this.notes,
    this.syncedAt,
  });

  final String id;
  final String productId;
  final String? locationId;
  final String? locationType;
  final double quantity;
  final String movementType;
  final String? referenceType;
  final String? referenceId;
  final String? createdBy;
  final DateTime occurredAt;
  final String? notes;
  final DateTime? syncedAt;

  InventoryMovement toEntity() => InventoryMovement(
        id: id,
        productId: productId,
        locationId: locationId,
        locationType:
            locationType != null ? InventoryLocationTypeX.fromLabel(locationType!) : null,
        quantity: quantity,
        movementType: InventoryMovementTypeX.fromLabel(movementType),
        referenceType: referenceType,
        referenceId: referenceId,
        createdBy: createdBy,
        occurredAt: occurredAt,
        notes: notes,
      );

  factory InventoryMovementModel.fromTable(InventoryMovementsTableData data) {
    return InventoryMovementModel(
      id: data.id,
      productId: data.productId,
      locationId: data.locationId,
      locationType: data.locationType,
      quantity: data.quantity,
      movementType: data.movementType,
      referenceType: data.referenceType,
      referenceId: data.referenceId,
      createdBy: data.createdBy,
      occurredAt: data.occurredAt,
      notes: data.notes,
      syncedAt: data.syncedAt,
    );
  }

  InventoryMovementsTableCompanion toCompanion() {
    return InventoryMovementsTableCompanion(
      id: Value(id),
      productId: Value(productId),
      locationId: Value(locationId),
      locationType: Value(locationType),
      quantity: Value(quantity),
      movementType: Value(movementType),
      referenceType: Value(referenceType),
      referenceId: Value(referenceId),
      createdBy: Value(createdBy),
      occurredAt: Value(occurredAt),
      notes: Value(notes),
      syncedAt: Value(syncedAt),
    );
  }

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
        syncedAt,
      ];
}
