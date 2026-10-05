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

  /// Opens Google's consent screen in the browser. Completes once the browser
  /// is launched; the resulting session arrives through [watchSignIns].
  Future<void> signInWithGoogle();

  /// Emits a session every time Supabase signs a user in (e.g. after the
  /// Google OAuth redirect lands back in the app).
  Stream<AuthSession> watchSignIns();
}
