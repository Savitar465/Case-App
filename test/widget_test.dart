import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:market_app/app/app.dart';
import 'package:market_app/features/auth/domain/entities/auth_session.dart';
import 'package:market_app/features/auth/domain/entities/auth_user.dart';
import 'package:market_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:market_app/features/auth/presentation/pages/login_page.dart';
import 'package:market_app/features/inventory/domain/entities/employee.dart';
import 'package:market_app/features/inventory/domain/entities/inventory_location.dart';
import 'package:market_app/features/inventory/domain/entities/inventory_report.dart';
import 'package:market_app/features/inventory/domain/entities/inventory_stock.dart';
import 'package:market_app/features/inventory/domain/entities/inventory_transaction.dart';
import 'package:market_app/features/inventory/domain/repositories/inventory_repository.dart';
import 'package:market_app/features/products/domain/entities/product.dart';
import 'package:market_app/features/products/domain/entities/seller.dart';
import 'package:market_app/features/products/domain/repositories/product_repository.dart';

class _FakeAuthRepository implements AuthRepository {
  @override
  Future<AuthSession> login({required String email, required String password}) {
    final user = AuthUser(id: '1', email: email);
    return Future.value(AuthSession(user: user, accessToken: 'token'));
  }

  @override
  Future<void> logout() async {}

  @override
  Future<AuthSession?> restoreSession() async => null;
}

class _FakeProductRepository implements ProductRepository {
  @override
  Future<void> deleteProduct(String productId) async {}

  @override
  Future<Product?> getProductById(String productId) async => null;

  @override
  Future<Seller?> loadSellerForUser(String userId) async => null;

  @override
  Future<Seller?> refreshSellerForUser(String userId) async => null;

  @override
  Future<void> syncPendingOperations() async {}

  @override
  Future<void> syncProducts({String? sellerId}) async {}

  @override
  Future<Product> upsertProduct(Product product) async => product;

  @override
  Future<Product> createSimpleProduct({
    required String name,
    double? price,
    String? unit,
    String? description,
  }) async {
    return Product(
      id: 'simple',
      sellerId: 'inventory_simple',
      name: name,
      price: price ?? 0,
      description: description,
      category: null,
      unit: unit,
      quantity: null,
      isTrending: false,
      inStock: true,
    );
  }

  @override
  Stream<List<Product>> watchProducts({String? sellerId}) =>
      Stream<List<Product>>.value(const []);
}

class _FakeInventoryRepository implements InventoryRepository {
  @override
  Future<double> fetchTodayGlobalSalesTotal() async => 0;

  @override
  Future<List<InventoryStock>> fetchGlobalInventory() async => const [];

  @override
  Future<InventoryStock?> getStockForProduct({
    required String productId,
    required String locationId,
  }) async => null;

  @override
  Future<void> deleteEmployee(String employeeId) async {}

  @override
  Future<void> deleteLocation(String locationId) async {}

  @override
  Future<void> recordPurchase(Purchase purchase) async {}

  @override
  Future<void> recordSale(Sale sale) async {}

  @override
  Future<void> recordTransfer(InventoryTransfer transfer) async {}

  @override
  Future<void> saveEmployee(Employee employee) async {}

  @override
  Future<void> saveLocation(InventoryLocation location) async {}

  @override
  Stream<List<Employee>> watchEmployees({String? locationId}) =>
      Stream.value(const []);

  @override
  Stream<List<InventoryLocation>> watchLocations(InventoryLocationType type) =>
      Stream.value(const []);

  @override
  Stream<List<InventoryStock>> watchInventory({
    String? locationId,
    InventoryLocationType? locationType,
  }) =>
      Stream.value(const []);

  @override
  Stream<List<SalesReportEntry>> watchSalesReport({
    String? storeId,
    DateRange? range,
  }) =>
      Stream.value(const []);

  @override
  Stream<List<PurchaseReportEntry>> watchPurchaseReport({
    String? locationId,
    DateRange? range,
  }) =>
      Stream.value(const []);

  @override
  Stream<List<TransferReportEntry>> watchTransferReport({
    String? originId,
    String? destinationId,
    DateRange? range,
  }) =>
      Stream.value(const []);

  @override
  Stream<DailySalesSummary> watchDailySalesSummary(DateTime date) =>
      Stream.value(DailySalesSummary(date: date, totalAmount: 0));

  @override
  Stream<List<InventoryMovement>> watchMovements({
    String? productId,
    String? locationId,
  }) =>
      Stream.value(const []);

  @override
  Future<void> syncPendingChanges() {
    // TODO: implement syncPendingChanges
    throw UnimplementedError();
  }
}

void main() {
  testWidgets('Shows Login screen initially', (WidgetTester tester) async {
    final repository = _FakeAuthRepository();
    final productRepository = _FakeProductRepository();
    final inventoryRepository = _FakeInventoryRepository();
    await tester.pumpWidget(
      App(
        authRepository: repository,
        productRepository: productRepository,
        inventoryRepository: inventoryRepository,
      ),
    );
    await tester.pump();

    expect(find.byType(LoginPage), findsOneWidget);
  });
}
