import 'package:market_app/features/auth/data/models/auth_session_model.dart';
import 'package:market_app/features/auth/domain/entities/auth_user.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRemoteDataSource {
  AuthRemoteDataSource(this._client);

  final SupabaseClient _client;

  Future<AuthSessionModel> signInWithPassword({
    required String email,
    required String password,
  }) async {
    final response = await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
    final session = response.session;
    final supabaseUser = response.user;

    if (session == null || supabaseUser == null) {
      throw const AuthRemoteException(
        'Unable to retrieve session from Supabase response',
      );
    }

    final sessionModel = AuthSessionModel.fromSupabase(session);
    return _enrichSessionWithRoles(
      session: sessionModel,
      userId: supabaseUser.id,
    );
  }

  Future<AuthSessionModel?> currentSession() async {
    final session = _client.auth.currentSession;
    if (session == null) {
      return null;
    }
    final sessionModel = AuthSessionModel.fromSupabase(session);
    final userId = session.user.id;
    if (userId.isEmpty) {
      return sessionModel;
    }
    return _enrichSessionWithRoles(session: sessionModel, userId: userId);
  }

  Future<void> signOut() {
    return _client.auth.signOut();
  }

  Future<AuthSessionModel> _enrichSessionWithRoles({
    required AuthSessionModel session,
    required String userId,
  }) async {
    final remoteRole = await _resolveUserRole(userId);
    if (remoteRole == null || remoteRole == session.user.role) {
      return session;
    }

    final updatedUser = session.userModel.copyWith(role: remoteRole);
    return session.copyWith(user: updatedUser);
  }

  Future<UserRole?> _resolveUserRole(String userId) async {
    try {
      final dynamic response = await _client
          .schema('market')
          .from('user_roles')
          .select('*, roles(*)')
          .eq('user_id', userId);

      print(response);
      if (response is! List) {
        return null;
      }

      final rawRoles = response.cast<Map<String, dynamic>>();
      final parsedRoles = <UserRole>[];
      for (final entry in rawRoles) {
        final roleName = _extractRoleName(entry);
        if (roleName == null) {
          continue;
        }
        final parsedRole = userRoleFromString(roleName);
        if (parsedRole != UserRole.unknown) {
          parsedRoles.add(parsedRole);
        }
      }

      if (parsedRoles.isEmpty) {
        return null;
      }

      if (parsedRoles.contains(UserRole.admin)) {
        return UserRole.admin;
      }
      if (parsedRoles.contains(UserRole.seller)) {
        return UserRole.seller;
      }
      if (parsedRoles.contains(UserRole.customer)) {
        return UserRole.customer;
      }
      return parsedRoles.first;
    } catch (_) {
      return null;
    }
  }

  String? _extractRoleName(Map<String, dynamic> data) {
    final directRole = _normalizeRoleValue(
      data['role'] ??
          data['role_name'] ??
          data['roleName'] ??
          data['role_code'] ??
          data['roleCode'],
    );
    if (directRole != null) {
      return directRole;
    }

    final nested = data['roles'];
    if (nested is Map<String, dynamic>) {
      for (final key in [
        'name',
        'role',
        'role_name',
        'roleName',
        'code',
        'slug',
        'label',
      ]) {
        final value = _normalizeRoleValue(nested[key]);
        if (value != null) {
          return value;
        }
      }
    } else if (nested is List) {
      for (final item in nested) {
        if (item is Map<String, dynamic>) {
          final value = _extractRoleName(item);
          if (value != null) {
            return value;
          }
        } else {
          final value = _normalizeRoleValue(item);
          if (value != null) {
            return value;
          }
        }
      }
    }

    return null;
  }

  String? _normalizeRoleValue(dynamic value) {
    if (value == null) {
      return null;
    }
    final stringValue = value.toString().trim();
    if (stringValue.isEmpty) {
      return null;
    }
    return stringValue;
  }
}

class AuthRemoteException implements Exception {
  const AuthRemoteException(this.message);
  final String message;
  @override
  String toString() => message;
}
