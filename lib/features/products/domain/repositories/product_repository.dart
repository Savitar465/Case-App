import 'package:market_app/features/products/domain/entities/product.dart';
import 'package:market_app/features/products/domain/entities/seller.dart';

abstract class ProductRepository {
  Stream<List<Product>> watchProducts({String? sellerId});

  Future<void> syncProducts({String? sellerId});

  Future<void> syncPendingOperations();

  Future<Product?> getProductById(String productId);

  Future<Product> upsertProduct(Product product);

  Future<Product> createSimpleProduct({
    required String name,
    double? price,
    String? unit,
    String? description,
  });

  Future<void> deleteProduct(String productId);

  Future<Seller?> loadSellerForUser(String userId);

  Future<Seller?> refreshSellerForUser(String userId);
}
