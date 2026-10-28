import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/offer_detail.dart';
import '../../domain/entities/offer_failure.dart';
import '../../domain/usecases/get_followed_business_ids_use_case.dart';
import '../../domain/usecases/refresh_active_offers_use_case.dart';
import '../../domain/usecases/watch_active_offers_use_case.dart';

part 'offers_feed_state.dart';

/// Drives the "Ofertas" tab: every active offer plus the user's filters.
class OffersFeedCubit extends Cubit<OffersFeedState> {
  OffersFeedCubit({
    required WatchActiveOffersUseCase watchActiveOffers,
    required RefreshActiveOffersUseCase refreshActiveOffers,
    required GetFollowedBusinessIdsUseCase getFollowedBusinessIds,
  }) : _watchActiveOffers = watchActiveOffers,
       _refreshActiveOffers = refreshActiveOffers,
       _getFollowedBusinessIds = getFollowedBusinessIds,
       super(const OffersFeedState());

  final WatchActiveOffersUseCase _watchActiveOffers;
  final RefreshActiveOffersUseCase _refreshActiveOffers;
  final GetFollowedBusinessIdsUseCase _getFollowedBusinessIds;
  StreamSubscription<List<OfferDetail>>? _subscription;

  Future<void> initialize() async {
    await _subscription?.cancel();
    // isLoading is owned by refresh(): the cache replays an empty list first.
    _subscription = _watchActiveOffers().listen(
      (offers) => emit(state.copyWith(offers: offers)),
      onError: (Object error, _) =>
          emit(state.copyWith(error: _describe(error))),
    );
    await refresh();
  }

  Future<void> refresh() async {
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      await _refreshActiveOffers();
      final followed = await _getFollowedBusinessIds();
      emit(state.copyWith(isLoading: false, followedBusinessIds: followed));
    } on OfferFailure catch (failure) {
      emit(state.copyWith(isLoading: false, error: failure.message));
    } catch (error) {
      emit(state.copyWith(isLoading: false, error: _describe(error)));
    }
  }

  /// Follows change on the business profile; cheap to re-read on tab focus.
  Future<void> refreshFollowed() async {
    try {
      final followed = await _getFollowedBusinessIds();
      emit(state.copyWith(followedBusinessIds: followed));
    } catch (_) {
      // Non-critical: the section keeps the previous follows.
    }
  }

  void setQuery(String query) => emit(state.copyWith(query: query));

  void setExpiry(ExpiryFilter expiry) => emit(state.copyWith(expiry: expiry));

  void setMinDiscount(int? percent) => emit(
    state.copyWith(minDiscount: percent, clearMinDiscount: percent == null),
  );

  void setBusinessIds(Set<String> ids) =>
      emit(state.copyWith(businessIds: ids));

  void applyFilters({
    required ExpiryFilter expiry,
    required int? minDiscount,
    required Set<String> businessIds,
  }) {
    emit(
      state.copyWith(
        expiry: expiry,
        minDiscount: minDiscount,
        clearMinDiscount: minDiscount == null,
        businessIds: businessIds,
      ),
    );
  }

  void clearFilters() => applyFilters(
    expiry: ExpiryFilter.any,
    minDiscount: null,
    businessIds: const {},
  );

  String _describe(Object error) => error is OfferFailure
      ? error.message
      : 'No se pudieron cargar las ofertas';

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
