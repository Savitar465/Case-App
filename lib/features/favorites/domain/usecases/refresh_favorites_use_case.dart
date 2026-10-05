import '../repositories/favorites_repository.dart';

class RefreshFavoritesUseCase {
  const RefreshFavoritesUseCase(this._repository);

  final FavoritesRepository _repository;

  Future<void> call() => _repository.refreshFavorites();
}
