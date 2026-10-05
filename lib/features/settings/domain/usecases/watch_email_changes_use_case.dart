import '../repositories/settings_repository.dart';

class WatchEmailChangesUseCase {
  const WatchEmailChangesUseCase(this._repository);

  final SettingsRepository _repository;

  Stream<String> call() => _repository.watchEmailChanges();
}
