import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';

import '../../domain/entities/account_settings.dart';
import '../../domain/entities/notification_preferences.dart';
import '../../domain/entities/settings_failure.dart';
import '../../domain/entities/theme_preference.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/remote/settings_remote_data_source.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl({required SettingsRemoteDataSource remoteDataSource})
    : _remote = remoteDataSource;

  final SettingsRemoteDataSource _remote;

  @override
  Future<AccountSettings?> loadSettings() =>
      _guard('load settings', _remote.fetchSettings);

  @override
  Future<AccountSettings> updateProfile({
    required String fullName,
    String? phone,
  }) {
    return _guard('update profile', () async {
      await _remote.updateProfile(fullName: fullName, phone: phone);
      final settings = await _remote.fetchSettings();
      if (settings == null) {
        throw const SettingsFailure('Inicia sesión para continuar');
      }
      return settings;
    });
  }

  @override
  Future<void> requestEmailChange(String newEmail) {
    return _guard(
      'request email change',
      () => _remote.requestEmailChange(newEmail),
    );
  }

  @override
  Stream<String> watchEmailChanges() => _remote.emailChanges();

  @override
  Future<void> changePassword({
    String? currentPassword,
    required String newPassword,
  }) {
    return _guard(
      'change password',
      () => _remote.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      ),
    );
  }

  @override
  Future<void> updateTheme(ThemePreference theme) =>
      _guard('update theme', () => _remote.updateTheme(theme));

  @override
  Future<void> updateNotifications(NotificationPreferences preferences) {
    return _guard(
      'update notifications',
      () => _remote.updateNotifications(preferences),
    );
  }

  @override
  Future<void> submitSupportTicket({
    required String subject,
    required String message,
  }) {
    return _guard(
      'submit support ticket',
      () => _remote.submitSupportTicket(subject: subject, message: message),
    );
  }

  Future<T> _guard<T>(String action, Future<T> Function() body) async {
    try {
      return await body();
    } catch (error) {
      developer.log(
        'Settings: $action failed',
        name: 'settings.data',
        error: error,
      );
      throw _mapInfraError(error);
    }
  }

  SettingsFailure _mapInfraError(Object error) {
    if (error is SettingsFailure) return error;
    if (error is SettingsRemoteException) {
      return SettingsFailure(error.message);
    }
    if (error is SocketException) {
      return const SettingsFailure('No hay conexión a internet');
    }
    if (error is TimeoutException) {
      return const SettingsFailure('La solicitud ha tardado demasiado');
    }
    return SettingsFailure(error.toString());
  }
}
