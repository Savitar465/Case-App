import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/business.dart';
import '../../domain/entities/business_failure.dart';
import '../../domain/repositories/business_repository.dart';

part 'business_list_state.dart';

class BusinessListCubit extends Cubit<BusinessListState> {
  BusinessListCubit({required BusinessRepository repository})
    : _repository = repository,
      super(const BusinessListState());

  final BusinessRepository _repository;
  StreamSubscription<List<Business>>? _subscription;

  Future<void> initialize() async {
    emit(state.copyWith(isLoading: true, clearError: true));
    await _subscription?.cancel();
    _subscription = _repository.watchBusinesses().listen(
      (businesses) =>
          emit(state.copyWith(isLoading: false, businesses: businesses)),
      onError: (Object error, _) {
        final message = error is BusinessFailure
            ? error.message
            : error.toString();
        emit(state.copyWith(isLoading: false, error: message));
      },
    );
    await refresh();
  }

  Future<void> refresh() async {
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      await _repository.refreshBusinesses();
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
