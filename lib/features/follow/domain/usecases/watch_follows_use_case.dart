import '../entities/follow.dart';
import '../repositories/follow_repository.dart';

class WatchFollowsUseCase {
  const WatchFollowsUseCase(this._repository);

  final FollowRepository _repository;

  Stream<List<Follow>> call() => _repository.watchFollows();
}
