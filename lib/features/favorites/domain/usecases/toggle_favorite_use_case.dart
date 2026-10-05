import '../entities/favorite_kind.dart';
import '../repositories/favorites_repository.dart';

class ToggleFavoriteUseCase {
  const ToggleFavoriteUseCase(this._repository);

  final FavoritesRepository _repository;

  Future<bool> call({required FavoriteKind kind, required String targetId}) =>
      _repository.toggleFavorite(kind: kind, targetId: targetId);
}
