import '../repositories/settings_repository.dart';

class RequestEmailChangeUseCase {
  const RequestEmailChangeUseCase(this._repository);

  final SettingsRepository _repository;

  Future<void> call(String newEmail) =>
      _repository.requestEmailChange(newEmail);
}
