import 'package:market_app/features/products/domain/repositories/product_repository.dart';
import 'package:market_app/features/inventory/domain/entities/employee.dart';
import 'package:market_app/features/inventory/domain/entities/inventory_location.dart';
import 'package:market_app/features/inventory/domain/entities/inventory_report.dart';
import 'package:market_app/features/inventory/domain/entities/inventory_stock.dart';
import 'package:market_app/features/inventory/domain/entities/inventory_transaction.dart';

import '../../domain/repositories/inventory_repository.dart';
import '../datasources/local/inventory_local_data_source.dart';
import '../datasources/remote/inventory_remote_data_source.dart';
import '../models/employee_model.dart';
import '../models/inventory_location_model.dart';
import '../models/inventory_transaction_model.dart';

class InventoryRepositoryImpl implements InventoryRepository {
  InventoryRepositoryImpl({
    required InventoryLocalDataSource localDataSource,
    InventoryRemoteDataSource? remoteDataSource,
    ProductRepository? productRepository,
  }) : _localDataSource = localDataSource,
       _remoteDataSource = remoteDataSource,
       _productRepository = productRepository;

  final InventoryLocalDataSource _localDataSource;
  final InventoryRemoteDataSource? _remoteDataSource;
  final ProductRepository? _productRepository;

  @override
  Stream<List<InventoryLocation>> watchLocations(InventoryLocationType type) {
    return _localDataSource
        .watchLocations(type.label)
        .map((models) => models.map((model) => model.toEntity()).toList());
  }

  @override
  Future<void> saveLocation(InventoryLocation location) async {
    final now = DateTime.now().toUtc();
    final model = InventoryLocationModel.fromEntity(
      location,
    ).copyWith(createdAt: location.createdAt ?? now, updatedAt: now);
    await _localDataSource.upsertLocation(model);
    // Best-effort remote save
    if (_remoteDataSource != null) {
      try {
        await _remoteDataSource.upsertLocation(model);
        await _localDataSource.markLocationSynced(model.id, now);
      } catch (_) {
        // ignore network errors; will be retried by syncPendingChanges
      }
    }
  }

  @override
  Future<void> deleteLocation(String locationId) async {
    await _localDataSource.deleteLocation(locationId);
    if (_remoteDataSource != null) {
      try {
        await _remoteDataSource.deleteLocation(locationId);
      } catch (_) {
        // ignore - delete will reconcile on next full sync/prune
      }
    }
  }

  @override
  Stream<List<Employee>> watchEmployees({String? locationId}) {
    return _localDataSource
        .watchEmployees(locationId: locationId)
        .map((models) => models.map((model) => model.toEntity()).toList());
  }

  @override
  Future<void> saveEmployee(Employee employee) async {
    final model = EmployeeModel.fromEntity(employee);
    await _localDataSource.upsertEmployee(model);
    if (_remoteDataSource != null) {
      try {
        await _remoteDataSource.upsertEmployee(model);
        await _localDataSource.markEmployeeSynced(
          model.id,
          DateTime.now().toUtc(),
        );
      } catch (_) {}
    }
  }

  @override
  Future<void> deleteEmployee(String employeeId) async {
    await _localDataSource.deleteEmployee(employeeId);
    if (_remoteDataSource != null) {
      try {
        await _remoteDataSource.deleteEmployee(employeeId);
      } catch (_) {}
    }
  }

  @override
  Stream<List<InventoryStock>> watchInventory({
    String? locationId,
    InventoryLocationType? locationType,
  }) {
    return _localDataSource
        .watchInventory(
          locationId: locationId,
          locationType: locationType?.label,
        )
        .map((models) => models.map((model) => model.toEntity()).toList());
  }

  @override
  Future<List<InventoryStock>> fetchGlobalInventory() async {
    final models = await _localDataSource.fetchGlobalInventory();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<InventoryStock?> getStockForProduct({
    required String productId,
    required String locationId,
  }) async {
    final model = await _localDataSource.getStock(
      productId: productId,
      locationId: locationId,
    );
    return model?.toEntity();
  }

  @override
  Future<void> recordPurchase(Purchase purchase) async {
    final model = PurchaseModel.fromEntity(purchase);
    final stockKeys = <_StockKey>{
      for (final line in purchase.lines)
        _StockKey(productId: line.productId, locationId: purchase.locationId),
    };
    await _localDataSource.recordPurchase(model);
    if (_remoteDataSource != null) {
      await _pushStockSnapshots(stockKeys);
      try {
        await _remoteDataSource.savePurchase(model);
        await _localDataSource.markPurchaseSynced(
          model.id,
          DateTime.now().toUtc(),
        );
      } catch (_) {}
    }
  }

  @override
  Future<void> recordSale(Sale sale) async {
    final model = SaleModel.fromEntity(sale);
    final stockKeys = <_StockKey>{
      for (final line in sale.lines)
        _StockKey(productId: line.productId, locationId: sale.storeId),
    };
    await _localDataSource.recordSale(model);
    if (_remoteDataSource != null) {
      await _pushStockSnapshots(stockKeys);
      try {
        await _remoteDataSource.saveSale(model);
        await _localDataSource.markSaleSynced(model.id, DateTime.now().toUtc());
      } catch (_) {}
    }
  }

  @override
  Future<void> recordTransfer(InventoryTransfer transfer) async {
    final model = TransferModel.fromEntity(transfer);
    final stockKeys = <_StockKey>{};
    for (final line in transfer.lines) {
      stockKeys.add(
        _StockKey(
          productId: line.productId,
          locationId: transfer.originLocationId,
        ),
      );
      stockKeys.add(
        _StockKey(
          productId: line.productId,
          locationId: transfer.destinationLocationId,
        ),
      );
    }
    await _localDataSource.recordTransfer(model);
    if (_remoteDataSource != null) {
      await _pushStockSnapshots(stockKeys);
      try {
        await _remoteDataSource.saveTransfer(model);
        await _localDataSource.markTransferSynced(
          model.id,
          DateTime.now().toUtc(),
        );
      } catch (_) {}
    }
  }

  @override
  Stream<List<SalesReportEntry>> watchSalesReport({
    String? storeId,
    DateRange? range,
  }) {
    return _localDataSource
        .watchSalesReport(
          storeId: storeId,
          start: range?.start,
          end: range?.end,
        )
        .map((rows) => rows.map((row) => row.toEntity()).toList());
  }

  @override
  Stream<List<PurchaseReportEntry>> watchPurchaseReport({
    String? locationId,
    DateRange? range,
  }) {
    return _localDataSource
        .watchPurchaseReport(
          locationId: locationId,
          start: range?.start,
          end: range?.end,
        )
        .map((rows) => rows.map((row) => row.toEntity()).toList());
  }

  @override
  Stream<List<TransferReportEntry>> watchTransferReport({
    String? originId,
    String? destinationId,
    DateRange? range,
  }) {
    return _localDataSource
        .watchTransferReport(
          originId: originId,
          destinationId: destinationId,
          start: range?.start,
          end: range?.end,
        )
        .map((rows) => rows.map((row) => row.toEntity()).toList());
  }

  @override
  Stream<DailySalesSummary> watchDailySalesSummary(DateTime date) {
    return _localDataSource
        .watchDailySalesSummary(date)
        .map((model) => model.toEntity());
  }

  @override
  Future<double> fetchTodayGlobalSalesTotal() {
    return _localDataSource.fetchTodayGlobalSalesTotal();
  }

  @override
  Stream<List<InventoryMovement>> watchMovements({
    String? productId,
    String? locationId,
  }) {
    return _localDataSource
        .watchMovements(productId: productId, locationId: locationId)
        .map((models) => models.map((model) => model.toEntity()).toList());
  }

  @override
  Future<void> syncPendingChanges() async {
    if (_remoteDataSource == null) return;

    final remote = _remoteDataSource;
    final productRepository = _productRepository;

    if (productRepository != null) {
      try {
        await productRepository.syncProducts();
      } catch (error) {
        print(error);
      }
    }

    if (productRepository != null) {
      try {
        await productRepository.syncPendingOperations();
      } catch (error) {
        print(error);
      }
    }

    final unsyncedLocations = await _localDataSource
        .fetchUnsyncedLocationsForSync();
    final unsyncedEmployees = await _localDataSource
        .fetchUnsyncedEmployeesForSync();
    final unsyncedPurchases = await _localDataSource
        .fetchUnsyncedPurchasesForSync();
    final unsyncedMovements = await _localDataSource
        .fetchUnsyncedMovementsForSync();

    final remoteStockTimestamps = await _pullRemoteUpdates(
      remote: remote,
      pendingLocationIds: unsyncedLocations.map((loc) => loc.id).toSet(),
      pendingEmployeeIds: unsyncedEmployees.map((emp) => emp.id).toSet(),
    );



    for (final location in unsyncedLocations) {
      try {
        await remote.upsertLocation(location);
        await _localDataSource.markLocationSynced(
          location.id,
          DateTime.now().toUtc(),
        );
      } catch (_) {}
    }

    for (final employee in unsyncedEmployees) {
      try {
        await remote.upsertEmployee(employee);
        await _localDataSource.markEmployeeSynced(
          employee.id,
          DateTime.now().toUtc(),
        );
      } catch (error) {
        print(error);
      }
    }

    for (final purchase in unsyncedPurchases) {
      try {
        await remote.savePurchase(purchase);
        await _localDataSource.markPurchaseSynced(
          purchase.id,
          DateTime.now().toUtc(),
        );
      } catch (error) {
        print(error);
      }
    }

    if (unsyncedMovements.isNotEmpty) {
      try {
        await remote.upsertInventoryMovements(unsyncedMovements);
        final syncedAt = DateTime.now().toUtc();
        for (final movement in unsyncedMovements) {
          await _localDataSource.markMovementSynced(movement.id, syncedAt);
        }
      } catch (error) {
        print(error);
      }
    }

    final stocksForSync = await _localDataSource.fetchStocksForSync();
    print(stocksForSync);
    final stockPayload = <Map<String, dynamic>>[];
    for (final stock in stocksForSync) {
      final key = '${stock.productId}|${stock.locationId}';
      final remoteUpdatedAt = remoteStockTimestamps[key];
      final localUpdatedAt = stock.updatedAt;
      if (remoteUpdatedAt != null && !localUpdatedAt.isAfter(remoteUpdatedAt)) {
        continue;
      }
      stockPayload.add({
        'product_id': stock.productId,
        'location_id': stock.locationId,
        'location_type': stock.locationType,
        'quantity_on_hand': stock.quantityOnHand,
        'quantity_reserved': stock.quantityReserved,
        'updated_at': localUpdatedAt.toUtc().toIso8601String(),
      });
    }
    if (stockPayload.isNotEmpty) {
      try {
        await remote.upsertInventoryStocks(stockPayload);
      } catch (error) {
        print(error);
      }
    }

    // Sales
    final unsyncedSales = await _localDataSource.fetchUnsyncedSalesForSync();
    for (final sale in unsyncedSales) {
      try {
        await remote.saveSale(sale);
        await _localDataSource.markSaleSynced(sale.id, DateTime.now().toUtc());
      } catch (_) {}
    }

    // Transfers
    final unsyncedTransfers = await _localDataSource.fetchUnsyncedTransfersForSync();
    for (final transfer in unsyncedTransfers) {
      try {
        await remote.saveTransfer(transfer);
        await _localDataSource.markTransferSynced(transfer.id, DateTime.now().toUtc());
      } catch (_) {}
    }
  }

  Future<Map<String, DateTime?>> _pullRemoteUpdates({
    required InventoryRemoteDataSource remote,
    required Set<String> pendingLocationIds,
    required Set<String> pendingEmployeeIds,
  }) async {
    DateTime? parseDate(dynamic value) {
      if (value is DateTime) {
        return value.toUtc();
      }
      if (value is String && value.isNotEmpty) {
        return DateTime.tryParse(value)?.toUtc();
      }
      return null;
    }

    final stockTimestamps = <String, DateTime?>{};

    final lastLocationSync = await _localDataSource
        .fetchLastLocationsSyncedAt();
    final remoteLocations = await remote.fetchLocations(
      updatedAfter: lastLocationSync,
    );
    if (remoteLocations.isNotEmpty) {
      await _localDataSource.cacheRemoteLocations(
        remoteLocations,
        skipIds: pendingLocationIds,
      );
    }

    final lastEmployeeSync = await _localDataSource
        .fetchLastEmployeesSyncedAt();
    final remoteEmployees = await remote.fetchEmployees(
      updatedAfter: lastEmployeeSync,
    );
    if (remoteEmployees.isNotEmpty) {
      await _localDataSource.cacheRemoteEmployees(
        remoteEmployees,
        skipIds: pendingEmployeeIds,
      );
    }

    final locationIds = await _localDataSource.fetchAllLocationIds();
    if (locationIds.isNotEmpty) {
      final remoteStocks = await remote.fetchInventoryStocks(
        locationIds: locationIds.toSet(),
      );
      if (remoteStocks.isNotEmpty) {
        await _localDataSource.cacheRemoteStocks(remoteStocks);
        for (final entry in remoteStocks) {
          final productId = entry['product_id'] as String?;
          final locationId = entry['location_id'] as String?;
          if (productId == null || locationId == null) {
            continue;
          }
          stockTimestamps['$productId|$locationId'] =
              parseDate(entry['updated_at']);
        }
      }
    }

    return stockTimestamps;
  }

  Future<void> _pushStockSnapshots(Set<_StockKey> keys) async {
    final remote = _remoteDataSource;
    if (remote == null || keys.isEmpty) {
      return;
    }
    final payload = <Map<String, dynamic>>[];
    for (final key in keys) {
      final entry = await _localDataSource.fetchStockForSync(
        productId: key.productId,
        locationId: key.locationId,
      );
      if (entry == null) {
        continue;
      }
      payload.add({
        'product_id': entry.productId,
        'location_id': entry.locationId,
        'location_type': entry.locationType,
        'quantity_on_hand': entry.quantityOnHand,
        'quantity_reserved': entry.quantityReserved,
        'updated_at': entry.updatedAt.toUtc().toIso8601String(),
      });
    }
    if (payload.isEmpty) {
      return;
    }
    try {
      await remote.upsertInventoryStocks(payload);
    } catch (error) {
      print(error);
    }
  }
}

class _StockKey {
  const _StockKey({required this.productId, required this.locationId});

  final String productId;
  final String locationId;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is _StockKey &&
        other.productId == productId &&
        other.locationId == locationId;
  }

  @override
  int get hashCode => Object.hash(productId, locationId);
}
