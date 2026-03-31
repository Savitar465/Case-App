import 'package:market_app/core/database/app_database.dart';
import 'package:market_app/features/products/data/models/product_model.dart';
import 'package:market_app/features/products/data/models/seller_model.dart';
import 'package:market_app/features/products/domain/entities/product.dart';
import 'package:uuid/uuid.dart';

class ProductLocalDataSource {
  ProductLocalDataSource(this._database);

  final AppDatabase _database;
  final Uuid _uuid = const Uuid();
  static const String _simpleProductSellerId = 'inventory_simple';
  static const Map<String, dynamic> _simpleProductMetadata = {
    'inventory': {'simple': true},
  };

  Stream<List<ProductModel>> watchProducts({String? sellerId}) {
    return _database
        .watchProducts(sellerId: sellerId)
        .map(
          (rows) => rows
              .map(ProductModel.fromTable)
              .where((product) => !product.isMarkedForDeletion)
              .toList(),
        );
  }

  Future<ProductModel?> getProduct(String id) async {
    final data = await _database.fetchProductById(id);
    if (data == null) {
      return null;
    }
    return ProductModel.fromTable(data);
  }

  Future<void> saveProduct(
    ProductModel product, {
    bool markDirty = false,
    ProductSyncStatus? syncOverride,
    DateTime? updatedAt,
  }) async {
    final syncStatus =
        syncOverride ??
        (markDirty ? ProductSyncStatus.pendingUpsert : product.syncStatus);
    final updatedProduct = product.copyWith(
      syncStatus: syncStatus,
      isDirty: markDirty ? true : product.isDirty,
      pendingOperation: markDirty
          ? ProductSyncStatus.pendingUpsert.label
          : product.pendingOperation,
      updatedAt: updatedAt ?? DateTime.now().toUtc(),
    );

    await _database.upsertProduct(
      updatedProduct.toCompanion(
        dirtyOverride: markDirty ? true : null,
        pendingOperationOverride: markDirty
            ? ProductSyncStatus.pendingUpsert.label
            : null,
        updatedAtOverride: updatedProduct.updatedAt,
        syncedAtOverride: markDirty ? null : updatedProduct.syncedAt,
      ),
    );
  }

  Future<void> markProductPendingDelete(String id) {
    return _database.markProductPending(
      id,
      ProductSyncStatus.pendingDelete.label,
    );
  }

  Future<void> removeProduct(String id) {
    return _database.deleteProductById(id);
  }

  Future<List<ProductModel>> fetchPendingProducts() async {
    final rows = await _database.fetchPendingProducts();
    return rows.map(ProductModel.fromTable).toList();
  }

  Future<void> markProductSynced(ProductModel product) {
    final syncedAt = DateTime.now().toUtc();
    return _database.upsertProduct(
      product
          .copyWith(
            syncStatus: ProductSyncStatus.synced,
            isDirty: false,
            pendingOperation: null,
            syncedAt: syncedAt,
          )
          .toCompanion(
            dirtyOverride: false,
            pendingOperationOverride: null,
            syncedAtOverride: syncedAt,
          ),
    );
  }

  Future<void> cacheRemoteProducts(
    List<ProductModel> remoteProducts, {
    String? sellerId,
  }) async {
    final remoteIds = remoteProducts.map((product) => product.id).toSet();
    final simpleIds = await _database.fetchSimpleProductIds();
    final protectedIds = {...remoteIds, ...simpleIds};
    final dirtyIds = await _database.fetchDirtyProductIds();
    final now = DateTime.now().toUtc();

    print(dirtyIds);
    final entries = remoteProducts
        .where((product) => !dirtyIds.contains(product.id))
        .map(
          (product) => product
              .copyWith(
                syncStatus: ProductSyncStatus.synced,
                isDirty: false,
                pendingOperation: null,
                syncedAt: now,
              )
              .toCompanion(
                dirtyOverride: false,
                pendingOperationOverride: null,
                syncedAtOverride: now,
              ),
        )
        .toList();

    await _database.transaction(() async {
      if (entries.isNotEmpty) {
        await _database.upsertProductsBatch(entries);
      }
      await _database.pruneProducts(
        remoteIds: protectedIds,
        sellerId: sellerId,
      );
    });
  }

  Future<SellerModel?> getSellerForUser(String userId) async {
    final data = await _database.fetchSellerByUserId(userId);
    if (data == null) {
      return null;
    }
    return SellerModel.fromTable(data);
  }

  Future<SellerModel?> getSellerById(String sellerId) async {
    final data = await _database.fetchSellerById(sellerId);
    if (data == null) {
      return null;
    }
    return SellerModel.fromTable(data);
  }

  Future<void> saveSeller(SellerModel seller) {
    final syncedAt = seller.syncedAt ?? DateTime.now().toUtc();
    return _database.upsertSeller(
      seller
          .copyWith(syncedAt: syncedAt)
          .toCompanion(syncedAtOverride: syncedAt),
    );
  }

  Future<ProductModel> createSimpleProduct({
    required String name,
    required double price,
    String? unit,
    String? description,
  }) async {
    final now = DateTime.now().toUtc();
    final trimmedName = name.trim();
    final trimmedUnit = unit?.trim();
    final trimmedDescription = description?.trim();
    final model = ProductModel(
      id: _uuid.v4(),
      sellerId: _simpleProductSellerId,
      name: trimmedName,
      price: price,
      unit: trimmedUnit?.isEmpty ?? true ? null : trimmedUnit,
      description: trimmedDescription?.isEmpty ?? true ? null : trimmedDescription,
      category: null,
      quantity: null,
      isTrending: false,
      inStock: true,
      rating: null,
      createdAt: now,
      updatedAt: now,
      syncedAt: null,
      metadata: _simpleProductMetadata,
      syncStatus: ProductSyncStatus.pendingUpsert,
      isDirty: true,
      pendingOperation: ProductSyncStatus.pendingUpsert.label,
    );
    await _database.upsertProduct(
      model.toCompanion(
        dirtyOverride: true,
        pendingOperationOverride: ProductSyncStatus.pendingUpsert.label,
        syncedAtOverride: null,
        updatedAtOverride: now,
      ),
    );
    return model;
  }
}
