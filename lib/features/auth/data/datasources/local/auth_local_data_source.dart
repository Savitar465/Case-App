import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:market_app/core/security/credential_cipher.dart';
import 'package:market_app/features/auth/data/models/auth_session_model.dart';
import 'package:market_app/features/auth/data/models/stored_credentials_model.dart';

/// Persists the most-recent authenticated session into secure storage so the
/// app can restore it on next launch and fall back to a password check when
/// Supabase is unreachable.
///
/// Drift was retired in favor of remote-only persistence; this class keeps the
/// public API intact but stores a single encrypted JSON blob.
class AuthLocalDataSource {
  AuthLocalDataSource({
    required CredentialCipher credentialCipher,
    FlutterSecureStorage? secureStorage,
  })  : _cipher = credentialCipher,
        _secureStorage = secureStorage ?? const FlutterSecureStorage();

  static const _storageKey = 'auth_cached_credentials';

  final CredentialCipher _cipher;
  final FlutterSecureStorage _secureStorage;

  Future<void> cacheSession({
    required AuthSessionModel session,
    required String password,
  }) async {
    final hashedPassword = await _cipher.hashPassword(password);
    final encryptedAccess = await _cipher.encrypt(session.accessToken);
    final encryptedRefresh = session.refreshToken != null
        ? await _cipher.encrypt(session.refreshToken!)
        : null;

    final stored = StoredCredentialsModel(
      userId: session.user.id,
      email: session.user.email,
      displayName: session.user.displayName,
      hashedPassword: hashedPassword.hash,
      passwordSalt: hashedPassword.salt,
      encryptedAccessToken: encryptedAccess,
      encryptedRefreshToken: encryptedRefresh,
      expiresAt: session.expiresAt?.toUtc().millisecondsSinceEpoch,
      metadata: session.user.metadata,
      role: session.user.role,
      sellerId: session.user.sellerId,
      updatedAt: DateTime.now().toUtc(),
    );

    await _secureStorage.write(key: _storageKey, value: stored.encode());
  }

  Future<AuthSessionModel?> restoreSession() async {
    final stored = await _readStored();
    return stored?.toSession(_cipher);
  }

  Future<AuthSessionModel?> authenticateOffline({
    required String email,
    required String password,
  }) async {
    final stored = await _readStored();
    if (stored == null || stored.email != email) {
      return null;
    }
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
    return _secureStorage.delete(key: _storageKey);
  }

  Future<StoredCredentialsModel?> _readStored() async {
    final raw = await _secureStorage.read(key: _storageKey);
    return StoredCredentialsModel.decode(raw);
  }
}
