import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market_app/features/market/domain/entities/business.dart';
import 'package:market_app/features/market/domain/entities/category.dart';
import 'package:market_app/features/market/domain/repositories/market_repository.dart';

part 'market_state.dart';

class MarketCubit extends Cubit<MarketState> {
  MarketCubit({required MarketRepository repository})
    : _repository = repository,
      super(const MarketState());

  final MarketRepository _repository;
  StreamSubscription? _catSub;
  StreamSubscription? _bizSub;

  void initialize() {
    debugPrint('MarketCubit: initialize() called');
    emit(state.copyWith(isLoading: true, clearError: true));

    _catSub = _repository.watchCategories().listen(
      (cats) {
        debugPrint('MarketCubit: Received ${cats.length} categories');
        emit(state.copyWith(categories: cats, isLoading: false));
      },
      onError: (e) =>
          emit(state.copyWith(isLoading: false, error: e.toString())),
    );

    _bizSub = _repository.watchBusinesses().listen(
      (biz) => emit(state.copyWith(businesses: biz, isLoading: false)),
      onError: (e) =>
          emit(state.copyWith(isLoading: false, error: e.toString())),
    );

    refresh();
  }

  Future<void> refresh() async {
    try {
      debugPrint('MarketCubit: refresh() requested');
      await _repository.refresh();
      debugPrint('MarketCubit: refresh() completed successfully');
    } catch (e) {
      debugPrint('MarketCubit: Error during refresh: $e');
      emit(state.copyWith(error: e.toString()));
    }
  }

  @override
  Future<void> close() {
    _catSub?.cancel();
    _bizSub?.cancel();
    return super.close();
  }
}
