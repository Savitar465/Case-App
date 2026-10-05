import '../entities/account_settings.dart';
import '../repositories/settings_repository.dart';

class LoadAccountSettingsUseCase {
  const LoadAccountSettingsUseCase(this._repository);

  final SettingsRepository _repository;

  Future<AccountSettings?> call() => _repository.loadSettings();
}
