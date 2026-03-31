import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/inventory_location.dart';
import '../../domain/entities/inventory_stock.dart';
import '../../domain/repositories/inventory_repository.dart';

class InventoryStockState extends Equatable {
  const InventoryStockState({
    this.isLoading = true,
    this.stocks = const [],
    this.locationId,
    this.locationType,
    this.error,
  });

  final bool isLoading;
  final List<InventoryStock> stocks;
  final String? locationId;
  final InventoryLocationType? locationType;
  final String? error;

  InventoryStockState copyWith({
    bool? isLoading,
    List<InventoryStock>? stocks,
    String? locationId,
    InventoryLocationType? locationType,
    String? error,
  }) {
    return InventoryStockState(
      isLoading: isLoading ?? this.isLoading,
      stocks: stocks ?? this.stocks,
      locationId: locationId ?? this.locationId,
      locationType: locationType ?? this.locationType,
      error: error,
    );
  }

  @override
  List<Object?> get props => [isLoading, stocks, locationId, locationType, error];
}

class InventoryStockCubit extends Cubit<InventoryStockState> {
  InventoryStockCubit({required InventoryRepository repository})
      : _repository = repository,
        super(const InventoryStockState());

  final InventoryRepository _repository;
  StreamSubscription<List<InventoryStock>>? _subscription;

  void watch({String? locationId, InventoryLocationType? locationType}) {
    emit(state.copyWith(
      isLoading: true,
      locationId: locationId,
      locationType: locationType,
      error: null,
    ));
    _subscription?.cancel();
    _subscription = _repository
        .watchInventory(locationId: locationId, locationType: locationType)
        .listen((stocks) {
      emit(state.copyWith(isLoading: false, stocks: stocks, error: null));
    }, onError: (error, stackTrace) {
      emit(state.copyWith(isLoading: false, error: error.toString()));
    });
  }

  Future<void> refreshGlobal() async {
    try {
      final data = await _repository.fetchGlobalInventory();
      emit(state.copyWith(isLoading: false, stocks: data, error: null,
          locationId: 'global', locationType: InventoryLocationType.store));
    } catch (error) {
      emit(state.copyWith(isLoading: false, error: error.toString()));
    }
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
