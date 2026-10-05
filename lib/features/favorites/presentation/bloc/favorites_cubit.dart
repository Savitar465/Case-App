import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/favorite_entry.dart';
import '../../domain/entities/favorite_failure.dart';
import '../../domain/entities/favorite_kind.dart';
import '../../domain/usecases/refresh_favorites_use_case.dart';
import '../../domain/usecases/toggle_favorite_use_case.dart';
import '../../domain/usecases/watch_favorites_use_case.dart';

part 'favorites_state.dart';

/// App-wide favorites: provided above `MaterialApp` so hearts on every screen
/// (home, business profile, favorites tab) stay in sync.
class FavoritesCubit extends Cubit<FavoritesState> {
  FavoritesCubit({
    required WatchFavoritesUseCase watchFavorites,
    required RefreshFavoritesUseCase refreshFavorites,
    required ToggleFavoriteUseCase toggleFavorite,
  }) : _watchFavorites = watchFavorites,
       _refreshFavorites = refreshFavorites,
       _toggleFavorite = toggleFavorite,
       super(const FavoritesState());

  final WatchFavoritesUseCase _watchFavorites;
  final RefreshFavoritesUseCase _refreshFavorites;
  final ToggleFavoriteUseCase _toggleFavorite;
  StreamSubscription<List<FavoriteEntry>>? _subscription;

  void initialize() {
    _subscription?.cancel();
    _subscription = _watchFavorites().listen(
      (entries) => emit(
        state.copyWith(
          entries: entries,
          keys: {
            for (final e in entries) FavoritesState.keyFor(e.kind, e.targetId),
          },
        ),
      ),
      onError: (Object error) => emit(state.copyWith(error: error.toString())),
    );
    refresh();
  }

  Future<void> refresh() async {
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      await _refreshFavorites();
      if (!isClosed) emit(state.copyWith(isLoading: false, hasLoaded: true));
    } on FavoriteFailure catch (e) {
      debugPrint('FavoritesCubit: refresh failed: ${e.message}');
      if (!isClosed) {
        emit(
          state.copyWith(isLoading: false, hasLoaded: true, error: e.message),
        );
      }
    } catch (e) {
      debugPrint('FavoritesCubit: refresh failed: $e');
      if (!isClosed) {
        emit(
          state.copyWith(
            isLoading: false,
            hasLoaded: true,
            error: e.toString(),
          ),
        );
      }
    }
  }

  /// Flips the heart immediately and rolls back if Supabase rejects it.
  Future<void> toggle(FavoriteKind kind, String targetId) async {
    final key = FavoritesState.keyFor(kind, targetId);
    final wasFavorite = state.keys.contains(key);
    emit(
      state.copyWith(
        keys: wasFavorite
            ? ({...state.keys}..remove(key))
            : {...state.keys, key},
        clearError: true,
      ),
    );
    try {
      await _toggleFavorite(kind: kind, targetId: targetId);
    } on FavoriteFailure catch (e) {
      if (!isClosed) _rollback(key, wasFavorite, e.message);
    } catch (e) {
      if (!isClosed) _rollback(key, wasFavorite, e.toString());
    }
  }

  void _rollback(String key, bool wasFavorite, String message) {
    emit(
      state.copyWith(
        keys: wasFavorite
            ? {...state.keys, key}
            : ({...state.keys}..remove(key)),
        error: message,
      ),
    );
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
