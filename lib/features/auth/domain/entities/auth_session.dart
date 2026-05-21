import 'package:equatable/equatable.dart';

import 'auth_user.dart';

/// A successfully-established Supabase auth session.
class AuthSession extends Equatable {
  const AuthSession({
    required this.user,
    required this.accessToken,
    this.refreshToken,
    this.expiresAt,
  });

  final AuthUser user;
  final String accessToken;
  final String? refreshToken;
  final DateTime? expiresAt;

  @override
  List<Object?> get props => [user, accessToken, refreshToken, expiresAt];
}
