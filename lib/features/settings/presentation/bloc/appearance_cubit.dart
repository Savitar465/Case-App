import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/settings_failure.dart';
import '../../domain/entities/theme_preference.dart';
import '../../domain/usecases/load_account_settings_use_case.dart';
import '../../domain/usecases/update_theme_preference_use_case.dart';

part 'appearance_state.dart';

/// App-wide theme choice. Provided above `MaterialApp` so `themeMode` follows
/// it; reloaded whenever the signed-in user changes.
class AppearanceCubit extends Cubit<AppearanceState> {
  AppearanceCubit({
    required LoadAccountSettingsUseCase loadSettings,
    required UpdateThemePreferenceUseCase updateTheme,
  }) : _loadSettings = loadSettings,
       _updateTheme = updateTheme,
       super(const AppearanceState());

  final LoadAccountSettingsUseCase _loadSettings;
  final UpdateThemePreferenceUseCase _updateTheme;

  /// Guests can switch the theme for this session, but there is no row to
  /// save it to.
  bool _canPersist = false;

  Future<void> load() async {
    try {
      final settings = await _loadSettings();
      _canPersist = settings != null;
      emit(
        state.copyWith(
          preference: settings?.theme ?? ThemePreference.system,
          clearError: true,
        ),
      );
    } catch (error) {
      // Keep the current theme; failing to load it shouldn't block the app.
      _canPersist = false;
    }
  }

  Future<void> select(ThemePreference preference) async {
    final previous = state.preference;
    if (previous == preference) return;
    emit(state.copyWith(preference: preference, clearError: true));
    if (!_canPersist) return;
    try {
      await _updateTheme(preference);
    } on SettingsFailure catch (failure) {
      emit(state.copyWith(preference: previous, error: failure.message));
    } catch (_) {
      emit(
        state.copyWith(
          preference: previous,
          error: 'No se pudo guardar la apariencia',
        ),
      );
    }
  }
}
