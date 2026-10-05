import '../entities/theme_preference.dart';
import '../repositories/settings_repository.dart';

class UpdateThemePreferenceUseCase {
  const UpdateThemePreferenceUseCase(this._repository);

  final SettingsRepository _repository;

  Future<void> call(ThemePreference theme) => _repository.updateTheme(theme);
}
