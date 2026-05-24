import '../repositories/follow_repository.dart';

class RefreshFollowsUseCase {
  const RefreshFollowsUseCase(this._repository);

  final FollowRepository _repository;

  Future<void> call() => _repository.refreshFollows();
}
