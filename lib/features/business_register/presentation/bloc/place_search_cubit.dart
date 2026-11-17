import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../domain/entities/business_registration_failure.dart';
import '../../domain/entities/place_location.dart';
import '../../domain/entities/place_suggestion.dart';
import '../../domain/repositories/place_search_repository.dart';
import '../../domain/usecases/get_place_location_use_case.dart';
import '../../domain/usecases/search_places_use_case.dart';

part 'place_search_state.dart';

/// Address suggestions for the location picker, refreshed as the user types.
class PlaceSearchCubit extends Cubit<PlaceSearchState> {
  PlaceSearchCubit({required PlaceSearchRepository repository})
    : _searchPlaces = SearchPlacesUseCase(repository),
      _getPlaceLocation = GetPlaceLocationUseCase(repository),
      super(const PlaceSearchState());

  static const int _minQueryLength = 3;
  static const Duration _debounce = Duration(milliseconds: 350);

  final SearchPlacesUseCase _searchPlaces;
  final GetPlaceLocationUseCase _getPlaceLocation;

  Timer? _timer;

  /// Bumped on every new query/clear so late responses are discarded.
  int _generation = 0;

  /// Debounces typing, then loads suggestions biased towards the given point.
  void queryChanged(
    String query, {
    double? nearLatitude,
    double? nearLongitude,
  }) {
    final trimmed = query.trim();
    if (trimmed.length < _minQueryLength) {
      clear();
      return;
    }
    _timer?.cancel();
    final generation = ++_generation;
    _timer = Timer(
      _debounce,
      () => _search(trimmed, generation, nearLatitude, nearLongitude),
    );
  }

  Future<void> _search(
    String query,
    int generation,
    double? nearLatitude,
    double? nearLongitude,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final suggestions = await _searchPlaces(
        query,
        nearLatitude: nearLatitude,
        nearLongitude: nearLongitude,
      );
      if (isClosed || generation != _generation) return;
      emit(PlaceSearchState(suggestions: suggestions));
    } on BusinessRegistrationFailure catch (failure) {
      _onSearchError(failure.message, generation);
    } catch (error) {
      _onSearchError(error.toString(), generation);
    }
  }

  // Suggestions are an aid: a failed lookup just shows none (the user can
  // still tap the map), so it is logged instead of surfaced on every key.
  void _onSearchError(String message, int generation) {
    debugPrint('Place search failed: $message');
    if (isClosed || generation != _generation) return;
    emit(const PlaceSearchState());
  }

  /// Resolves the coordinates of a tapped suggestion and closes the list.
  /// Throws [BusinessRegistrationFailure] when the lookup fails.
  Future<PlaceLocation> select(PlaceSuggestion suggestion) {
    clear();
    return _getPlaceLocation(suggestion.placeId);
  }

  void clear() {
    _timer?.cancel();
    _generation++;
    if (state != const PlaceSearchState()) emit(const PlaceSearchState());
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
