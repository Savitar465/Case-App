import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../domain/entities/notification_preferences.dart';
import '../../../domain/entities/theme_preference.dart';
import '../../models/account_settings_model.dart';

class SettingsRemoteDataSource {
  SettingsRemoteDataSource(this._client);

  final SupabaseClient _client;

  static const String _usersTable = 'users';
  static const String _ticketsTable = 'support_tickets';

  /// Deep link the email-change confirmation returns to. Same URL as the
  /// Google OAuth callback (AuthRemoteDataSource.oauthRedirectUrl), so the
  /// AndroidManifest intent-filter and the Supabase allow-list cover it.
  static const String _emailRedirectUrl =
      'com.savi.market_app://login-callback/';

  User _requireUser() {
    final user = _client.auth.currentUser;
    if (user == null) {
      throw const SettingsRemoteException('Inicia sesión para continuar');
    }
    return user;
  }

  Future<AccountSettingsModel?> fetchSettings() async {
    final user = _client.auth.currentUser;
    if (user == null) return null;
    try {
      final row = await _client
          .from(_usersTable)
          .select()
          .eq('id', user.id)
          .maybeSingle();
      final hasPassword =
          user.identities?.any((identity) => identity.provider == 'email') ??
          true;
      return AccountSettingsModel.fromRemote(
        row ?? {'id': user.id},
        email: user.email ?? '',
        hasPassword: hasPassword,
      );
    } on PostgrestException catch (error) {
      throw SettingsRemoteException(error.message);
    }
  }

  Future<void> updateProfile({required String fullName, String? phone}) async {
    final user = _requireUser();
    try {
      await _client
          .from(_usersTable)
          .update({
            'full_name': fullName,
            'phone': phone,
            'updated_at': DateTime.now().toUtc().toIso8601String(),
          })
          .eq('id', user.id);
      // The profile header reads the display name from the auth metadata.
      await _client.auth.updateUser(
        UserAttributes(data: {'full_name': fullName}),
      );
    } on PostgrestException catch (error) {
      throw SettingsRemoteException(error.message);
    } on AuthException catch (error) {
      throw SettingsRemoteException(_describeAuthError(error));
    }
  }

  Future<void> requestEmailChange(String newEmail) async {
    _requireUser();
    try {
      await _client.auth.updateUser(
        UserAttributes(email: newEmail),
        emailRedirectTo: kIsWeb ? null : _emailRedirectUrl,
      );
    } on AuthException catch (error) {
      throw SettingsRemoteException(_describeAuthError(error));
    }
  }

  Stream<String> emailChanges() {
    return _client.auth.onAuthStateChange
        .where((state) => state.event == AuthChangeEvent.userUpdated)
        .map((state) => state.session?.user.email ?? '')
        .where((email) => email.isNotEmpty);
  }

  Future<void> changePassword({
    String? currentPassword,
    required String newPassword,
  }) async {
    final user = _requireUser();
    if (currentPassword != null) {
      // Supabase doesn't check the old password on update, so re-authenticate
      // first: an unlocked phone alone shouldn't be enough to change it.
      try {
        await _client.auth.signInWithPassword(
          email: user.email ?? '',
          password: currentPassword,
        );
      } on AuthException {
        throw const SettingsRemoteException(
          'La contraseña actual es incorrecta',
        );
      }
    }
    try {
      await _client.auth.updateUser(UserAttributes(password: newPassword));
    } on AuthException catch (error) {
      throw SettingsRemoteException(_describeAuthError(error));
    }
  }

  Future<void> updateTheme(ThemePreference theme) {
    return _updateOwnRow({
      'preferred_theme': AccountSettingsModel.themeToRemote(theme),
    });
  }

  Future<void> updateNotifications(NotificationPreferences preferences) {
    return _updateOwnRow(
      AccountSettingsModel.notificationsToRemoteMap(preferences),
    );
  }

  Future<void> submitSupportTicket({
    required String subject,
    required String message,
  }) async {
    final user = _requireUser();
    try {
      await _client.from(_ticketsTable).insert({
        'user_id': user.id,
        'subject': subject,
        'message': message,
        'created_by': user.id,
      });
    } on PostgrestException catch (error) {
      throw SettingsRemoteException(error.message);
    }
  }

  Future<void> _updateOwnRow(Map<String, dynamic> values) async {
    final user = _requireUser();
    try {
      await _client
          .from(_usersTable)
          .update({
            ...values,
            'updated_at': DateTime.now().toUtc().toIso8601String(),
          })
          .eq('id', user.id);
    } on PostgrestException catch (error) {
      throw SettingsRemoteException(error.message);
    }
  }

  String _describeAuthError(AuthException error) {
    return switch (error.code) {
      'email_exists' => 'Ese correo ya está registrado en otra cuenta',
      'email_address_invalid' => 'El correo electrónico no es válido',
      'same_password' => 'La nueva contraseña debe ser distinta a la actual',
      'weak_password' => 'La contraseña es demasiado débil',
      'over_email_send_rate_limit' =>
        'Has solicitado demasiados correos. Intenta de nuevo en unos minutos',
      _ => error.message,
    };
  }
}

class SettingsRemoteException implements Exception {
  const SettingsRemoteException(this.message);

  final String message;

  @override
  String toString() => message;
}
