import 'dart:async';
import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

import 'package:market_app/features/auth/data/datasources/remote/auth_remote_data_source.dart';
import 'package:market_app/features/auth/domain/entities/auth_failure.dart';
import 'package:market_app/features/auth/domain/entities/auth_session.dart';
import 'package:market_app/features/auth/domain/repositories/auth_repository.dart';

/// Supabase-only auth repository. Sessions are persisted by `supabase_flutter`
/// itself, so the app never stores credentials on-device.
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({required AuthRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  final AuthRemoteDataSource _remoteDataSource;

  @override
  Future<AuthSession> login({
    required String email,
    required String password,
  }) async {
    try {
      return await _remoteDataSource.signInWithPassword(
        email: email,
        password: password,
      );
    } catch (error) {
      throw AuthFailure(_describeLoginError(error));
    }
  }

  @override
  Future<AuthSession?> restoreSession() async {
    try {
      return await _remoteDataSource.currentSession();
    } catch (_) {
      // A failure to read the current session should not block fresh login.
      return null;
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _remoteDataSource.signOut();
    } catch (_) {
      // Network failure during sign-out is non-fatal; the local Supabase
      // client has already cleared its in-memory session.
    }
  }

  String _describeLoginError(Object error) {
    if (error is supabase.AuthException) return error.message;
    if (error is AuthRemoteException) return error.message;
    if (error is SocketException) return 'No internet connection';
    if (error is TimeoutException) return 'Request timed out';
    return error.toString();
  }
}
