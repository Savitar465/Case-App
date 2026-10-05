import 'package:equatable/equatable.dart';

import 'notification_preferences.dart';
import 'theme_preference.dart';

/// The signed-in user's editable account data and preferences.
class AccountSettings extends Equatable {
  const AccountSettings({
    required this.userId,
    required this.email,
    required this.fullName,
    this.phone,
    this.theme = ThemePreference.system,
    this.notifications = const NotificationPreferences(),
    this.hasPassword = true,
  });

  final String userId;
  final String email;
  final String fullName;
  final String? phone;
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
    phone,
    theme,
    notifications,
    hasPassword,
  ];
}
