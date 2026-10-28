import 'dart:developer' as developer;
import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../domain/entities/notification_preferences.dart';
import '../../../domain/entities/theme_preference.dart';
import '../../models/account_settings_model.dart';

class SettingsRemoteDataSource {
  SettingsRemoteDataSource(this._client);

  final SupabaseClient _client;

  static const String _usersTable = 'users';
  static const String _ticketsTable = 'support_tickets';
  static const String _imagesBucket = 'vikus';
  static const Uuid _uuid = Uuid();

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
        avatarUrl: _resolveImageUrl(row?['avatar_url'] as String?),
      );
    } on PostgrestException catch (error) {
      throw SettingsRemoteException(error.message);
    }
  }

  Future<void> updateProfile({
    required String fullName,
    required String username,
    String? phone,
    String? avatarFilePath,
  }) async {
    final user = _requireUser();
    String? previousAvatar;
    String? newAvatar;
    try {
      if (avatarFilePath != null) {
        final row = await _client
            .from(_usersTable)
            .select('avatar_url')
            .eq('id', user.id)
            .maybeSingle();
        previousAvatar = row?['avatar_url'] as String?;
        newAvatar = await _uploadAvatar(user.id, avatarFilePath);
      }
      await _client
          .from(_usersTable)
          .update({
            'full_name': fullName,
            'username': username,
            'phone': phone,
            if (newAvatar != null) 'avatar_url': newAvatar,
            'updated_at': DateTime.now().toUtc().toIso8601String(),
          })
          .eq('id', user.id);
      // The profile header reads the display name from the auth metadata.
      await _client.auth.updateUser(
        UserAttributes(data: {'full_name': fullName}),
      );
    } on PostgrestException catch (error) {
      if (newAvatar != null) await _removeAvatar(newAvatar);
      throw SettingsRemoteException(_describeProfileError(error));
    } on StorageException catch (error) {
      throw SettingsRemoteException(
        'No se pudo subir la foto: ${error.message}',
      );
    } on AuthException catch (error) {
      throw SettingsRemoteException(_describeAuthError(error));
    }
    if (newAvatar != null && previousAvatar != null) {
      await _removeAvatar(previousAvatar);
    }
  }

  /// Uploads to `avatars/<user id>/<uuid>.<ext>` (the folder the storage
  /// policies let the owner manage) and returns the storage path.
  Future<String> _uploadAvatar(String userId, String filePath) async {
    final extension = _extensionOf(filePath);
    final objectPath = 'avatars/$userId/${_uuid.v4()}.$extension';
    await _client.storage
        .from(_imagesBucket)
        .upload(
          objectPath,
          File(filePath),
          fileOptions: FileOptions(contentType: _contentType(extension)),
        );
    return objectPath;
  }

  Future<void> _removeAvatar(String objectPath) async {
    // Only our own uploads; older rows may hold external URLs.
    if (!objectPath.startsWith('avatars/')) return;
    try {
      await _client.storage.from(_imagesBucket).remove([objectPath]);
    } on StorageException catch (error) {
      // Cleanup only: an orphaned file must not fail the profile save.
      developer.log(
        'Settings: could not remove avatar $objectPath',
        name: 'settings.data',
        error: error,
      );
    }
  }

  String? _resolveImageUrl(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    if (raw.startsWith('http://') || raw.startsWith('https://')) return raw;
    return _client.storage.from(_imagesBucket).getPublicUrl(raw);
  }

  String _extensionOf(String path) {
    final dot = path.lastIndexOf('.');
    if (dot == -1 || dot == path.length - 1) return 'jpg';
    final extension = path.substring(dot + 1).toLowerCase();
    return extension.length > 4 ? 'jpg' : extension;
  }

  String _contentType(String extension) => switch (extension) {
    'png' => 'image/png',
    'webp' => 'image/webp',
    'heic' => 'image/heic',
    'gif' => 'image/gif',
    _ => 'image/jpeg',
  };

  /// `users_username_lower_key` / `users_username_format` from the
  /// 20261028 migration.
  String _describeProfileError(PostgrestException error) {
    return switch (error.code) {
      '23505' => 'Ese nombre de usuario ya está en uso',
      '23514' => 'El nombre de usuario no es válido',
      _ => error.message,
    };
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
