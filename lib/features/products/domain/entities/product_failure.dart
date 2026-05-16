import 'package:equatable/equatable.dart';

import 'package:market_app/features/products/domain/entities/product.dart';

/// Thrown by the product repository when an operation cannot be completed.
///
/// [product] is the local snapshot at the moment of failure, so the UI can
/// show "saved offline" or keep editing without losing input.
class ProductFailure extends Equatable implements Exception {
  const ProductFailure(this.message, {this.product});

  final String message;
  final Product? product;

  @override
  List<Object?> get props => [message, product];

  @override
  String toString() => 'ProductFailure: $message';
}
