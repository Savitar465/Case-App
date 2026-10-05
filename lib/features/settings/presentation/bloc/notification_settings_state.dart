part of 'notification_settings_cubit.dart';

class NotificationSettingsState extends Equatable {
  const NotificationSettingsState({
    this.preferences = const NotificationPreferences(),
    this.isLoading = false,
    this.error,
  });

  final NotificationPreferences preferences;
  final bool isLoading;
  final String? error;

  NotificationSettingsState copyWith({
    NotificationPreferences? preferences,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return NotificationSettingsState(
      preferences: preferences ?? this.preferences,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [preferences, isLoading, error];
}
