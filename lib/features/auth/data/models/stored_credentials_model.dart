import 'dart:convert';

import 'package:market_app/core/security/credential_cipher.dart';
import 'package:market_app/features/auth/data/models/auth_session_model.dart';
import 'package:market_app/features/auth/data/models/auth_user_model.dart';
import 'package:market_app/features/auth/domain/entities/auth_user.dart';

/// Plain-Dart representation of the cached credentials kept in secure storage.
class StoredCredentialsModel {
  const StoredCredentialsModel({
    required this.userId,
    required this.email,
    required this.hashedPassword,
    required this.passwordSalt,
    required this.encryptedAccessToken,
    required this.updatedAt,
    this.displayName,
    this.encryptedRefreshToken,
    this.expiresAt,
    this.metadata,
    this.role = UserRole.customer,
    this.sellerId,
  });

  final String userId;
  final String email;
  final String? displayName;
  final String hashedPassword;
  final String passwordSalt;
  final String encryptedAccessToken;
  final String? encryptedRefreshToken;
  final int? expiresAt;
  final Map<String, dynamic>? metadata;
  final DateTime updatedAt;
  final UserRole role;
  final String? sellerId;

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'email': email,
        'display_name': displayName,
        'hashed_password': hashedPassword,
        'password_salt': passwordSalt,
        'encrypted_access_token': encryptedAccessToken,
        'encrypted_refresh_token': encryptedRefreshToken,
        'expires_at': expiresAt,
        'metadata': metadata,
        'role': role.label,
        'seller_id': sellerId,
        'updated_at': updatedAt.toUtc().toIso8601String(),
      };

  factory StoredCredentialsModel.fromJson(Map<String, dynamic> map) {
    return StoredCredentialsModel(
      userId: map['user_id'] as String,
      email: map['email'] as String,
      displayName: map['display_name'] as String?,
      hashedPassword: map['hashed_password'] as String,
      passwordSalt: map['password_salt'] as String,
      encryptedAccessToken: map['encrypted_access_token'] as String,
      encryptedRefreshToken: map['encrypted_refresh_token'] as String?,
      expiresAt: (map['expires_at'] as num?)?.toInt(),
      metadata: (map['metadata'] as Map?)?.cast<String, dynamic>(),
      role: userRoleFromString(map['role'] as String?),
      sellerId: map['seller_id'] as String?,
      updatedAt:
          DateTime.tryParse(map['updated_at'] as String? ?? '') ??
              DateTime.now().toUtc(),
    );
  }

  String encode() => jsonEncode(toJson());

  static StoredCredentialsModel? decode(String? raw) {
    if (raw == null || raw.isEmpty) {
      return null;
    }
    try {
      final map = jsonDecode(raw);
      if (map is Map<String, dynamic>) {
        return StoredCredentialsModel.fromJson(map);
      }
    } catch (_) {
      // Corrupted payload — treat as no cached session.
    }
    return null;
  }

  Future<AuthSessionModel> toSession(CredentialCipher cipher) async {
    final accessToken = await cipher.decrypt(encryptedAccessToken);
    final refreshToken = encryptedRefreshToken != null
        ? await cipher.decrypt(encryptedRefreshToken!)
        : null;
    final user = AuthUserModel(
      id: userId,
      email: email,
      displayName: displayName,
      metadata: metadata,
      role: role,
      sellerId: sellerId,
    );
    return AuthSessionModel(
      fromCache: true,
      user: user,
      accessToken: accessToken,
      refreshToken: refreshToken,
      expiresAt: expiresAt != null
          ? DateTime.fromMillisecondsSinceEpoch(
              expiresAt!,
              isUtc: true,
            ).toLocal()
          : null,
    );
  }
}
