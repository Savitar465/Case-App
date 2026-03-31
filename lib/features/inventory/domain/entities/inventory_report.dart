import 'package:equatable/equatable.dart';

class DateRange extends Equatable {
  DateRange({required this.start, required this.end})
      : assert(!end.isBefore(start), 'End date must not be before start');

  final DateTime start;
  final DateTime end;

  bool contains(DateTime date) =>
      !date.isBefore(start) && !date.isAfter(end);

  @override
  List<Object?> get props => [start, end];
}

class SalesReportEntry extends Equatable {
  const SalesReportEntry({
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

  @override
  List<Object?> get props => [saleId, storeId, storeName, saleDate, totalAmount];
}

class PurchaseReportEntry extends Equatable {
  const PurchaseReportEntry({
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

  @override
  List<Object?> get props =>
      [purchaseId, locationId, locationName, purchaseDate, totalCost];
}

class TransferReportEntry extends Equatable {
  const TransferReportEntry({
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

  @override
  List<Object?> get props =>
      [transferId, originName, destinationName, transferDate, productCount];
}

class DailySalesSummary extends Equatable {
  const DailySalesSummary({required this.date, required this.totalAmount});

  final DateTime date;
  final double totalAmount;

  @override
  List<Object?> get props => [date, totalAmount];
}

