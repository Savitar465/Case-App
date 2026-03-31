part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthAuthenticated extends AuthState {
  const AuthAuthenticated({required this.session});

  final AuthSession session;

  bool get isOffline => session.fromCache;

  @override
  List<Object?> get props => [
    session.user.id,
    session.user.role,
    session.user.sellerId,
    session.accessToken,
    session.refreshToken,
    session.expiresAt,
    session.fromCache,
  ];
}

class AuthError extends AuthState {
  const AuthError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
