import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';

import '../../../../core/reactive/replay_subject.dart';
import '../../domain/entities/favorite_entry.dart';
import '../../domain/entities/favorite_failure.dart';
import '../../domain/entities/favorite_kind.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../datasources/remote/favorites_remote_data_source.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  FavoritesRepositoryImpl({required FavoritesRemoteDataSource remoteDataSource})
    : _remote = remoteDataSource;

  final FavoritesRemoteDataSource _remote;

  // Per-session in-memory cache.
  final _favoritesSubject = ReplaySubject<List<FavoriteEntry>>(const []);

  @override
  Stream<List<FavoriteEntry>> watchFavorites() => _favoritesSubject.stream;

  @override
  Future<void> refreshFavorites() async {
    try {
      final entries = await _remote.fetchFavorites();
      final epoch = DateTime.fromMillisecondsSinceEpoch(0);
      entries.sort(
        (a, b) => (b.savedAt ?? epoch).compareTo(a.savedAt ?? epoch),
      );
      _favoritesSubject.add(entries);
    } catch (error) {
      developer.log(
        'Favorites refresh failed',
        name: 'favorites.data',
        error: error,
      );
      throw _mapInfraError(error);
    }
  }

  @override
  Future<bool> toggleFavorite({
    required FavoriteKind kind,
    required String targetId,
  }) async {
    final current = _favoritesSubject.value;
    final isFavorite = current.any(
      (e) => _sameBucket(e.kind, kind) && e.targetId == targetId,
    );
    try {
      if (isFavorite) {
        await _remote.removeFavorite(kind, targetId);
        _favoritesSubject.add([
          for (final e in current)
            if (!(_sameBucket(e.kind, kind) && e.targetId == targetId)) e,
        ]);
        return false;
      }
      await _remote.addFavorite(kind, targetId);
      // Reload so the new entry arrives with its title, image and price.
      await refreshFavorites();
      return true;
    } catch (error) {
      throw _mapInfraError(error);
    }
  }

  /// Services and products share the `favorites` table, so a caller that
  /// only knows "it's an item" can toggle either.
  bool _sameBucket(FavoriteKind a, FavoriteKind b) {
    bool isItem(FavoriteKind k) =>
        k == FavoriteKind.service || k == FavoriteKind.product;
    return a == b || (isItem(a) && isItem(b));
  }

  FavoriteFailure _mapInfraError(Object error) {
    if (error is FavoriteFailure) return error;
    if (error is FavoritesRemoteException) {
      return FavoriteFailure(error.message);
    }
    if (error is SocketException) {
      return const FavoriteFailure('No hay conexión a internet');
    }
    if (error is TimeoutException) {
      return const FavoriteFailure('La solicitud ha tardado demasiado');
    }
    return FavoriteFailure(error.toString());
  }
}
