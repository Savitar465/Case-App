import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market_app/features/business/domain/entities/business_failure.dart';
import 'package:market_app/features/business/domain/repositories/business_repository.dart';
import 'package:market_app/features/market/domain/entities/business.dart';
import 'package:market_app/features/market/domain/entities/category.dart';
import 'package:market_app/features/market/domain/entities/home_offer.dart';
import 'package:market_app/features/market/domain/entities/market_failure.dart';
import 'package:market_app/features/market/domain/repositories/market_repository.dart';

part 'market_state.dart';

class MarketCubit extends Cubit<MarketState> {
  MarketCubit({
    required MarketRepository repository,
    required BusinessRepository businessRepository,
  })
      : _repository = repository,
        _businessRepository = businessRepository,
        super(const MarketState());

  final MarketRepository _repository;
  final BusinessRepository _businessRepository;
  StreamSubscription<List<MarketCategory>>? _catSub;
  StreamSubscription<List<Business>>? _bizSub;
  StreamSubscription<List<HomeOffer>>? _offerSub;

  void initialize() {
    _catSub?.cancel();
    _bizSub?.cancel();
    _offerSub?.cancel();

    _catSub = _repository.watchCategories().listen(
          (cats) => emit(state.copyWith(categories: cats)),
      onError: (Object e) => emit(state.copyWith(error: e.toString())),
    );
    _bizSub = _repository.watchBusinesses().listen(
          (biz) => emit(state.copyWith(businesses: biz)),
      onError: (Object e) => emit(state.copyWith(error: e.toString())),
    );
    _offerSub = _repository.watchOffers().listen(
          (offers) => emit(state.copyWith(offers: offers)),
      onError: (Object e) => emit(state.copyWith(error: e.toString())),
    );

    refresh();
  }

  Future<void> refresh() async {
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      await _repository.refresh();
      final favorites = await _repository.getFavoriteBusinessIds();
      if (isClosed) return;
      emit(state.copyWith(isLoading: false, favoriteIds: favorites));
    } on MarketFailure catch (e) {
      debugPrint('MarketCubit: refresh failed: ${e.message}');
      if (!isClosed) emit(state.copyWith(isLoading: false, error: e.message));
    } catch (e) {
      debugPrint('MarketCubit: refresh failed: $e');
      if (!isClosed) {
        emit(state.copyWith(isLoading: false, error: e.toString()));
      }
    }
  }

  void selectCategory(String? categoryId) {
    if (categoryId == null || categoryId == state.selectedCategoryId) {
      emit(state.copyWith(clearSelectedCategory: true));
    } else {
      emit(state.copyWith(selectedCategoryId: categoryId));
    }
  }

  void search(String query) => emit(state.copyWith(searchQuery: query));

  void toggleOpenNow() => emit(state.copyWith(openNowOnly: !state.openNowOnly));

  void toggleOffersOnly() =>
      emit(state.copyWith(offersOnly: !state.offersOnly));

  void toggleSortByDistance() =>
      emit(state.copyWith(sortByDistance: !state.sortByDistance));

  void clearFilters() =>
      emit(
        state.copyWith(
          clearSelectedCategory: true,
          openNowOnly: false,
          offersOnly: false,
          sortByDistance: false,
        ),
      );

  void setUserLocation({
    required double latitude,
    required double longitude,
    String? label,
  }) {
    emit(
      state.copyWith(
        userLatitude: latitude,
        userLongitude: longitude,
        locationLabel: label,
      ),
    );
  }

  /// Optimistically toggles the heart (a follow) and rolls back on failure.
  Future<void> toggleFavorite(String businessId) async {
    final previous = state.favoriteIds;
    final optimistic = {...previous};
    if (!optimistic.remove(businessId)) optimistic.add(businessId);
    emit(state.copyWith(favoriteIds: optimistic, clearError: true));
    try {
      final following = await _businessRepository.toggleFollow(businessId);
      if (isClosed) return;
      final confirmed = {...state.favoriteIds};
      if (following) {
        confirmed.add(businessId);
      } else {
        confirmed.remove(businessId);
      }
      emit(state.copyWith(favoriteIds: confirmed));
    } on BusinessFailure catch (e) {
      if (!isClosed) {
        emit(state.copyWith(favoriteIds: previous, error: e.message));
      }
    } catch (e) {
      if (!isClosed) {
        emit(state.copyWith(favoriteIds: previous, error: e.toString()));
      }
    }
  }

  @override
  Future<void> close() async {
    await _catSub?.cancel();
    await _bizSub?.cancel();
    await _offerSub?.cancel();
    return super.close();
  }
}
