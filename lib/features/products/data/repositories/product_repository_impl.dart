import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:market_app/features/products/data/datasources/local/product_local_data_source.dart';
import 'package:market_app/features/products/data/datasources/remote/product_remote_data_source.dart';
import 'package:market_app/features/products/data/models/product_model.dart';
import 'package:market_app/features/products/domain/entities/product.dart';
import 'package:market_app/features/products/domain/entities/product_failure.dart';
import 'package:market_app/features/products/domain/entities/seller.dart';
import 'package:market_app/features/products/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  ProductRepositoryImpl({
    required ProductRemoteDataSource remoteDataSource,
    required ProductLocalDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  final ProductRemoteDataSource _remoteDataSource;
  final ProductLocalDataSource _localDataSource;

  @override
  Stream<List<Product>> watchProducts({String? sellerId}) {
    return _localDataSource
        .watchProducts(sellerId: sellerId)
        .map((models) => models.map((model) => model.toEntity()).toList());
  }

  @override
  Future<void> syncProducts({String? sellerId}) async {
    try {
      final remoteProducts = await _remoteDataSource.fetchProducts(
        sellerId: sellerId,
      );
      await _localDataSource.cacheRemoteProducts(
        remoteProducts,
        sellerId: sellerId,
      );
    } catch (error) {
      throw _mapInfraError(error);
    }
  }

  @override
  Future<void> syncPendingOperations() async {
    final pending = await _localDataSource.fetchPendingProducts();
    for (final pendingProduct in pending) {
      final productEntity = pendingProduct.toEntity();
      try {
        if (pendingProduct.syncStatus == ProductSyncStatus.pendingDelete) {
          await _remoteDataSource.deleteProduct(pendingProduct.id);
          await _localDataSource.removeProduct(pendingProduct.id);
        } else {
          final remote = await _remoteDataSource.upsertProduct(pendingProduct);
          await _localDataSource.markProductSynced(remote);
        }
      } catch (error) {
        throw _mapInfraError(error, product: productEntity);
      }
    }
  }

  @override
  Future<Product?> getProductById(String productId) async {
    final product = await _localDataSource.getProduct(productId);
    return product?.toEntity();
  }

  @override
  Future<Product> upsertProduct(Product product) async {
    final localModel = ProductModel.fromEntity(product, dirtyOverride: true);
    await _localDataSource.saveProduct(
      localModel,
      markDirty: true,
      updatedAt: DateTime.now().toUtc(),
    );

    try {
      final remote = await _remoteDataSource.upsertProduct(localModel);
      await _localDataSource.markProductSynced(remote);
      return remote.toEntity();
    } catch (error) {
      throw _mapInfraError(error, product: localModel.toEntity());
    }
  }

  @override
  Future<Product> createSimpleProduct({
    required String name,
    double? price,
    String? unit,
    String? description,
  }) async {
    final model = await _localDataSource.createSimpleProduct(
      name: name,
      price: price ?? 0,
      unit: unit,
      description: description,
    );
    try {
      final remote = await _remoteDataSource.upsertProduct(model);
      await _localDataSource.markProductSynced(remote);
      return remote.toEntity();
    } catch (error, stackTrace) {
      // Simple-product creation is best-effort online: the local row is the
      // source of truth and a later `syncPendingOperations` will retry.
      developer.log(
        'Failed to sync simple product (will retry later)',
        name: 'ProductRepositoryImpl',
        error: error,
        stackTrace: stackTrace,
      );
      return model.toEntity();
    }
  }

  @override
  Future<void> deleteProduct(String productId) async {
    final existing = await _localDataSource.getProduct(productId);
    if (existing == null) {
      return;
    }
    await _localDataSource.markProductPendingDelete(productId);

    final pendingEntity = existing.toEntity().copyWith(
          syncStatus: ProductSyncStatus.pendingDelete,
        );

    try {
      await _remoteDataSource.deleteProduct(productId);
      await _localDataSource.removeProduct(productId);
    } catch (error) {
      throw _mapInfraError(error, product: pendingEntity);
    }
  }

  @override
  Future<Seller?> loadSellerForUser(String userId) async {
    final seller = await _localDataSource.getSellerForUser(userId);
    return seller?.toEntity();
  }

  @override
  Future<Seller?> refreshSellerForUser(String userId) async {
    try {
      final seller = await _remoteDataSource.fetchSellerForUser(userId);
      if (seller == null) {
        return null;
      }
      await _localDataSource.saveSeller(seller);
      return seller.toEntity();
    } catch (error) {
      throw _mapInfraError(error);
    }
  }

  /// Translates infrastructure exceptions into a [ProductFailure] so the
  /// presentation layer only deals with one error type. Anything we don't
  /// recognize is re-thrown unchanged.
  ProductFailure _mapInfraError(Object error, {Product? product}) {
    if (error is ProductFailure) return error;
    if (error is ProductRemoteException) {
      return ProductFailure(error.message, product: product);
    }
    if (error is SocketException) {
      return ProductFailure('No internet connection', product: product);
    }
    if (error is TimeoutException) {
      return ProductFailure('Request timed out', product: product);
    }
    return ProductFailure(error.toString(), product: product);
  }
}
