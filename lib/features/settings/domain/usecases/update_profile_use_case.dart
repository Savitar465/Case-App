import '../entities/account_settings.dart';
import '../repositories/settings_repository.dart';

class UpdateProfileUseCase {
  const UpdateProfileUseCase(this._repository);

  final SettingsRepository _repository;

  Future<AccountSettings> call({
    required String fullName,
    required String username,
    String? phone,
    String? avatarFilePath,
  }) => _repository.updateProfile(
    fullName: fullName,
    username: username,
    phone: phone,
    avatarFilePath: avatarFilePath,
  );
}
