import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/item.dart';
import '../../domain/entities/item_failure.dart';
import '../../domain/entities/item_type.dart';
import '../../domain/repositories/item_repository.dart';

part 'item_list_state.dart';

class ItemListCubit extends Cubit<ItemListState> {
  ItemListCubit({
    required ItemRepository repository,
    required String businessId,
  }) : _repository = repository,
       _businessId = businessId,
       super(const ItemListState());

  final ItemRepository _repository;
  final String _businessId;
  StreamSubscription<List<Item>>? _subscription;

  Future<void> initialize() async {
    emit(state.copyWith(isLoading: true, clearError: true));
    await _subscription?.cancel();
    _subscription = _repository.watchItems(_businessId).listen(
      (items) => emit(state.copyWith(isLoading: false, items: items)),
      onError: (Object error, _) {
        final message = error is ItemFailure ? error.message : error.toString();
        emit(state.copyWith(isLoading: false, error: message));
      },
    );
    await refresh();
  }

  Future<void> refresh() async {
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      await _repository.refreshItems(_businessId);
      emit(state.copyWith(isLoading: false));
    } on ItemFailure catch (failure) {
      emit(state.copyWith(isLoading: false, error: failure.message));
    } catch (error) {
      emit(state.copyWith(isLoading: false, error: error.toString()));
    }
  }

  void selectFilter(ItemTypeFilter filter) {
    emit(state.copyWith(filter: filter));
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
