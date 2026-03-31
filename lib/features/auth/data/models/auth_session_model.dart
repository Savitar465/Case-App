import 'package:market_app/features/auth/data/models/auth_user_model.dart';
import 'package:market_app/features/auth/domain/entities/auth_session.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

class AuthSessionModel extends AuthSession {
  const AuthSessionModel({
    required AuthUserModel user,
    required super.accessToken,
    super.refreshToken,
    super.expiresAt,
    super.fromCache = false,
  }) : super(user: user);

  factory AuthSessionModel.fromSupabase(supabase.Session session) {
    final user = session.user;
    return AuthSessionModel(
      user: AuthUserModel.fromSupabase(user),
      accessToken: session.accessToken,
      refreshToken: session.refreshToken,
      expiresAt: _resolveExpiration(session),
      fromCache: false,
    );
  }

  AuthUserModel get userModel => user as AuthUserModel;

  AuthSessionModel copyWith({
    AuthUserModel? user,
    String? accessToken,
    String? refreshToken,
    DateTime? expiresAt,
    bool? fromCache,
  }) {
    return AuthSessionModel(
      user: user ?? userModel,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      expiresAt: expiresAt ?? this.expiresAt,
      fromCache: fromCache ?? this.fromCache,
    );
  }

  static DateTime? _resolveExpiration(supabase.Session session) {
    final seconds = session.expiresAt;
    if (seconds == null) {
      return null;
    }
    return DateTime.fromMillisecondsSinceEpoch(
      seconds * 1000,
      isUtc: true,
    ).toLocal();
  }
}

class AuthSessionParsingException implements Exception {
  const AuthSessionParsingException(this.message);
  final String message;
  @override
  String toString() => message;
}
