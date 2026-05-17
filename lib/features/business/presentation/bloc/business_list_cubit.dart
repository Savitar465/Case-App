import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:market_app/features/business/domain/entities/business.dart';
import 'package:market_app/features/business/domain/entities/business_failure.dart';
import 'package:market_app/features/business/domain/usecases/refresh_businesses_use_case.dart';
import 'package:market_app/features/business/domain/usecases/watch_businesses_use_case.dart';

part 'business_list_state.dart';

class BusinessListCubit extends Cubit<BusinessListState> {
  BusinessListCubit({
    required WatchBusinessesUseCase watchBusinesses,
    required RefreshBusinessesUseCase refreshBusinesses,
  })  : _watchBusinesses = watchBusinesses,
        _refreshBusinesses = refreshBusinesses,
        super(const BusinessListState());

  final WatchBusinessesUseCase _watchBusinesses;
  final RefreshBusinessesUseCase _refreshBusinesses;
  StreamSubscription<List<Business>>? _subscription;

  Future<void> initialize() async {
    emit(state.copyWith(isLoading: true, clearError: true));
    _subscription?.cancel();
    _subscription = _watchBusinesses().listen(
      (businesses) => emit(state.copyWith(businesses: businesses)),
      onError: (error, _) => emit(
        state.copyWith(isLoading: false, error: error.toString()),
      ),
    );
    await refresh();
  }

  Future<void> refresh() async {
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      await _refreshBusinesses();
      emit(state.copyWith(isLoading: false));
    } on BusinessFailure catch (failure) {
      emit(state.copyWith(isLoading: false, error: failure.message));
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
