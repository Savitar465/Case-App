import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import 'package:market_app/features/products/domain/entities/product.dart';
import 'package:market_app/features/products/domain/entities/product_failure.dart';
import 'package:market_app/features/products/domain/repositories/product_repository.dart';

part 'product_editor_state.dart';

class ProductEditorCubit extends Cubit<ProductEditorState> {
  ProductEditorCubit({
    required ProductRepository repository,
    required String sellerId,
  }) : _repository = repository,
       _sellerId = sellerId,
       super(const ProductEditorState());

  final ProductRepository _repository;
  final String _sellerId;
  final Uuid _uuid = const Uuid();

  void setDraft(Product? draft) {
    emit(
      state.copyWith(
        draft: draft,
        clearFailure: true,
        clearLastSaved: true,
        clearLastAction: true,
      ),
    );
  }

  Future<void> save(Product draft) async {
    emit(
      state.copyWith(
        isSaving: true,
        clearFailure: true,
        clearLastSaved: true,
        clearLastAction: true,
      ),
    );

    final product = draft.id.isEmpty
        ? draft.copyWith(id: _uuid.v4(), sellerId: _sellerId)
        : draft.copyWith(
            sellerId: draft.sellerId.isEmpty ? _sellerId : draft.sellerId,
          );

    try {
      final saved = await _repository.upsertProduct(product);
      emit(
        state.copyWith(
          isSaving: false,
          lastSaved: saved,
          draft: saved,
          lastAction: ProductEditorAction.saved,
        ),
      );
    } on ProductFailure catch (error) {
      emit(
        state.copyWith(
          isSaving: false,
          failure: error,
          draft: error.product ?? product,
          lastSaved: error.product,
          clearLastAction: true,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          isSaving: false,
          failure: ProductFailure(error.toString(), product: product),
          draft: product,
          clearLastAction: true,
        ),
      );
    }
  }

  Future<void> delete(String productId) async {
    emit(
      state.copyWith(
        isDeleting: true,
        clearFailure: true,
        clearLastAction: true,
      ),
    );
    try {
      await _repository.deleteProduct(productId);
      emit(
        state.copyWith(
          isDeleting: false,
          draft: null,
          lastSaved: null,
          lastAction: ProductEditorAction.deleted,
        ),
      );
    } on ProductFailure catch (error) {
      emit(
        state.copyWith(
          isDeleting: false,
          failure: error,
          clearLastAction: true,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          isDeleting: false,
          failure: ProductFailure(error.toString()),
          clearLastAction: true,
        ),
      );
    }
  }

  void clearStatus() {
    emit(
      state.copyWith(
        clearFailure: true,
        clearLastSaved: true,
        clearLastAction: true,
      ),
    );
  }
}
