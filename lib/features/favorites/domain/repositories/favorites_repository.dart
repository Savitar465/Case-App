import '../entities/favorite_entry.dart';
import '../entities/favorite_kind.dart';

abstract class FavoritesRepository {
  /// Everything the signed-in user saved, newest first (empty when signed out).
  Stream<List<FavoriteEntry>> watchFavorites();

  /// Reloads the favorites cache from Supabase.
  Future<void> refreshFavorites();

  /// Saves or removes [targetId]; returns whether it is now a favorite.
  /// Throws `FavoriteFailure` when nobody is signed in.
  Future<bool> toggleFavorite({
    required FavoriteKind kind,
    required String targetId,
  });
}
