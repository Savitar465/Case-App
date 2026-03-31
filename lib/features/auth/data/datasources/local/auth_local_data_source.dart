import 'dart:convert';

import 'package:drift/drift.dart';

import 'package:market_app/core/database/app_database.dart';
import 'package:market_app/core/security/credential_cipher.dart';
import 'package:market_app/features/auth/data/models/auth_session_model.dart';
import 'package:market_app/features/auth/data/models/stored_credentials_model.dart';
import 'package:market_app/features/auth/domain/entities/auth_user.dart';

class AuthLocalDataSource {
  AuthLocalDataSource({
    required AppDatabase database,
    required CredentialCipher credentialCipher,
  }) : _database = database,
       _cipher = credentialCipher;

  final AppDatabase _database;
  final CredentialCipher _cipher;

  Future<void> cacheSession({
    required AuthSessionModel session,
    required String password,
  }) async {
    final hashedPassword = await _cipher.hashPassword(password);
    final encryptedAccess = await _cipher.encrypt(session.accessToken);
    final encryptedRefresh = session.refreshToken != null
        ? await _cipher.encrypt(session.refreshToken!)
        : null;

    final companion = AuthCredentialsTableCompanion(
      userId: Value(session.user.id),
      email: Value(session.user.email),
      displayName: Value(session.user.displayName),
      hashedPassword: Value(hashedPassword.hash),
      passwordSalt: Value(hashedPassword.salt),
      encryptedAccessToken: Value(encryptedAccess),
      encryptedRefreshToken: Value(encryptedRefresh),
      expiresAt: Value(session.expiresAt?.toUtc().millisecondsSinceEpoch),
      jsonUserMetadata: Value(
        session.user.metadata != null
            ? jsonEncode(session.user.metadata)
            : null,
      ),
      role: Value(session.user.role.label),
      sellerId: Value(session.user.sellerId),
      updatedAt: Value(DateTime.now().toUtc()),
    );

    await _database.saveCredentials(companion);
  }

  Future<AuthSessionModel?> restoreSession() async {
    final data = await _database.fetchCachedCredentials();
    if (data == null) {
      return null;
    }
    final stored = StoredCredentialsModel.fromTable(data);
    return stored.toSession(_cipher);
  }

  Future<AuthSessionModel?> authenticateOffline({
    required String email,
    required String password,
  }) async {
    final data = await _database.fetchCredentialsByEmail(email);
    if (data == null) {
      return null;
    }
    final stored = StoredCredentialsModel.fromTable(data);
    final matches = await _cipher.verifyPassword(
      password: password,
      expectedHash: stored.hashedPassword,
      salt: stored.passwordSalt,
    );
    if (!matches) {
      return null;
    }
    return stored.toSession(_cipher);
  }

  Future<void> clear() {
    return _database.clearCredentials();
  }
}
