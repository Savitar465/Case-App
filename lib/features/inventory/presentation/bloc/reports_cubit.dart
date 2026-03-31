import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/inventory_report.dart';
import '../../domain/repositories/inventory_repository.dart';

class InventoryReportsState extends Equatable {
  const InventoryReportsState({
    this.sales = const [],
    this.purchases = const [],
    this.transfers = const [],
    this.salesFilter,
    this.purchaseFilter,
    this.transferFilter,
    this.error,
  });

  final List<SalesReportEntry> sales;
  final List<PurchaseReportEntry> purchases;
  final List<TransferReportEntry> transfers;
  final ReportsFilter? salesFilter;
  final ReportsFilter? purchaseFilter;
  final ReportsFilter? transferFilter;
  final String? error;

  InventoryReportsState copyWith({
    List<SalesReportEntry>? sales,
    List<PurchaseReportEntry>? purchases,
    List<TransferReportEntry>? transfers,
    ReportsFilter? salesFilter,
    ReportsFilter? purchaseFilter,
    ReportsFilter? transferFilter,
    String? error,
  }) {
    return InventoryReportsState(
      sales: sales ?? this.sales,
      purchases: purchases ?? this.purchases,
      transfers: transfers ?? this.transfers,
      salesFilter: salesFilter ?? this.salesFilter,
      purchaseFilter: purchaseFilter ?? this.purchaseFilter,
      transferFilter: transferFilter ?? this.transferFilter,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
        sales,
        purchases,
        transfers,
        salesFilter,
        purchaseFilter,
        transferFilter,
        error,
      ];
}

class ReportsFilter extends Equatable {
  const ReportsFilter({this.locationId, this.dateRange});

  final String? locationId;
  final DateRange? dateRange;

  ReportsFilter copyWith({String? locationId, DateRange? dateRange}) {
    return ReportsFilter(
      locationId: locationId ?? this.locationId,
      dateRange: dateRange ?? this.dateRange,
    );
  }

  @override
  List<Object?> get props => [locationId, dateRange];
}

class InventoryReportsCubit extends Cubit<InventoryReportsState> {
  InventoryReportsCubit({required InventoryRepository repository})
      : _repository = repository,
        super(const InventoryReportsState());

  final InventoryRepository _repository;
  StreamSubscription<List<SalesReportEntry>>? _salesSub;
  StreamSubscription<List<PurchaseReportEntry>>? _purchaseSub;
  StreamSubscription<List<TransferReportEntry>>? _transferSub;

  void initialize() {
    _watchSales();
    _watchPurchases();
    _watchTransfers();
  }

  void updateSalesFilter(ReportsFilter filter) {
    emit(state.copyWith(salesFilter: filter));
    _watchSales(filter: filter);
  }

  void updatePurchaseFilter(ReportsFilter filter) {
    emit(state.copyWith(purchaseFilter: filter));
    _watchPurchases(filter: filter);
  }

  void updateTransferFilter(ReportsFilter filter) {
    emit(state.copyWith(transferFilter: filter));
    _watchTransfers(filter: filter);
  }

  void _watchSales({ReportsFilter? filter}) {
    _salesSub?.cancel();
    _salesSub = _repository
        .watchSalesReport(
          storeId: filter?.locationId,
          range: filter?.dateRange,
        )
        .listen((entries) {
      emit(state.copyWith(sales: entries, error: null));
    }, onError: (error, stackTrace) {
      emit(state.copyWith(error: error.toString()));
    });
  }

  void _watchPurchases({ReportsFilter? filter}) {
    _purchaseSub?.cancel();
    _purchaseSub = _repository
        .watchPurchaseReport(
          locationId: filter?.locationId,
          range: filter?.dateRange,
        )
        .listen((entries) {
      emit(state.copyWith(purchases: entries, error: null));
    }, onError: (error, stackTrace) {
      emit(state.copyWith(error: error.toString()));
    });
  }

  void _watchTransfers({ReportsFilter? filter}) {
    _transferSub?.cancel();
    _transferSub = _repository
        .watchTransferReport(
          originId: filter?.locationId,
          destinationId: filter?.locationId,
          range: filter?.dateRange,
        )
        .listen((entries) {
      emit(state.copyWith(transfers: entries, error: null));
    }, onError: (error, stackTrace) {
      emit(state.copyWith(error: error.toString()));
    });
  }

  @override
  Future<void> close() async {
    await _salesSub?.cancel();
    await _purchaseSub?.cancel();
    await _transferSub?.cancel();
    return super.close();
  }
}
