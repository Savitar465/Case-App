import 'package:market_app/features/inventory/domain/entities/employee.dart';
import 'package:market_app/features/inventory/domain/entities/inventory_location.dart';
import 'package:market_app/features/inventory/domain/entities/inventory_report.dart';
import 'package:market_app/features/inventory/domain/entities/inventory_stock.dart';
import 'package:market_app/features/inventory/domain/entities/inventory_transaction.dart';

abstract class InventoryRepository {
  Stream<List<InventoryLocation>> watchLocations(InventoryLocationType type);

  Future<void> saveLocation(InventoryLocation location);

  Future<void> deleteLocation(String locationId);

  Stream<List<Employee>> watchEmployees({String? locationId});

  Future<void> saveEmployee(Employee employee);

  Future<void> deleteEmployee(String employeeId);

  Stream<List<InventoryStock>> watchInventory({
    String? locationId,
    InventoryLocationType? locationType,
  });

  Future<List<InventoryStock>> fetchGlobalInventory();

  Future<InventoryStock?> getStockForProduct({
    required String productId,
    required String locationId,
  });

  Future<void> recordPurchase(Purchase purchase);

  Future<void> recordSale(Sale sale);

  Future<void> recordTransfer(InventoryTransfer transfer);

  Stream<List<SalesReportEntry>> watchSalesReport({
    String? storeId,
    DateRange? range,
  });

  Stream<List<PurchaseReportEntry>> watchPurchaseReport({
    String? locationId,
    DateRange? range,
  });

  Stream<List<TransferReportEntry>> watchTransferReport({
    String? originId,
    String? destinationId,
    DateRange? range,
  });

  Stream<DailySalesSummary> watchDailySalesSummary(DateTime date);

  Future<double> fetchTodayGlobalSalesTotal();

  Stream<List<InventoryMovement>> watchMovements({
    String? productId,
    String? locationId,
  });

  // Triggers a best-effort push of pending local changes to Supabase
  Future<void> syncPendingChanges();
}
