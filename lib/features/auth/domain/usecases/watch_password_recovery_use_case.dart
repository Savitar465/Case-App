import '../repositories/auth_repository.dart';

class WatchPasswordRecoveryUseCase {
  const WatchPasswordRecoveryUseCase(this._repository);

  final AuthRepository _repository;

  Stream<void> call() => _repository.watchPasswordRecovery();
}
