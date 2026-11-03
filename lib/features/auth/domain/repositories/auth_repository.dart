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

  /// Emails a link to reset the password of [email].
  Future<void> sendPasswordResetEmail({required String email});

  /// Emits each time the user opens a password-reset link in the app. The
  /// user is signed in at that point so [updatePassword] can run.
  Stream<void> watchPasswordRecovery();

  /// Replaces the password of the user signed in through a reset link.
  Future<void> updatePassword({required String newPassword});
}
