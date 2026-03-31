import 'dart:io';

import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

class AuthCredentialsTable extends Table {
  TextColumn get userId => text()();
  TextColumn get email => text()();
  TextColumn get displayName => text().nullable()();
  TextColumn get hashedPassword => text()();
  TextColumn get passwordSalt => text()();
  TextColumn get encryptedAccessToken => text()();
  TextColumn get encryptedRefreshToken => text().nullable()();
  IntColumn get expiresAt => integer().nullable()();
  TextColumn get jsonUserMetadata => text().nullable()();
  TextColumn get role => text().withDefault(const Constant('customer'))();
  TextColumn get sellerId => text().nullable()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {userId};
}

class SellersTable extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get storeName => text()();
  TextColumn get storeSlug => text().nullable()();
  TextColumn get description => text().nullable()();
  TextColumn get logoUrl => text().nullable()();
  TextColumn get bannerUrl => text().nullable()();
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  DateTimeColumn get syncedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class ProductsTable extends Table {
  TextColumn get id => text()();
  TextColumn get sellerId => text()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  TextColumn get category => text().nullable()();
  TextColumn get unit => text().nullable()();
  RealColumn get price => real().withDefault(const Constant(0.0))();
  IntColumn get quantity => integer().nullable()();
  BoolColumn get isTrending => boolean().withDefault(const Constant(false))();
  BoolColumn get inStock => boolean().withDefault(const Constant(true))();
  RealColumn get rating => real().nullable()();
  BoolColumn get isDirty => boolean().withDefault(const Constant(false))();
  TextColumn get pendingOperation => text().nullable()();
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  DateTimeColumn get syncedAt => dateTime().nullable()();
  TextColumn get metadataJson => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class InventoryLocationsTable extends Table {
  TextColumn get id => text()();
  TextColumn get type => text()();
  TextColumn get code => text().nullable()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  TextColumn get address => text().nullable()();
  TextColumn get phone => text().nullable()();
  TextColumn get managerId => text().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  DateTimeColumn get syncedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class EmployeesTable extends Table {
  TextColumn get id => text()();
  TextColumn get firstName => text()();
  TextColumn get lastName => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get phone => text().nullable()();
  TextColumn get authUserId => text().nullable()();
  TextColumn get role => text()();
  TextColumn get locationId =>
      text().nullable().references(InventoryLocationsTable, #id)();
  TextColumn get locationType => text().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get hiredAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  DateTimeColumn get syncedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class InventoryStocksTable extends Table {
  TextColumn get productId => text()();
  TextColumn get locationId => text()();
  TextColumn get locationType => text().withDefault(const Constant('store'))();
  RealColumn get quantityOnHand => real().withDefault(const Constant(0.0))();
  RealColumn get quantityReserved => real().withDefault(const Constant(0.0))();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {productId, locationId};
}

class InventoryMovementsTable extends Table {
  TextColumn get id => text()();
  TextColumn get productId => text()();
  TextColumn get locationId => text().nullable()();
  TextColumn get locationType => text().nullable()();
  RealColumn get quantity => real()();
  TextColumn get movementType => text()();
  TextColumn get referenceType => text().nullable()();
  TextColumn get referenceId => text().nullable()();
  TextColumn get createdBy => text().nullable()();
  DateTimeColumn get occurredAt => dateTime()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get syncedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class PurchaseHeadersTable extends Table {
  TextColumn get id => text()();
  TextColumn get locationId => text()();
  TextColumn get locationType => text()();
  TextColumn get supplierName => text().nullable()();
  TextColumn get referenceCode => text().nullable()();
  TextColumn get createdByEmployeeId => text().nullable()();
  DateTimeColumn get purchaseDate => dateTime()();
  RealColumn get totalCost => real().withDefault(const Constant(0.0))();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  DateTimeColumn get syncedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class PurchaseItemsTable extends Table {
  TextColumn get id => text()();
  TextColumn get purchaseId => text()();
  TextColumn get productId => text()();
  RealColumn get quantity => real()();
  RealColumn get unitCost => real().withDefault(const Constant(0.0))();
  RealColumn get totalCost => real().withDefault(const Constant(0.0))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class SalesHeadersTable extends Table {
  TextColumn get id => text()();
  TextColumn get storeId => text()();
  TextColumn get referenceCode => text().nullable()();
  TextColumn get customerName => text().nullable()();
  TextColumn get createdByEmployeeId => text().nullable()();
  DateTimeColumn get saleDate => dateTime()();
  RealColumn get totalAmount => real().withDefault(const Constant(0.0))();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  DateTimeColumn get syncedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class SalesItemsTable extends Table {
  TextColumn get id => text()();
  TextColumn get saleId => text()();
  TextColumn get productId => text()();
  RealColumn get quantity => real()();
  RealColumn get unitPrice => real().withDefault(const Constant(0.0))();
  RealColumn get totalPrice => real().withDefault(const Constant(0.0))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class TransferHeadersTable extends Table {
  TextColumn get id => text()();
  TextColumn get originLocationId => text()();
  TextColumn get originLocationType => text()();
  TextColumn get destinationLocationId => text()();
  TextColumn get destinationLocationType => text()();
  TextColumn get requestedByEmployeeId => text().nullable()();
  DateTimeColumn get transferDate => dateTime()();
  TextColumn get status => text().withDefault(const Constant('completed'))();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  DateTimeColumn get syncedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class TransferItemsTable extends Table {
  TextColumn get id => text()();
  TextColumn get transferId => text()();
  TextColumn get productId => text()();
  RealColumn get quantity => real()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DriftDatabase(
  tables: [
    AuthCredentialsTable,
    SellersTable,
    ProductsTable,
    InventoryLocationsTable,
    EmployeesTable,
    InventoryStocksTable,
    InventoryMovementsTable,
    PurchaseHeadersTable,
    PurchaseItemsTable,
    SalesHeadersTable,
    SalesItemsTable,
    TransferHeadersTable,
    TransferItemsTable,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 9;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (Migrator m, int from, int to) async {
      if (from < 2) {
        await m.addColumn(authCredentialsTable, authCredentialsTable.role);
        await m.addColumn(authCredentialsTable, authCredentialsTable.sellerId);
      }
      if (from < 3) {
        await m.createTable(sellersTable);
        await m.createTable(productsTable);
      }
      if (from < 4) {
        await m.createTable(inventoryLocationsTable);
        await m.createTable(employeesTable);
      }
      if (from < 5) {
        await m.createTable(inventoryStocksTable);
        await m.createTable(inventoryMovementsTable);
      }
      if (from < 6) {
        await m.createTable(purchaseHeadersTable);
        await m.createTable(purchaseItemsTable);
        await m.createTable(salesHeadersTable);
        await m.createTable(salesItemsTable);
        await m.createTable(transferHeadersTable);
        await m.createTable(transferItemsTable);
      }
      if (from < 7) {
        // Use raw SQL to add synced_at columns to header tables to avoid generator type issues during migration.
        await this.customStatement(
          'ALTER TABLE purchase_headers_table ADD COLUMN synced_at TIMESTAMP NULL',
        );
        await this.customStatement(
          'ALTER TABLE sales_headers_table ADD COLUMN synced_at TIMESTAMP NULL',
        );
        await this.customStatement(
          'ALTER TABLE transfer_headers_table ADD COLUMN synced_at TIMESTAMP NULL',
        );
      }
      if (from < 8) {
        await m.addColumn(employeesTable, employeesTable.authUserId);
      }
      if (from < 9) {
        await m.addColumn(
          inventoryMovementsTable,
          inventoryMovementsTable.syncedAt,
        );
      }
    },
  );

  Future<AuthCredentialsTableData?> fetchCachedCredentials() {
    return select(authCredentialsTable).getSingleOrNull();
  }

  Future<AuthCredentialsTableData?> fetchCredentialsByEmail(String email) {
    return (select(
      authCredentialsTable,
    )..where((tbl) => tbl.email.equals(email))).getSingleOrNull();
  }

  Future<void> saveCredentials(AuthCredentialsTableCompanion entry) {
    return into(authCredentialsTable).insertOnConflictUpdate(entry);
  }

  Future<void> clearCredentials() {
    return delete(authCredentialsTable).go();
  }

  Future<void> upsertSeller(SellersTableCompanion entry) {
    return into(sellersTable).insertOnConflictUpdate(entry);
  }

  Future<SellersTableData?> fetchSellerById(String id) {
    return (select(
      sellersTable,
    )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  Future<SellersTableData?> fetchSellerByUserId(String userId) {
    return (select(
      sellersTable,
    )..where((tbl) => tbl.userId.equals(userId))).getSingleOrNull();
  }

  Stream<List<SellersTableData>> watchSellers() {
    return select(sellersTable).watch();
  }

  Stream<List<ProductsTableData>> watchProducts({String? sellerId}) {
    final query = select(productsTable)
      ..orderBy([
        (tbl) =>
            OrderingTerm(expression: tbl.updatedAt, mode: OrderingMode.desc),
        (tbl) => OrderingTerm(expression: tbl.name, mode: OrderingMode.asc),
      ]);
    if (sellerId != null) {
      query.where((tbl) => tbl.sellerId.equals(sellerId));
    }
    return query.watch();
  }

  Future<List<ProductsTableData>> fetchProductsBySeller(String sellerId) {
    return (select(
      productsTable,
    )..where((tbl) => tbl.sellerId.equals(sellerId))).get();
  }

  Future<ProductsTableData?> fetchProductById(String id) {
    return (select(
      productsTable,
    )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  Future<void> upsertProduct(ProductsTableCompanion entry) {
    return into(productsTable).insertOnConflictUpdate(entry);
  }

  Future<void> upsertProductsBatch(List<ProductsTableCompanion> entries) {
    if (entries.isEmpty) {
      return Future.value();
    }
    return batch((batch) {
      batch.insertAllOnConflictUpdate(productsTable, entries);
    });
  }

  Future<int> deleteProductById(String id) {
    return (delete(productsTable)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<List<ProductsTableData>> fetchPendingProducts() {
    return (select(productsTable)..where(
          (tbl) => tbl.isDirty.equals(true) | tbl.pendingOperation.isNotNull(),
        ))
        .get();
  }

  Future<List<String>> fetchDirtyProductIds() async {
    final rows =
        await (select(productsTable)..where(
              (tbl) =>
                  tbl.isDirty.equals(true) | tbl.pendingOperation.isNotNull(),
            ))
            .get();
    return rows.map((row) => row.id).toList();
  }

  Future<List<String>> fetchSimpleProductIds() async {
    final rows = await (select(productsTable)
          ..where((tbl) => tbl.metadataJson.isNotNull()))
        .get();
    final result = <String>[];
    for (final row in rows) {
      final raw = row.metadataJson;
      if (raw == null) {
        continue;
      }
      try {
        final decoded = jsonDecode(raw);
        if (decoded is Map<String, dynamic>) {
          final inventory = decoded['inventory'];
          if (inventory is Map<String, dynamic> &&
              inventory['simple'] == true) {
            result.add(row.id);
            continue;
          }
          if (decoded['simple'] == true) {
            result.add(row.id);
          }
        }
      } catch (_) {
        // ignore invalid metadata payloads
      }
    }
    return result;
  }

  Future<void> markProductSynced(String id, DateTime syncedAt) {
    return (update(productsTable)..where((tbl) => tbl.id.equals(id))).write(
      ProductsTableCompanion(
        isDirty: const Value(false),
        pendingOperation: const Value(null),
        syncedAt: Value(syncedAt),
      ),
    );
  }

  Future<void> markProductPending(String id, String operation) {
    return (update(productsTable)..where((tbl) => tbl.id.equals(id))).write(
      ProductsTableCompanion(
        isDirty: const Value(true),
        pendingOperation: Value(operation),
        syncedAt: const Value(null),
        updatedAt: Value(DateTime.now().toUtc()),
      ),
    );
  }

  Future<int> pruneProducts({
    required Set<String> remoteIds,
    String? sellerId,
  }) {
    final deleteQuery = delete(productsTable)
      ..where((tbl) {
        Expression<bool> predicate =
            tbl.isDirty.equals(false) & tbl.pendingOperation.isNull();
        if (sellerId != null) {
          predicate = predicate & tbl.sellerId.equals(sellerId);
        }
        if (remoteIds.isEmpty) {
          return predicate;
        }
        return predicate & tbl.id.isIn(remoteIds.toList()).not();
      });
    return deleteQuery.go();
  }

  Stream<List<InventoryLocationsTableData>> watchLocations({String? type}) {
    final query = select(inventoryLocationsTable)
      ..orderBy([
        (tbl) => OrderingTerm(expression: tbl.name, mode: OrderingMode.asc),
      ]);
    if (type != null) {
      query.where((tbl) => tbl.type.equals(type));
    }
    return query.watch();
  }

  Future<void> upsertLocation(InventoryLocationsTableCompanion entry) {
    return into(inventoryLocationsTable).insertOnConflictUpdate(entry);
  }

  Future<int> deleteLocation(String id) {
    return (delete(
      inventoryLocationsTable,
    )..where((tbl) => tbl.id.equals(id))).go();
  }

  Stream<List<EmployeesTableData>> watchEmployees({String? locationId}) {
    final query = select(employeesTable)
      ..orderBy([
        (tbl) =>
            OrderingTerm(expression: tbl.firstName, mode: OrderingMode.asc),
        (tbl) => OrderingTerm(expression: tbl.lastName, mode: OrderingMode.asc),
      ]);
    if (locationId != null) {
      query.where((tbl) => tbl.locationId.equals(locationId));
    }
    return query.watch();
  }

  Future<void> upsertEmployee(EmployeesTableCompanion entry) {
    return into(employeesTable).insertOnConflictUpdate(entry);
  }

  Future<int> deleteEmployee(String id) {
    return (delete(employeesTable)..where((tbl) => tbl.id.equals(id))).go();
  }

  Stream<List<InventoryStocksTableData>> watchInventoryStocks({
    String? locationId,
  }) {
    final query = select(inventoryStocksTable);
    if (locationId != null) {
      query.where((tbl) => tbl.locationId.equals(locationId));
    }
    return query.watch();
  }

  Future<InventoryStocksTableData?> fetchInventoryStock(
    String productId,
    String locationId,
  ) {
    return (select(inventoryStocksTable)..where(
          (tbl) =>
              tbl.productId.equals(productId) &
              tbl.locationId.equals(locationId),
        ))
        .getSingleOrNull();
  }

  Future<void> saveInventoryStock(InventoryStocksTableCompanion entry) {
    return into(inventoryStocksTable).insertOnConflictUpdate(entry);
  }

  Stream<List<InventoryMovementsTableData>> watchInventoryMovements({
    String? productId,
    String? locationId,
  }) {
    final query = select(inventoryMovementsTable)
      ..orderBy([
        (tbl) =>
            OrderingTerm(expression: tbl.occurredAt, mode: OrderingMode.desc),
      ]);
    if (productId != null) {
      query.where((tbl) => tbl.productId.equals(productId));
    }
    if (locationId != null) {
      query.where((tbl) => tbl.locationId.equals(locationId));
    }
    return query.watch();
  }

  Future<List<InventoryMovementsTableData>> fetchUnsyncedMovements() {
    return (select(inventoryMovementsTable)
          ..where((tbl) => tbl.syncedAt.isNull()))
        .get();
  }

  Future<void> markMovementSynced(String id, DateTime ts) {
    return (update(inventoryMovementsTable)..where((t) => t.id.equals(id)))
        .write(InventoryMovementsTableCompanion(syncedAt: Value(ts)));
  }

  // --- Sync helpers ---
  Future<List<InventoryLocationsTableData>> fetchUnsyncedLocations() {
    return (select(inventoryLocationsTable)..where(
          (tbl) =>
              tbl.syncedAt.isNull() | tbl.syncedAt.isSmallerThan(tbl.updatedAt),
        ))
        .get();
  }

  Future<void> markLocationSynced(String id, DateTime ts) {
    return (update(inventoryLocationsTable)..where((t) => t.id.equals(id)))
        .write(InventoryLocationsTableCompanion(syncedAt: Value(ts)));
  }

  Future<DateTime?> fetchMaxLocationsSyncedAt() async {
    final row = await customSelect(
      'SELECT MAX(synced_at) as max_ts FROM inventory_locations_table',
    ).getSingleOrNull();
    final raw = row?.data['max_ts'];
    if (raw is DateTime) {
      return raw.toUtc();
    }
    if (raw is String) {
      return DateTime.tryParse(raw)?.toUtc();
    }
    return null;
  }

  Future<DateTime?> fetchMaxLocationsUpdatedAt() async {
    final row = await customSelect(
      'SELECT MAX(updated_at) as max_ts FROM inventory_locations_table',
    ).getSingleOrNull();
    final val = row?.data['max_ts'] as DateTime?;
    return val;
  }

  Future<List<EmployeesTableData>> fetchUnsyncedEmployees() {
    return (select(employeesTable)..where(
          (tbl) =>
              tbl.syncedAt.isNull() | tbl.syncedAt.isSmallerThan(tbl.updatedAt),
        ))
        .get();
  }

  Future<void> markEmployeeSynced(String id, DateTime ts) {
    return (update(employeesTable)..where((t) => t.id.equals(id))).write(
      EmployeesTableCompanion(syncedAt: Value(ts)),
    );
  }

  Future<DateTime?> fetchMaxEmployeesSyncedAt() async {
    final row = await customSelect(
      'SELECT MAX(synced_at) as max_ts FROM employees_table',
    ).getSingleOrNull();
    final raw = row?.data['max_ts'];
    if (raw is DateTime) {
      return raw.toUtc();
    }
    if (raw is String) {
      return DateTime.tryParse(raw)?.toUtc();
    }
    return null;
  }

  Future<DateTime?> fetchMaxEmployeesUpdatedAt() async {
    final row = await customSelect(
      'SELECT MAX(updated_at) as max_ts FROM employees_table',
    ).getSingleOrNull();
    final val = row?.data['max_ts'] as DateTime?;
    return val;
  }

  Future<List<PurchaseHeadersTableData>> fetchUnsyncedPurchases() {
    return (select(purchaseHeadersTable)..where(
          (tbl) =>
              tbl.syncedAt.isNull() | tbl.syncedAt.isSmallerThan(tbl.updatedAt),
        ))
        .get();
  }

  Future<List<PurchaseItemsTableData>> fetchPurchaseItems(String purchaseId) {
    return (select(
      purchaseItemsTable,
    )..where((t) => t.purchaseId.equals(purchaseId))).get();
  }

  Future<void> markPurchaseSynced(String id, DateTime ts) async {
    final tsStr = ts.toUtc().toIso8601String();
    await customStatement(
      "UPDATE purchase_headers_table SET synced_at = '$tsStr' WHERE id = '$id'",
    );
  }

  Future<DateTime?> fetchMaxPurchasesUpdatedAt() async {
    final row = await customSelect(
      'SELECT MAX(updated_at) as max_ts FROM purchase_headers_table',
    ).getSingleOrNull();
    final val = row?.data['max_ts'] as DateTime?;
    return val;
  }

  Future<List<SalesHeadersTableData>> fetchUnsyncedSales() {
    return (select(salesHeadersTable)..where(
          (tbl) =>
              tbl.syncedAt.isNull() | tbl.syncedAt.isSmallerThan(tbl.updatedAt),
        ))
        .get();
  }

  Future<List<SalesItemsTableData>> fetchSaleItems(String saleId) {
    return (select(
      salesItemsTable,
    )..where((t) => t.saleId.equals(saleId))).get();
  }

  Future<void> markSaleSynced(String id, DateTime ts) async {
    final tsStr = ts.toUtc().toIso8601String();
    await customStatement(
      "UPDATE sales_headers_table SET synced_at = '$tsStr' WHERE id = '$id'",
    );
  }

  Future<DateTime?> fetchMaxSalesUpdatedAt() async {
    final row = await customSelect(
      'SELECT MAX(updated_at) as max_ts FROM sales_headers_table',
    ).getSingleOrNull();
    final val = row?.data['max_ts'] as DateTime?;
    return val;
  }

  Future<List<TransferHeadersTableData>> fetchUnsyncedTransfers() {
    return (select(transferHeadersTable)..where(
          (tbl) =>
              tbl.syncedAt.isNull() | tbl.syncedAt.isSmallerThan(tbl.updatedAt),
        ))
        .get();
  }

  Future<List<TransferItemsTableData>> fetchTransferItems(String transferId) {
    return (select(
      transferItemsTable,
    )..where((t) => t.transferId.equals(transferId))).get();
  }

  Future<void> markTransferSynced(String id, DateTime ts) async {
    final tsStr = ts.toUtc().toIso8601String();
    await customStatement(
      "UPDATE transfer_headers_table SET synced_at = '$tsStr' WHERE id = '$id'",
    );
  }

  Future<DateTime?> fetchMaxTransfersUpdatedAt() async {
    final row = await customSelect(
      'SELECT MAX(updated_at) as max_ts FROM transfer_headers_table',
    ).getSingleOrNull();
    final val = row?.data['max_ts'] as DateTime?;
    return val;
  }
}

QueryExecutor _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'market_app.db'));
    return NativeDatabase.createInBackground(file);
  });
}
