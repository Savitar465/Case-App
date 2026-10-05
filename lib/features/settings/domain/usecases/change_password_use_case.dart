import '../repositories/settings_repository.dart';

class ChangePasswordUseCase {
  const ChangePasswordUseCase(this._repository);

  final SettingsRepository _repository;

  Future<void> call({String? currentPassword, required String newPassword}) =>
      _repository.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
}
