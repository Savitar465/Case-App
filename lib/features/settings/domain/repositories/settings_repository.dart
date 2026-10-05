import '../entities/account_settings.dart';
import '../entities/notification_preferences.dart';
import '../entities/theme_preference.dart';

abstract class SettingsRepository {
  /// Settings of the signed-in user, or `null` when browsing as a guest.
  Future<AccountSettings?> loadSettings();

  Future<AccountSettings> updateProfile({
    required String fullName,
    String? phone,
  });

  /// Sends the verification link to [newEmail]. The address only changes once
  /// the user opens that link; the result arrives through [watchEmailChanges].
  Future<void> requestEmailChange(String newEmail);

  /// Emits the user's email every time Supabase reports an updated user
  /// (e.g. after the email-change link lands back in the app).
  Stream<String> watchEmailChanges();

  /// Verifies [currentPassword] (when the account has one) and replaces it.
  Future<void> changePassword({
    String? currentPassword,
    required String newPassword,
  });

  Future<void> updateTheme(ThemePreference theme);

  Future<void> updateNotifications(NotificationPreferences preferences);

  Future<void> submitSupportTicket({
    required String subject,
    required String message,
  });
}
