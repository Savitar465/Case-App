import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/offer.dart';
import '../../domain/entities/offer_failure.dart';
import '../../domain/repositories/offer_repository.dart';

part 'offer_list_state.dart';

class OfferListCubit extends Cubit<OfferListState> {
  OfferListCubit({
    required OfferRepository repository,
    required String businessId,
  }) : _repository = repository,
       _businessId = businessId,
       super(const OfferListState());

  final OfferRepository _repository;
  final String _businessId;
  StreamSubscription<List<Offer>>? _subscription;

  Future<void> initialize() async {
    emit(state.copyWith(isLoading: true, clearError: true));
    await _subscription?.cancel();
    _subscription = _repository
        .watchOffers(_businessId)
        .listen(
          (offers) => emit(state.copyWith(isLoading: false, offers: offers)),
          onError: (Object error, _) {
            final message = error is OfferFailure
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
      await _repository.refreshOffers(_businessId);
      emit(state.copyWith(isLoading: false));
    } on OfferFailure catch (failure) {
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
