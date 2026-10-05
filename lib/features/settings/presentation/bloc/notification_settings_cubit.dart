import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/notification_preferences.dart';
import '../../domain/entities/settings_failure.dart';
import '../../domain/usecases/load_account_settings_use_case.dart';
import '../../domain/usecases/update_notification_preferences_use_case.dart';

part 'notification_settings_state.dart';

class NotificationSettingsCubit extends Cubit<NotificationSettingsState> {
  NotificationSettingsCubit({
    required LoadAccountSettingsUseCase loadSettings,
    required UpdateNotificationPreferencesUseCase updatePreferences,
  }) : _loadSettings = loadSettings,
       _updatePreferences = updatePreferences,
       super(const NotificationSettingsState());

  final LoadAccountSettingsUseCase _loadSettings;
  final UpdateNotificationPreferencesUseCase _updatePreferences;

  /// Saves run one after another so a quick double toggle can't land on the
  /// server out of order.
  Future<void> _pendingSave = Future.value();

  Future<void> load() async {
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      final settings = await _loadSettings();
      emit(
        state.copyWith(
          isLoading: false,
          preferences: settings?.notifications,
          error: settings == null
              ? 'Inicia sesión para configurar tus notificaciones'
              : null,
        ),
      );
    } on SettingsFailure catch (failure) {
      emit(state.copyWith(isLoading: false, error: failure.message));
    } catch (_) {
      emit(
        state.copyWith(
          isLoading: false,
          error: 'No se pudieron cargar tus preferencias',
        ),
      );
    }
  }

  void setAll(bool enabled) => _apply(
    NotificationPreferences(
      newOffers: enabled,
      expiringOffers: enabled,
      appMessages: enabled,
    ),
  );

  void setNewOffers(bool enabled) =>
      _apply(state.preferences.copyWith(newOffers: enabled));

  void setExpiringOffers(bool enabled) =>
      _apply(state.preferences.copyWith(expiringOffers: enabled));

  void setAppMessages(bool enabled) =>
      _apply(state.preferences.copyWith(appMessages: enabled));

  /// Optimistic: the switch moves immediately and rolls back on failure.
  void _apply(NotificationPreferences next) {
    final previous = state.preferences;
    if (next == previous) return;
    emit(state.copyWith(preferences: next, clearError: true));
    _pendingSave = _pendingSave.then((_) async {
      try {
        await _updatePreferences(next);
      } catch (error) {
        if (isClosed) return;
        // Only roll back if nothing newer replaced this value meanwhile.
        if (state.preferences == next) {
          emit(
            state.copyWith(
              preferences: previous,
              error: error is SettingsFailure
                  ? error.message
                  : 'No se pudo guardar el cambio',
            ),
          );
        }
      }
    });
  }
}
