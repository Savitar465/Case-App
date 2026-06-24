import '../entities/auth_session.dart';

abstract class AuthRepository {
  Future<AuthSession?> restoreSession();
  Future<AuthSession> login({required String email, required String password});

  /// Registers a new account. Returns the active session when sign-up logs the
  /// user straight in, or `null` when the project requires email confirmation
  /// before a session is issued.
  Future<AuthSession?> signUp({
    required String email,
    required String password,
  });

  Future<void> logout();
}
