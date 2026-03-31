import 'package:market_app/features/products/domain/entities/product.dart';

class ProductFailure implements Exception {
  const ProductFailure(this.message, {this.product});

  final String message;
  final Product? product;

  @override
  String toString() => message;
}
