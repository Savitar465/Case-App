import 'package:equatable/equatable.dart';

import 'notification_preferences.dart';
import 'theme_preference.dart';

/// The signed-in user's editable account data and preferences.
class AccountSettings extends Equatable {
  const AccountSettings({
    required this.userId,
    required this.email,
    required this.fullName,
    this.username,
    this.phone,
    this.avatarUrl,
    this.theme = ThemePreference.system,
    this.notifications = const NotificationPreferences(),
    this.hasPassword = true,
  });

  final String userId;
  final String email;
  final String fullName;

  /// Public handle shown as `@username` (stored without the `@`).
  final String? username;
  final String? phone;

  /// Public URL of the profile photo, or `null` to show the initial.
  final String? avatarUrl;
  final ThemePreference theme;
  final NotificationPreferences notifications;

  /// False for accounts created through Google that never set a password, so
  /// the "Cambiar contraseña" screen can skip the current-password check.
  final bool hasPassword;

  @override
  List<Object?> get props => [
    userId,
    email,
    fullName,
    username,
    phone,
    avatarUrl,
    theme,
    notifications,
    hasPassword,
  ];
}
