import '../entities/auth_session.dart';
import '../repositories/auth_repository.dart';

class WatchSignInsUseCase {
  const WatchSignInsUseCase(this._repository);

  final AuthRepository _repository;

  Stream<AuthSession> call() => _repository.watchSignIns();
}
