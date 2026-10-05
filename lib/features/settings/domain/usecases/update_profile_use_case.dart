import '../entities/account_settings.dart';
import '../repositories/settings_repository.dart';

class UpdateProfileUseCase {
  const UpdateProfileUseCase(this._repository);

  final SettingsRepository _repository;

  Future<AccountSettings> call({required String fullName, String? phone}) =>
      _repository.updateProfile(fullName: fullName, phone: phone);
}
