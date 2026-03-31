import 'package:equatable/equatable.dart';

import '../../domain/entities/inventory_report.dart';

class SalesReportRow extends Equatable {
  const SalesReportRow({
    required this.saleId,
    required this.storeId,
    required this.storeName,
    required this.saleDate,
    required this.totalAmount,
  });

  final String saleId;
  final String storeId;
  final String storeName;
  final DateTime saleDate;
  final double totalAmount;

  SalesReportEntry toEntity() => SalesReportEntry(
        saleId: saleId,
        storeId: storeId,
        storeName: storeName,
        saleDate: saleDate,
        totalAmount: totalAmount,
      );

  @override
  List<Object?> get props => [saleId, storeId, storeName, saleDate, totalAmount];
}

class PurchaseReportRow extends Equatable {
  const PurchaseReportRow({
    required this.purchaseId,
    required this.locationId,
    required this.locationName,
    required this.purchaseDate,
    required this.totalCost,
  });

  final String purchaseId;
  final String locationId;
  final String locationName;
  final DateTime purchaseDate;
  final double totalCost;

  PurchaseReportEntry toEntity() => PurchaseReportEntry(
        purchaseId: purchaseId,
        locationId: locationId,
        locationName: locationName,
        purchaseDate: purchaseDate,
        totalCost: totalCost,
      );

  @override
  List<Object?> get props =>
      [purchaseId, locationId, locationName, purchaseDate, totalCost];
}

class TransferReportRow extends Equatable {
  const TransferReportRow({
    required this.transferId,
    required this.originName,
    required this.destinationName,
    required this.transferDate,
    required this.productCount,
  });

  final String transferId;
  final String originName;
  final String destinationName;
  final DateTime transferDate;
  final int productCount;

  TransferReportEntry toEntity() => TransferReportEntry(
        transferId: transferId,
        originName: originName,
        destinationName: destinationName,
        transferDate: transferDate,
        productCount: productCount,
      );

  @override
  List<Object?> get props =>
      [transferId, originName, destinationName, transferDate, productCount];
}

class DailySalesSummaryModel extends Equatable {
  const DailySalesSummaryModel({required this.date, required this.totalAmount});

  final DateTime date;
  final double totalAmount;

  DailySalesSummary toEntity() =>
      DailySalesSummary(date: date, totalAmount: totalAmount);

  @override
  List<Object?> get props => [date, totalAmount];
}
