import 'dart:async';
import 'dart:io';

import 'package:market_app/features/auth/domain/entities/auth_failure.dart';
import 'package:market_app/features/auth/domain/entities/auth_session.dart';
import 'package:market_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:market_app/features/auth/data/datasources/local/auth_local_data_source.dart';
import 'package:market_app/features/auth/data/datasources/remote/auth_remote_data_source.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AuthLocalDataSource localDataSource,
  }) : _remoteDataSource = remoteDataSource,
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
    } on supabase.AuthException catch (error) {
      return _handleOfflineFallback(
        email: email,
        password: password,
        reason: error.message,
      );
    } on SocketException {
      return _handleOfflineFallback(
        email: email,
        password: password,
        reason: 'No internet connection',
      );
    } on TimeoutException {
      return _handleOfflineFallback(
        email: email,
        password: password,
        reason: 'Request timed out',
      );
    } on AuthRemoteException catch (error) {
      return _handleOfflineFallback(
        email: email,
        password: password,
        reason: error.message,
      );
    } catch (error) {
      return _handleOfflineFallback(
        email: email,
        password: password,
        reason: error.toString(),
      );
    }
  }

  @override
  Future<AuthSession?> restoreSession() {
    return _localDataSource.restoreSession();
  }

  @override
  Future<void> logout() async {
    try {
      await _remoteDataSource.signOut();
    } catch (_) {
      // Even if remote sign-out fails (e.g. offline), still clear local session.
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
}
