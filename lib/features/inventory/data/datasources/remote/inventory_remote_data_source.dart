import 'package:market_app/features/inventory/data/models/employee_model.dart';
import 'package:market_app/features/inventory/data/models/inventory_location_model.dart';
import 'package:market_app/features/inventory/data/models/inventory_transaction_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class InventoryRemoteDataSource {
  InventoryRemoteDataSource(this._client);

  final SupabaseClient _client;

  static const String _schema = 'market';

  // Table names
  static const String _locationsTable = 'inventory_locations';
  static const String _employeesTable = 'employees';
  static const String _inventoryStocksTable = 'inventory_stocks';
  static const String _inventoryMovementsTable = 'inventory_movements';
  static const String _purchaseHeadersTable = 'purchase_headers';
  static const String _purchaseItemsTable = 'purchase_items';
  static const String _salesHeadersTable = 'sales_headers';
  static const String _salesItemsTable = 'sales_items';
  static const String _transferHeadersTable = 'transfer_headers';
  static const String _transferItemsTable = 'transfer_items';

  Future<List<InventoryLocationModel>> fetchLocations({
    DateTime? updatedAfter,
  }) async {
    final builder = _client.schema(_schema).from(_locationsTable).select();
    if (updatedAfter != null) {
      builder.gt('updated_at', updatedAfter.toUtc().toIso8601String());
    }
    final response =
        await builder.order('updated_at', ascending: false) as List<dynamic>;
    return response
        .whereType<Map<String, dynamic>>()
        .map(InventoryLocationModel.fromRemote)
        .toList();
  }

  Future<List<EmployeeModel>> fetchEmployees({DateTime? updatedAfter}) async {
    final builder = _client.schema(_schema).from(_employeesTable).select();
    if (updatedAfter != null) {
      builder.gt('updated_at', updatedAfter.toUtc().toIso8601String());
    }
    final response =
        await builder.order('updated_at', ascending: false) as List<dynamic>;
    return response
        .whereType<Map<String, dynamic>>()
        .map(EmployeeModel.fromRemote)
        .toList();
  }

  Future<List<Map<String, dynamic>>> fetchInventoryStocks({
    Set<String>? locationIds,
  }) async {
    final query = _client.schema(_schema).from(_inventoryStocksTable).select();
    if (locationIds != null && locationIds.isNotEmpty) {
      final filter = locationIds.map((id) => '"$id"').join(',');
      query.filter('location_id', 'in', '($filter)');
    }
    final response =
        await query.order('updated_at', ascending: false) as List<dynamic>;
    return response.whereType<Map<String, dynamic>>().toList();
  }

  Future<void> upsertInventoryStocks(
    List<Map<String, dynamic>> stocks,
  ) async {
    if (stocks.isEmpty) {
      return;
    }
    await _client
        .schema(_schema)
        .from(_inventoryStocksTable)
        .upsert(
          stocks,
          onConflict: 'product_id,location_id',
        );
  }

  Future<void> upsertInventoryMovements(
    List<InventoryMovementModel> movements,
  ) async {
    if (movements.isEmpty) {
      return;
    }
    final payload = movements.map((movement) {
      return {
        'id': movement.id,
        'product_id': movement.productId,
        'location_id': movement.locationId,
        'location_type': movement.locationType,
        'quantity': movement.quantity,
        'movement_type': movement.movementType,
        'reference_type': movement.referenceType,
        'reference_id': movement.referenceId,
        'created_by': movement.createdBy,
        'occurred_at': movement.occurredAt.toIso8601String(),
        'notes': movement.notes,
      };
    }).toList();
    await _client
        .schema(_schema)
        .from(_inventoryMovementsTable)
        .upsert(payload, onConflict: 'id');
  }

  Future<void> upsertLocation(InventoryLocationModel model) async {
    final map = {
      'id': model.id,
      'type': model.type,
      'code': model.code,
      'name': model.name,
      'description': model.description,
      'address': model.address,
      'phone': model.phone,
      'manager_id': model.managerId,
      'is_active': model.isActive,
      'created_at': model.createdAt?.toIso8601String(),
      'updated_at': model.updatedAt?.toIso8601String(),
    };
    try {
      await _client
          .schema(_schema)
          .from(_locationsTable)
          .upsert(map, onConflict: 'id')
          .select()
          .maybeSingle();
    } catch (error) {
      print('Error during upsert: $error');
    }
  }

  Future<void> deleteLocation(String id) async {
    await _client.schema(_schema).from(_locationsTable).delete().eq('id', id);
  }

  Future<void> upsertEmployee(EmployeeModel model) async {
    final map = {
      'id': model.id,
      'first_name': model.firstName,
      'last_name': model.lastName,
      'email': model.email,
      'phone': model.phone,
      'auth_user_id': model.authUserId,
      'role': model.role,
      'location_id': model.locationId,
      'location_type': model.locationType,
      'is_active': model.isActive,
      'hired_at': model.hiredAt?.toIso8601String(),
      'created_at': model.createdAt?.toIso8601String(),
      'updated_at': model.updatedAt?.toIso8601String(),
    };
    await _client
        .schema(_schema)
        .from(_employeesTable)
        .upsert(map, onConflict: 'id')
        .select()
        .maybeSingle();
  }

  Future<void> deleteEmployee(String id) async {
    await _client.schema(_schema).from(_employeesTable).delete().eq('id', id);
  }

  Future<void> savePurchase(PurchaseModel purchase) async {
    // Upsert header
    final header = {
      'id': purchase.id,
      'location_id': purchase.locationId,
      'location_type': purchase.locationType,
      'supplier_name': purchase.supplierName,
      'reference_code': purchase.referenceCode,
      'created_by_employee_id': purchase.createdByEmployeeId,
      'purchase_date': purchase.date.toIso8601String(),
      'total_cost': purchase.totalCost,
      'notes': purchase.notes,
      'created_at': DateTime.now().toUtc().toIso8601String(),
      'updated_at': DateTime.now().toUtc().toIso8601String(),
    };

    await _client
        .schema(_schema)
        .from(_purchaseHeadersTable)
        .upsert(header, onConflict: 'id')
        .select()
        .maybeSingle();

    // Replace items
    await _client
        .schema(_schema)
        .from(_purchaseItemsTable)
        .delete()
        .eq('purchase_id', purchase.id);

    if (purchase.lines.isNotEmpty) {
      final items = purchase.lines.map((line) {
        return {
          'id': '${purchase.id}_${line.productId}',
          'purchase_id': purchase.id,
          'product_id': line.productId,
          'quantity': line.quantity,
          'unit_cost': line.unitCost,
          'total_cost': line.lineTotal,
        };
      }).toList();

      await _client.schema(_schema).from(_purchaseItemsTable).insert(items);
    }
  }

  Future<void> saveSale(SaleModel sale) async {
    final header = {
      'id': sale.id,
      'store_id': sale.storeId,
      'reference_code': sale.referenceCode,
      'customer_name': sale.customerName,
      'created_by_employee_id': sale.createdByEmployeeId,
      'sale_date': sale.date.toIso8601String(),
      'total_amount': sale.totalAmount,
      'notes': sale.notes,
      'created_at': DateTime.now().toUtc().toIso8601String(),
      'updated_at': DateTime.now().toUtc().toIso8601String(),
    };

    await _client
        .schema(_schema)
        .from(_salesHeadersTable)
        .upsert(header, onConflict: 'id')
        .select()
        .maybeSingle();

    await _client
        .schema(_schema)
        .from(_salesItemsTable)
        .delete()
        .eq('sale_id', sale.id);

    if (sale.lines.isNotEmpty) {
      final items = sale.lines.map((line) {
        return {
          'id': '${sale.id}_${line.productId}',
          'sale_id': sale.id,
          'product_id': line.productId,
          'quantity': line.quantity,
          'unit_price': line.unitPrice,
          'total_price': line.lineTotal,
        };
      }).toList();

      await _client.schema(_schema).from(_salesItemsTable).insert(items);
    }
  }

  Future<void> saveTransfer(TransferModel transfer) async {
    final header = {
      'id': transfer.id,
      'origin_location_id': transfer.originLocationId,
      'origin_location_type': transfer.originLocationType,
      'destination_location_id': transfer.destinationLocationId,
      'destination_location_type': transfer.destinationLocationType,
      'requested_by_employee_id': transfer.requestedByEmployeeId,
      'transfer_date': transfer.date.toIso8601String(),
      'status': transfer.status,
      'notes': transfer.notes,
      'created_at': DateTime.now().toUtc().toIso8601String(),
      'updated_at': DateTime.now().toUtc().toIso8601String(),
    };

    await _client
        .schema(_schema)
        .from(_transferHeadersTable)
        .upsert(header, onConflict: 'id')
        .select()
        .maybeSingle();

    await _client
        .schema(_schema)
        .from(_transferItemsTable)
        .delete()
        .eq('transfer_id', transfer.id);

    if (transfer.lines.isNotEmpty) {
      final items = transfer.lines.map((line) {
        return {
          'id': '${transfer.id}_${line.productId}',
          'transfer_id': transfer.id,
          'product_id': line.productId,
          'quantity': line.quantity,
        };
      }).toList();

      await _client.schema(_schema).from(_transferItemsTable).insert(items);
    }
  }
}
