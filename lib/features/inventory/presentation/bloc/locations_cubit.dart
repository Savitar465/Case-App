import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/inventory_location.dart';
import '../../domain/repositories/inventory_repository.dart';

class LocationsState extends Equatable {
  const LocationsState({
    this.isLoading = true,
    this.stores = const [],
    this.warehouses = const [],
    this.error,
  });

  final bool isLoading;
  final List<InventoryLocation> stores;
  final List<InventoryLocation> warehouses;
  final String? error;

  LocationsState copyWith({
    bool? isLoading,
    List<InventoryLocation>? stores,
    List<InventoryLocation>? warehouses,
    String? error,
  }) {
    return LocationsState(
      isLoading: isLoading ?? this.isLoading,
      stores: stores ?? this.stores,
      warehouses: warehouses ?? this.warehouses,
      error: error,
    );
  }

  @override
  List<Object?> get props => [isLoading, stores, warehouses, error];
}

class LocationsCubit extends Cubit<LocationsState> {
  LocationsCubit({required InventoryRepository repository})
      : _repository = repository,
        super(const LocationsState());

  final InventoryRepository _repository;
  StreamSubscription<List<InventoryLocation>>? _storeSubscription;
  StreamSubscription<List<InventoryLocation>>? _warehouseSubscription;

  void initialize() {
    emit(state.copyWith(isLoading: true, error: null));

    _storeSubscription?.cancel();
    _warehouseSubscription?.cancel();

    _storeSubscription = _repository
        .watchLocations(InventoryLocationType.store)
        .listen((stores) {
      emit(state.copyWith(isLoading: false, stores: stores, error: null));
    }, onError: (error, stackTrace) {
      emit(state.copyWith(isLoading: false, error: error.toString()));
    });

    _warehouseSubscription = _repository
        .watchLocations(InventoryLocationType.warehouse)
        .listen((warehouses) {
      emit(state.copyWith(isLoading: false, warehouses: warehouses, error: null));
    }, onError: (error, stackTrace) {
      emit(state.copyWith(isLoading: false, error: error.toString()));
    });
  }

  Future<void> saveLocation(InventoryLocation location) async {
    try {
      await _repository.saveLocation(location);
    } catch (error) {
      emit(state.copyWith(error: error.toString()));
    }
  }

  Future<void> deleteLocation(String locationId) async {
    try {
      await _repository.deleteLocation(locationId);
    } catch (error) {
      emit(state.copyWith(error: error.toString()));
    }
  }

  @override
  Future<void> close() async {
    await _storeSubscription?.cancel();
    await _warehouseSubscription?.cancel();
    return super.close();
  }
}
