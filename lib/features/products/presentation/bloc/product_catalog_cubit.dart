import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:market_app/features/products/domain/entities/product.dart';
import 'package:market_app/features/products/domain/entities/product_failure.dart';
import 'package:market_app/features/products/domain/repositories/product_repository.dart';

part 'product_catalog_state.dart';

class ProductCatalogCubit extends Cubit<ProductCatalogState> {
  ProductCatalogCubit({required ProductRepository repository, String? sellerId})
    : _repository = repository,
      _sellerId = sellerId,
      super(const ProductCatalogState.initial()) {
    _subscription = _repository
        .watchProducts(sellerId: _sellerId)
        .listen(
          (products) {
            emit(
              state.copyWith(
                products: products,
                isLoading: false,
                hasPendingChanges: products.any(
                  (product) => product.hasPendingChanges,
                ),
                errorMessage: state.errorMessage,
              ),
            );
          },
          onError: (error, _) {
            emit(
              state.copyWith(isLoading: false, errorMessage: error.toString()),
            );
          },
        );
  }

  final ProductRepository _repository;
  final String? _sellerId;
  StreamSubscription<List<Product>>? _subscription;

  Future<void> refresh() async {
    emit(state.copyWith(isSyncing: true, errorMessage: null));
    try {
      await _repository.syncProducts(sellerId: _sellerId);
      emit(state.copyWith(isSyncing: false, lastSyncedAt: DateTime.now()));
    } on ProductFailure catch (error) {
      emit(state.copyWith(isSyncing: false, errorMessage: error.message));
    } catch (error) {
      emit(state.copyWith(isSyncing: false, errorMessage: error.toString()));
    }
  }

  Future<void> syncPending() async {
    emit(state.copyWith(isSyncing: true, errorMessage: null));
    try {
      await _repository.syncPendingOperations();
      emit(state.copyWith(isSyncing: false, lastSyncedAt: DateTime.now()));
    } on ProductFailure catch (error) {
      emit(state.copyWith(isSyncing: false, errorMessage: error.message));
    } catch (error) {
      emit(state.copyWith(isSyncing: false, errorMessage: error.toString()));
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
