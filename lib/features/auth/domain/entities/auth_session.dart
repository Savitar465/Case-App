import 'package:equatable/equatable.dart';

import 'auth_user.dart';

/// A successfully-established auth session.
///
/// [fromCache] is true when the session was restored from local storage
/// (i.e. signed in offline). UI surfaces that flag to display the offline
/// banner.
class AuthSession extends Equatable {
  const AuthSession({
    required this.user,
    required this.accessToken,
    this.refreshToken,
    this.expiresAt,
    this.fromCache = false,
  });

  final AuthUser user;
  final String accessToken;
  final String? refreshToken;
  final DateTime? expiresAt;
  final bool fromCache;

  @override
  List<Object?> get props => [
        user,
        accessToken,
        refreshToken,
        expiresAt,
        fromCache,
      ];
}
