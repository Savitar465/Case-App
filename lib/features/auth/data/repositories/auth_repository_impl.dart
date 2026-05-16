import 'dart:async';
import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

import 'package:market_app/features/auth/data/datasources/local/auth_local_data_source.dart';
import 'package:market_app/features/auth/data/datasources/remote/auth_remote_data_source.dart';
import 'package:market_app/features/auth/domain/entities/auth_failure.dart';
import 'package:market_app/features/auth/domain/entities/auth_session.dart';
import 'package:market_app/features/auth/domain/repositories/auth_repository.dart';

/// Online-first auth repository with an offline fallback.
///
/// On `login`, we always try Supabase first. Any infrastructure error
/// (network, timeout, Supabase 5xx, malformed response) falls back to a
/// password check against the locally-cached, encrypted credentials.
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AuthLocalDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  @override
  Future<AuthSession> login({
    required String email,
    required String password,
  }) async {
    try {
      final session = await _remoteDataSource.signInWithPassword(
        email: email,
        password: password,
      );
      await _localDataSource.cacheSession(session: session, password: password);
      return session;
    } catch (error) {
      return _handleOfflineFallback(
        email: email,
        password: password,
        reason: _describeLoginError(error),
      );
    }
  }

  @override
  Future<AuthSession?> restoreSession() => _localDataSource.restoreSession();

  @override
  Future<void> logout() async {
    try {
      await _remoteDataSource.signOut();
    } catch (_) {
      // Network failure during sign-out is non-fatal; the local cache is the
      // source of truth for the next start-up and we clear it below.
    }
    await _localDataSource.clear();
  }

  Future<AuthSession> _handleOfflineFallback({
    required String email,
    required String password,
    required String reason,
  }) async {
    final cached = await _localDataSource.authenticateOffline(
      email: email,
      password: password,
    );
    if (cached != null) {
      return cached;
    }
    throw AuthFailure(reason);
  }

  String _describeLoginError(Object error) {
    if (error is supabase.AuthException) return error.message;
    if (error is AuthRemoteException) return error.message;
    if (error is SocketException) return 'No internet connection';
    if (error is TimeoutException) return 'Request timed out';
    return error.toString();
  }
}
