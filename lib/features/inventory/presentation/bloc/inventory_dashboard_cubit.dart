import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/inventory_report.dart';
import '../../domain/entities/inventory_stock.dart';
import '../../domain/repositories/inventory_repository.dart';

class InventoryDashboardState extends Equatable {
  const InventoryDashboardState({
    this.isLoading = true,
    this.todaySummary,
    this.globalInventory = const [],
    this.error,
  });

  final bool isLoading;
  final DailySalesSummary? todaySummary;
  final List<InventoryStock> globalInventory;
  final String? error;

  InventoryDashboardState copyWith({
    bool? isLoading,
    DailySalesSummary? todaySummary,
    List<InventoryStock>? globalInventory,
    String? error,
  }) {
    return InventoryDashboardState(
      isLoading: isLoading ?? this.isLoading,
      todaySummary: todaySummary ?? this.todaySummary,
      globalInventory: globalInventory ?? this.globalInventory,
      error: error,
    );
  }

  @override
  List<Object?> get props => [isLoading, todaySummary, globalInventory, error];
}

class InventoryDashboardCubit extends Cubit<InventoryDashboardState> {
  InventoryDashboardCubit({required InventoryRepository repository})
      : _repository = repository,
        super(const InventoryDashboardState());

  final InventoryRepository _repository;
  StreamSubscription<DailySalesSummary>? _summarySubscription;

  Future<void> initialize() async {
    emit(state.copyWith(isLoading: true, error: null));
    await _loadGlobalInventory();
    _summarySubscription?.cancel();
    _summarySubscription = _repository
        .watchDailySalesSummary(DateTime.now())
        .listen((summary) {
      emit(state.copyWith(isLoading: false, todaySummary: summary));
    }, onError: (error, stackTrace) {
      emit(state.copyWith(isLoading: false, error: error.toString()));
    });
  }

  Future<void> _loadGlobalInventory() async {
    try {
      final inventory = await _repository.fetchGlobalInventory();
      emit(state.copyWith(globalInventory: inventory, error: null));
    } catch (error) {
      emit(state.copyWith(error: error.toString()));
    }
  }

  @override
  Future<void> close() async {
    await _summarySubscription?.cancel();
    return super.close();
  }
}
