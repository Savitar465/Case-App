import '../entities/favorite_entry.dart';
import '../repositories/favorites_repository.dart';

class WatchFavoritesUseCase {
  const WatchFavoritesUseCase(this._repository);

  final FavoritesRepository _repository;

  Stream<List<FavoriteEntry>> call() => _repository.watchFavorites();
}
