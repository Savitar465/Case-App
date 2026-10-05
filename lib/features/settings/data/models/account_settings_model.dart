import '../../domain/entities/account_settings.dart';
import '../../domain/entities/notification_preferences.dart';
import '../../domain/entities/theme_preference.dart';

class AccountSettingsModel extends AccountSettings {
  const AccountSettingsModel({
    required super.userId,
    required super.email,
    required super.fullName,
    super.phone,
    super.theme,
    super.notifications,
    super.hasPassword,
  });

  /// Builds the settings from a `public.users` row. The email comes from the
  /// auth user because it is the address Supabase actually signs in with.
  factory AccountSettingsModel.fromRemote(
    Map<String, dynamic> json, {
    required String email,
    required bool hasPassword,
  }) {
    final phone = (json['phone'] as String?)?.trim();
    return AccountSettingsModel(
      userId: json['id'] as String,
      email: email,
      fullName: (json['full_name'] as String?)?.trim() ?? '',
      phone: (phone == null || phone.isEmpty) ? null : phone,
      theme: themeFromRemote(json['preferred_theme'] as String?),
      notifications: NotificationPreferences(
        newOffers: json['notify_new_offers'] as bool? ?? true,
        expiringOffers: json['notify_expiring_offers'] as bool? ?? true,
        appMessages: json['notify_app_messages'] as bool? ?? true,
      ),
      hasPassword: hasPassword,
    );
  }

  static ThemePreference themeFromRemote(String? value) {
    return switch (value) {
      'light' => ThemePreference.light,
      'dark' => ThemePreference.dark,
      _ => ThemePreference.system,
    };
  }

  static String themeToRemote(ThemePreference theme) => theme.name;

  static Map<String, dynamic> notificationsToRemoteMap(
    NotificationPreferences preferences,
  ) {
    return {
      'notify_new_offers': preferences.newOffers,
      'notify_expiring_offers': preferences.expiringOffers,
      'notify_app_messages': preferences.appMessages,
    };
  }
}
