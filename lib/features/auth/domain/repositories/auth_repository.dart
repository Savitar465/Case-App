import '../entities/auth_session.dart';

abstract class AuthRepository {
  Future<AuthSession?> restoreSession();
  Future<AuthSession> login({required String email, required String password});
  Future<void> logout();
}
