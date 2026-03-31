import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../../../core/database/app_database.dart';
import '../../../domain/entities/inventory_location.dart';
import '../../../domain/entities/inventory_transaction.dart';
import '../../models/employee_model.dart';
import '../../models/inventory_location_model.dart';
import '../../models/inventory_report_model.dart';
import '../../models/inventory_stock_model.dart';
import '../../models/inventory_transaction_model.dart';

class InventoryStockSyncEntry {
  const InventoryStockSyncEntry({
    required this.productId,
    required this.locationId,
    required this.locationType,
    required this.quantityOnHand,
    required this.quantityReserved,
    required this.updatedAt,
  });

  final String productId;
  final String locationId;
  final String locationType;
  final double quantityOnHand;
  final double quantityReserved;
  final DateTime updatedAt;
}

class InventoryLocalDataSource {
  InventoryLocalDataSource(this._database);

  final AppDatabase _database;
  final Uuid _uuid = const Uuid();

  Stream<List<InventoryLocationModel>> watchLocations(String type) {
    return _database
        .watchLocations(type: type)
        .map((rows) => rows.map(InventoryLocationModel.fromTable).toList());
  }

  Future<void> upsertLocation(InventoryLocationModel location) {
    final timestamp = location.updatedAt ?? DateTime.now().toUtc();
    final model = location.copyWith(
      updatedAt: timestamp,
      createdAt: location.createdAt ?? timestamp,
    );
    return _database.upsertLocation(model.toCompanion());
  }

  Future<int> deleteLocation(String id) {
    return _database.deleteLocation(id);
  }

  Stream<List<EmployeeModel>> watchEmployees({String? locationId}) {
    return _database
        .watchEmployees(locationId: locationId)
        .map((rows) => rows.map(EmployeeModel.fromTable).toList());
  }

  Future<void> upsertEmployee(EmployeeModel employee) {
    final timestamp = employee.updatedAt ?? DateTime.now().toUtc();
    final model = employee.copyWith(
      updatedAt: timestamp,
      createdAt: employee.createdAt ?? timestamp,
    );
    return _database.upsertEmployee(model.toCompanion());
  }

  Future<int> deleteEmployee(String id) {
    return _database.deleteEmployee(id);
  }

  Stream<List<InventoryStockModel>> watchInventory({
    String? locationId,
    String? locationType,
  }) {
    final stock = _database.select(_database.inventoryStocksTable);
    if (locationId != null) {
      stock.where((tbl) => tbl.locationId.equals(locationId));
    }
    if (locationType != null) {
      stock.where((tbl) => tbl.locationType.equals(locationType));
    }
    final joinQuery = stock.join([
      innerJoin(
        _database.productsTable,
        _database.productsTable.id.equalsExp(
          _database.inventoryStocksTable.productId,
        ),
      ),
      leftOuterJoin(
        _database.inventoryLocationsTable,
        _database.inventoryLocationsTable.id.equalsExp(
          _database.inventoryStocksTable.locationId,
        ),
      ),
    ]);

    return joinQuery.watch().map((rows) {
      return rows.map((row) {
        final stockRow = row.readTable(_database.inventoryStocksTable);
        final productRow = row.readTable(_database.productsTable);
        final locationRow = row.readTableOrNull(
          _database.inventoryLocationsTable,
        );
        return InventoryStockModel.fromData(
          productId: stockRow.productId,
          productName: productRow.name,
          unit: productRow.unit,
          locationId: stockRow.locationId,
          locationType: stockRow.locationType,
          locationName: locationRow?.name,
          quantityOnHand: stockRow.quantityOnHand,
          quantityReserved: stockRow.quantityReserved,
          updatedAt: stockRow.updatedAt,
        );
      }).toList();
    });
  }

  Future<List<InventoryStockModel>> fetchGlobalInventory() async {
    final result = await _database
        .customSelect(
          '''
SELECT s.product_id AS product_id,
       p.name AS product_name,
       p.unit AS unit,
       SUM(s.quantity_on_hand) AS total_on_hand,
       SUM(s.quantity_reserved) AS total_reserved,
       MAX(s.updated_at) AS last_update
  FROM inventory_stocks_table s
  INNER JOIN products_table p ON p.id = s.product_id
 GROUP BY s.product_id, p.name, p.unit
 ORDER BY p.name ASC
''',
          readsFrom: {_database.inventoryStocksTable, _database.productsTable},
        )
        .get();

    return result
        .map(
          (row) => InventoryStockModel.fromData(
            productId: row.read<String>('product_id'),
            productName: row.read<String>('product_name'),
            unit: row.readNullable<String>('unit'),
            locationId: 'global',
            locationType: InventoryLocationType.store.label,
            locationName: 'Global',
            quantityOnHand: row.read<double>('total_on_hand'),
            quantityReserved: row.read<double>('total_reserved'),
            updatedAt: row.readNullable<DateTime>('last_update'),
          ),
        )
        .toList();
  }

  Future<InventoryStockModel?> getStock({
    required String productId,
    required String locationId,
  }) async {
    final stockRow = await _database.fetchInventoryStock(productId, locationId);
    if (stockRow == null) {
      return null;
    }
    final productRow = await _database.fetchProductById(productId);
    final locationRow = await (_database.select(
      _database.inventoryLocationsTable,
    )..where((tbl) => tbl.id.equals(locationId))).getSingleOrNull();

    return InventoryStockModel.fromData(
      productId: stockRow.productId,
      productName: productRow?.name ?? 'Producto',
      unit: productRow?.unit,
      locationId: stockRow.locationId,
      locationType: stockRow.locationType,
      locationName: locationRow?.name,
      quantityOnHand: stockRow.quantityOnHand,
      quantityReserved: stockRow.quantityReserved,
      updatedAt: stockRow.updatedAt,
    );
  }

  Future<void> recordPurchase(PurchaseModel purchase) async {
    if (purchase.lines.isEmpty) {
      return;
    }

    final timestamp = DateTime.now().toUtc();
    final header = purchase.toHeaderCompanion(timestamp: timestamp);
    final items = purchase.toItemsCompanions();

    await _database.transaction(() async {
      await _database
          .into(_database.purchaseHeadersTable)
          .insertOnConflictUpdate(header);
      await (_database.delete(
        _database.purchaseItemsTable,
      )..where((tbl) => tbl.purchaseId.equals(purchase.id))).go();
      await _database.batch((batch) {
        batch.insertAllOnConflictUpdate(_database.purchaseItemsTable, items);
      });

      for (final line in purchase.lines) {
        await _applyStockDelta(
          productId: line.productId,
          locationId: purchase.locationId,
          locationType: purchase.locationType,
          delta: line.quantity,
        );
        await _insertMovement(
          productId: line.productId,
          locationId: purchase.locationId,
          locationType: purchase.locationType,
          quantity: line.quantity,
          movementType: InventoryMovementType.purchaseIn,
          referenceType: 'purchase',
          referenceId: purchase.id,
          createdBy: purchase.createdByEmployeeId,
          occurredAt: timestamp,
          notes: purchase.notes,
        );
      }
    });
  }

  Future<void> recordSale(SaleModel sale) async {
    if (sale.lines.isEmpty) {
      return;
    }

    final timestamp = DateTime.now().toUtc();
    final header = sale.toHeaderCompanion(timestamp: timestamp);
    final items = sale.toItemsCompanions();

    await _database.transaction(() async {
      await _database
          .into(_database.salesHeadersTable)
          .insertOnConflictUpdate(header);
      await (_database.delete(
        _database.salesItemsTable,
      )..where((tbl) => tbl.saleId.equals(sale.id))).go();
      await _database.batch((batch) {
        batch.insertAllOnConflictUpdate(_database.salesItemsTable, items);
      });

      for (final line in sale.lines) {
        await _applyStockDelta(
          productId: line.productId,
          locationId: sale.storeId,
          locationType: InventoryLocationType.store.label,
          delta: -line.quantity,
        );
        await _insertMovement(
          productId: line.productId,
          locationId: sale.storeId,
          locationType: InventoryLocationType.store.label,
          quantity: -line.quantity,
          movementType: InventoryMovementType.saleOut,
          referenceType: 'sale',
          referenceId: sale.id,
          createdBy: sale.createdByEmployeeId,
          occurredAt: timestamp,
          notes: sale.notes,
        );
      }
    });
  }

  Future<void> recordTransfer(TransferModel transfer) async {
    if (transfer.lines.isEmpty) {
      return;
    }

    final timestamp = DateTime.now().toUtc();
    final header = transfer.toHeaderCompanion(timestamp: timestamp);
    final items = transfer.toItemsCompanions();

    await _database.transaction(() async {
      await _database
          .into(_database.transferHeadersTable)
          .insertOnConflictUpdate(header);
      await (_database.delete(
        _database.transferItemsTable,
      )..where((tbl) => tbl.transferId.equals(transfer.id))).go();
      await _database.batch((batch) {
        batch.insertAllOnConflictUpdate(_database.transferItemsTable, items);
      });

      for (final line in transfer.lines) {
        await _applyStockDelta(
          productId: line.productId,
          locationId: transfer.originLocationId,
          locationType: transfer.originLocationType,
          delta: -line.quantity,
        );
        await _insertMovement(
          productId: line.productId,
          locationId: transfer.originLocationId,
          locationType: transfer.originLocationType,
          quantity: -line.quantity,
          movementType: InventoryMovementType.transferOut,
          referenceType: 'transfer',
          referenceId: transfer.id,
          createdBy: transfer.requestedByEmployeeId,
          occurredAt: timestamp,
          notes: transfer.notes,
        );
        await _applyStockDelta(
          productId: line.productId,
          locationId: transfer.destinationLocationId,
          locationType: transfer.destinationLocationType,
          delta: line.quantity,
        );
        await _insertMovement(
          productId: line.productId,
          locationId: transfer.destinationLocationId,
          locationType: transfer.destinationLocationType,
          quantity: line.quantity,
          movementType: InventoryMovementType.transferIn,
          referenceType: 'transfer',
          referenceId: transfer.id,
          createdBy: transfer.requestedByEmployeeId,
          occurredAt: timestamp,
          notes: transfer.notes,
        );
      }
    });
  }

  Stream<List<SalesReportRow>> watchSalesReport({
    String? storeId,
    DateTime? start,
    DateTime? end,
  }) {
    final conditions = <String>[];
    final variables = <Variable<Object>>[];

    if (storeId != null) {
      conditions.add('sh.store_id = ?');
      variables.add(Variable<String>(storeId));
    }
    if (start != null) {
      conditions.add('sh.sale_date >= ?');
      variables.add(Variable<DateTime>(start));
    }
    if (end != null) {
      conditions.add('sh.sale_date <= ?');
      variables.add(Variable<DateTime>(end));
    }

    final whereClause = conditions.isEmpty
        ? ''
        : 'WHERE ${conditions.join(' AND ')}';

    final query = _database.customSelect(
      '''
SELECT sh.id AS sale_id,
       sh.store_id AS store_id,
       COALESCE(loc.name, 'Tienda') AS store_name,
       sh.sale_date AS sale_date,
       sh.total_amount AS total_amount
  FROM sales_headers_table sh
  LEFT JOIN inventory_locations_table loc ON loc.id = sh.store_id
 $whereClause
 ORDER BY sh.sale_date DESC
''',
      variables: variables,
      readsFrom: {
        _database.salesHeadersTable,
        _database.inventoryLocationsTable,
      },
    );

    return query.watch().map((rows) {
      return rows
          .map(
            (row) => SalesReportRow(
              saleId: row.read<String>('sale_id'),
              storeId: row.read<String>('store_id'),
              storeName: row.read<String>('store_name'),
              saleDate: row.read<DateTime>('sale_date'),
              totalAmount: row.read<double>('total_amount'),
            ),
          )
          .toList();
    });
  }

  Stream<List<PurchaseReportRow>> watchPurchaseReport({
    String? locationId,
    DateTime? start,
    DateTime? end,
  }) {
    final conditions = <String>[];
    final variables = <Variable<Object>>[];

    if (locationId != null) {
      conditions.add('ph.location_id = ?');
      variables.add(Variable<String>(locationId));
    }
    if (start != null) {
      conditions.add('ph.purchase_date >= ?');
      variables.add(Variable<DateTime>(start));
    }
    if (end != null) {
      conditions.add('ph.purchase_date <= ?');
      variables.add(Variable<DateTime>(end));
    }

    final whereClause = conditions.isEmpty
        ? ''
        : 'WHERE ${conditions.join(' AND ')}';

    final query = _database.customSelect(
      '''
SELECT ph.id AS purchase_id,
       ph.location_id AS location_id,
       COALESCE(loc.name, 'Ubicacion') AS location_name,
       ph.purchase_date AS purchase_date,
       ph.total_cost AS total_cost
  FROM purchase_headers_table ph
  LEFT JOIN inventory_locations_table loc ON loc.id = ph.location_id
 $whereClause
 ORDER BY ph.purchase_date DESC
''',
      variables: variables,
      readsFrom: {
        _database.purchaseHeadersTable,
        _database.inventoryLocationsTable,
      },
    );

    return query.watch().map((rows) {
      return rows
          .map(
            (row) => PurchaseReportRow(
              purchaseId: row.read<String>('purchase_id'),
              locationId: row.read<String>('location_id'),
              locationName: row.read<String>('location_name'),
              purchaseDate: row.read<DateTime>('purchase_date'),
              totalCost: row.read<double>('total_cost'),
            ),
          )
          .toList();
    });
  }

  Stream<List<TransferReportRow>> watchTransferReport({
    String? originId,
    String? destinationId,
    DateTime? start,
    DateTime? end,
  }) {
    final conditions = <String>[];
    final variables = <Variable<Object>>[];

    if (originId != null) {
      conditions.add('th.origin_location_id = ?');
      variables.add(Variable<String>(originId));
    }
    if (destinationId != null) {
      conditions.add('th.destination_location_id = ?');
      variables.add(Variable<String>(destinationId));
    }
    if (start != null) {
      conditions.add('th.transfer_date >= ?');
      variables.add(Variable<DateTime>(start));
    }
    if (end != null) {
      conditions.add('th.transfer_date <= ?');
      variables.add(Variable<DateTime>(end));
    }

    final whereClause = conditions.isEmpty
        ? ''
        : 'WHERE ${conditions.join(' AND ')}';

    final query = _database.customSelect(
      '''
SELECT th.id AS transfer_id,
       COALESCE(origin.name, 'Origen') AS origin_name,
       COALESCE(dest.name, 'Destino') AS destination_name,
       th.transfer_date AS transfer_date,
       (SELECT COUNT(*) FROM transfer_items_table ti WHERE ti.transfer_id = th.id) AS product_count
  FROM transfer_headers_table th
  LEFT JOIN inventory_locations_table origin ON origin.id = th.origin_location_id
  LEFT JOIN inventory_locations_table dest ON dest.id = th.destination_location_id
 $whereClause
 ORDER BY th.transfer_date DESC
''',
      variables: variables,
      readsFrom: {
        _database.transferHeadersTable,
        _database.transferItemsTable,
        _database.inventoryLocationsTable,
      },
    );

    return query.watch().map((rows) {
      return rows
          .map(
            (row) => TransferReportRow(
              transferId: row.read<String>('transfer_id'),
              originName: row.read<String>('origin_name'),
              destinationName: row.read<String>('destination_name'),
              transferDate: row.read<DateTime>('transfer_date'),
              productCount: row.read<int>('product_count'),
            ),
          )
          .toList();
    });
  }

  Stream<DailySalesSummaryModel> watchDailySalesSummary(DateTime date) {
    final dayStart = DateTime(date.year, date.month, date.day);
    final dayEnd = dayStart
        .add(const Duration(days: 1))
        .subtract(const Duration(milliseconds: 1));

    final query = _database.customSelect(
      '''
SELECT COALESCE(SUM(total_amount), 0) AS total_amount
  FROM sales_headers_table
 WHERE sale_date >= ? AND sale_date <= ?
''',
      variables: [Variable<DateTime>(dayStart), Variable<DateTime>(dayEnd)],
      readsFrom: {_database.salesHeadersTable},
    );

    return query.watchSingle().map(
      (row) => DailySalesSummaryModel(
        date: dayStart,
        totalAmount: row.read<double>('total_amount'),
      ),
    );
  }

  Future<double> fetchTodayGlobalSalesTotal() async {
    final now = DateTime.now();
    final summary = await watchDailySalesSummary(now).first;
    return summary.totalAmount;
  }

  Stream<List<InventoryMovementModel>> watchMovements({
    String? productId,
    String? locationId,
  }) {
    return _database
        .watchInventoryMovements(productId: productId, locationId: locationId)
        .map((rows) => rows.map(InventoryMovementModel.fromTable).toList());
  }

  Future<void> _applyStockDelta({
    required String productId,
    required String locationId,
    required String locationType,
    required double delta,
  }) async {
    await _database.transaction(() async {
      final existing =
          await (_database.select(_database.inventoryStocksTable)..where(
                (tbl) =>
                    tbl.productId.equals(productId) &
                    tbl.locationId.equals(locationId),
              ))
              .getSingleOrNull();

      final currentQuantity = existing?.quantityOnHand ?? 0;
      final newQuantity = currentQuantity + delta;
      if (newQuantity < -0.0001) {
        throw StateError(
          'Stock insuficiente para el producto $productId en $locationId',
        );
      }

      await _database
          .into(_database.inventoryStocksTable)
          .insertOnConflictUpdate(
            InventoryStocksTableCompanion(
              productId: Value(productId),
              locationId: Value(locationId),
              locationType: Value(locationType),
              quantityOnHand: Value(newQuantity),
              quantityReserved: Value(existing?.quantityReserved ?? 0),
              updatedAt: Value(DateTime.now().toUtc()),
            ),
          );
    });
  }

  Future<void> _insertMovement({
    required String productId,
    required String? locationId,
    required String? locationType,
    required double quantity,
    required InventoryMovementType movementType,
    String? referenceType,
    String? referenceId,
    String? createdBy,
    DateTime? occurredAt,
    String? notes,
  }) {
    final movement = InventoryMovementModel(
      id: _uuid.v4(),
      productId: productId,
      locationId: locationId,
      locationType: locationType,
      quantity: quantity,
      movementType: movementType.label,
      referenceType: referenceType,
      referenceId: referenceId,
      createdBy: createdBy,
      occurredAt: occurredAt ?? DateTime.now().toUtc(),
      notes: notes,
      syncedAt: null,
    );
    return _database
        .into(_database.inventoryMovementsTable)
        .insert(movement.toCompanion());
  }

  // --- Sync bridging methods (local <-> remote) ---
  Future<void> cacheRemoteLocations(
    List<InventoryLocationModel> locations, {
    Set<String> skipIds = const <String>{},
  }) async {
    if (locations.isEmpty) {
      return;
    }

    final now = DateTime.now().toUtc();
    await _database.transaction(() async {
      for (final location in locations) {
        if (skipIds.contains(location.id)) {
          continue;
        }
        final syncedAt = location.syncedAt ?? location.updatedAt ?? now;
        final createdAt = location.createdAt ?? syncedAt;
        final updatedAt = location.updatedAt ?? syncedAt;
        final model = location.copyWith(
          createdAt: createdAt,
          updatedAt: updatedAt,
          syncedAt: syncedAt,
        );
        await _database.upsertLocation(model.toCompanion());
      }
    });
  }

  Future<void> cacheRemoteEmployees(
    List<EmployeeModel> employees, {
    Set<String> skipIds = const <String>{},
  }) async {
    if (employees.isEmpty) {
      return;
    }

    final now = DateTime.now().toUtc();
    await _database.transaction(() async {
      for (final employee in employees) {
        if (skipIds.contains(employee.id)) {
          continue;
        }
        final syncedAt = employee.syncedAt ?? employee.updatedAt ?? now;
        final createdAt = employee.createdAt ?? syncedAt;
        final updatedAt = employee.updatedAt ?? syncedAt;
        final model = employee.copyWith(
          createdAt: createdAt,
          updatedAt: updatedAt,
          syncedAt: syncedAt,
        );
        await _database.upsertEmployee(model.toCompanion());
      }
    });
  }

  Future<void> cacheRemoteStocks(List<Map<String, dynamic>> stocks) async {
    if (stocks.isEmpty) {
      return;
    }

    final existing = await _database
        .select(_database.inventoryStocksTable)
        .get();
    final existingMap = <String, InventoryStocksTableData>{
      for (final row in existing) '${row.productId}|${row.locationId}': row,
    };

    await _database.transaction(() async {
      for (final entry in stocks) {
        final productId = entry['product_id'] as String?;
        final locationId = entry['location_id'] as String?;
        if (productId == null || locationId == null) {
          continue;
        }
        final locationType = (entry['location_type'] as String?) ?? 'store';
        final quantityOnHand = _coerceDouble(entry['quantity_on_hand']);
        final quantityReserved = _coerceDouble(entry['quantity_reserved']);
        final remoteUpdatedAt =
            _coerceDate(entry['updated_at']) ?? DateTime.now().toUtc();

        final key = '$productId|$locationId';
        final current = existingMap[key]?.updatedAt;
        if (current != null && remoteUpdatedAt.isBefore(current)) {
          continue;
        }

        await _database
            .into(_database.inventoryStocksTable)
            .insertOnConflictUpdate(
              InventoryStocksTableCompanion(
                productId: Value(productId),
                locationId: Value(locationId),
                locationType: Value(locationType),
                quantityOnHand: Value(quantityOnHand),
                quantityReserved: Value(quantityReserved),
                updatedAt: Value(remoteUpdatedAt),
              ),
            );

        existingMap[key] = InventoryStocksTableData(
          productId: productId,
          locationId: locationId,
          locationType: locationType,
          quantityOnHand: quantityOnHand,
          quantityReserved: quantityReserved,
          updatedAt: remoteUpdatedAt,
        );
      }
    });
  }

  Future<List<String>> fetchAllLocationIds() async {
    final rows = await _database
        .select(_database.inventoryLocationsTable)
        .get();
    return rows.map((row) => row.id).toList();
  }

  Future<DateTime?> fetchLastLocationsSyncedAt() {
    return _database.fetchMaxLocationsSyncedAt();
  }

  Future<DateTime?> fetchLastEmployeesSyncedAt() {
    return _database.fetchMaxEmployeesSyncedAt();
  }

  Future<List<InventoryLocationModel>> fetchUnsyncedLocationsForSync() async {
    final rows = await _database.fetchUnsyncedLocations();
    return rows.map(InventoryLocationModel.fromTable).toList();
  }

  Future<void> markLocationSynced(String id, DateTime ts) {
    return _database.markLocationSynced(id, ts);
  }

  Future<List<EmployeeModel>> fetchUnsyncedEmployeesForSync() async {
    final rows = await _database.fetchUnsyncedEmployees();
    return rows.map(EmployeeModel.fromTable).toList();
  }

  Future<void> markEmployeeSynced(String id, DateTime ts) {
    return _database.markEmployeeSynced(id, ts);
  }

  Future<List<InventoryMovementModel>> fetchUnsyncedMovementsForSync() async {
    final rows = await _database.fetchUnsyncedMovements();
    return rows.map(InventoryMovementModel.fromTable).toList();
  }

  Future<void> markMovementSynced(String id, DateTime ts) {
    return _database.markMovementSynced(id, ts);
  }

  Future<List<InventoryStockSyncEntry>> fetchStocksForSync() async {
    final rows = await _database
        .select(_database.inventoryStocksTable)
        .get();
    return rows
        .map(
          (row) => InventoryStockSyncEntry(
            productId: row.productId,
            locationId: row.locationId,
            locationType: row.locationType,
            quantityOnHand: row.quantityOnHand,
            quantityReserved: row.quantityReserved,
            updatedAt: (row.updatedAt ??
                    DateTime.fromMillisecondsSinceEpoch(0, isUtc: true))
                .toUtc(),
          ),
        )
        .toList();
  }

  Future<InventoryStockSyncEntry?> fetchStockForSync({
    required String productId,
    required String locationId,
  }) async {
    final row = await _database.fetchInventoryStock(productId, locationId);
    if (row == null) {
      return null;
    }
    return InventoryStockSyncEntry(
      productId: row.productId,
      locationId: row.locationId,
      locationType: row.locationType,
      quantityOnHand: row.quantityOnHand,
      quantityReserved: row.quantityReserved,
      updatedAt: (row.updatedAt ??
              DateTime.fromMillisecondsSinceEpoch(0, isUtc: true))
          .toUtc(),
    );
  }

  Future<List<PurchaseModel>> fetchUnsyncedPurchasesForSync() async {
    final headers = await _database.fetchUnsyncedPurchases();
    final result = <PurchaseModel>[];
    for (final h in headers) {
      final items = await _database.fetchPurchaseItems(h.id);
      final lines = items
          .map(
            (i) => PurchaseLineModel(
              productId: i.productId,
              quantity: i.quantity,
              unitCost: i.unitCost,
              lineTotal: i.totalCost,
            ),
          )
          .toList();
      result.add(
        PurchaseModel(
          id: h.id,
          locationId: h.locationId,
          locationType: h.locationType,
          date: h.purchaseDate,
          referenceCode: h.referenceCode,
          supplierName: h.supplierName,
          createdByEmployeeId: h.createdByEmployeeId,
          notes: h.notes,
          lines: lines,
        ),
      );
    }
    return result;
  }

  Future<void> markPurchaseSynced(String id, DateTime ts) {
    return _database.markPurchaseSynced(id, ts);
  }

  Future<List<SaleModel>> fetchUnsyncedSalesForSync() async {
    final headers = await _database.fetchUnsyncedSales();
    final result = <SaleModel>[];
    for (final h in headers) {
      final items = await _database.fetchSaleItems(h.id);
      final lines = items
          .map(
            (i) => SaleLineModel(
              productId: i.productId,
              quantity: i.quantity,
              unitPrice: i.unitPrice,
              lineTotal: i.totalPrice,
            ),
          )
          .toList();
      result.add(
        SaleModel(
          id: h.id,
          storeId: h.storeId,
          date: h.saleDate,
          referenceCode: h.referenceCode,
          customerName: h.customerName,
          createdByEmployeeId: h.createdByEmployeeId,
          notes: h.notes,
          lines: lines,
        ),
      );
    }
    return result;
  }

  Future<void> markSaleSynced(String id, DateTime ts) {
    return _database.markSaleSynced(id, ts);
  }

  Future<List<TransferModel>> fetchUnsyncedTransfersForSync() async {
    final headers = await _database.fetchUnsyncedTransfers();
    final result = <TransferModel>[];
    for (final h in headers) {
      final items = await _database.fetchTransferItems(h.id);
      final lines = items
          .map(
            (i) =>
                TransferLineModel(productId: i.productId, quantity: i.quantity),
          )
          .toList();
      result.add(
        TransferModel(
          id: h.id,
          originLocationId: h.originLocationId,
          originLocationType: h.originLocationType,
          destinationLocationId: h.destinationLocationId,
          destinationLocationType: h.destinationLocationType,
          date: h.transferDate,
          requestedByEmployeeId: h.requestedByEmployeeId,
          status: h.status,
          notes: h.notes,
          lines: lines,
        ),
      );
    }
    return result;
  }

  Future<void> markTransferSynced(String id, DateTime ts) {
    return _database.markTransferSynced(id, ts);
  }

  double _coerceDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }
    if (value is String) {
      final parsed = double.tryParse(value);
      if (parsed != null) {
        return parsed;
      }
    }
    return 0;
  }

  DateTime? _coerceDate(dynamic value) {
    if (value is DateTime) {
      return value.toUtc();
    }
    if (value is String && value.isNotEmpty) {
      return DateTime.tryParse(value)?.toUtc();
    }
    return null;
  }
}
