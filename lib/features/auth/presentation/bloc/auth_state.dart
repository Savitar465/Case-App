part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => const [];
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

  @override
  List<Object?> get props => [session];
}

class AuthError extends AuthState {
  const AuthError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}

/// Transient informational state (e.g. "account created, confirm your email").
/// Treated like [AuthInitial] for routing purposes.
class AuthInfo extends AuthState {
  const AuthInfo({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
