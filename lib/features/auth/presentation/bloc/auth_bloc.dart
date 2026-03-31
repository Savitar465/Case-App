import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:market_app/features/auth/domain/entities/auth_failure.dart';
import 'package:market_app/features/auth/domain/entities/auth_session.dart';
import 'package:market_app/features/auth/domain/usecases/login_use_case.dart';
import 'package:market_app/features/auth/domain/usecases/logout_use_case.dart';
import 'package:market_app/features/auth/domain/usecases/restore_session_use_case.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required LoginUseCase loginUseCase,
    required LogoutUseCase logoutUseCase,
    required RestoreSessionUseCase restoreSessionUseCase,
  }) : _loginUseCase = loginUseCase,
       _logoutUseCase = logoutUseCase,
       _restoreSessionUseCase = restoreSessionUseCase,
       super(const AuthInitial()) {
    on<AuthStarted>(_onAuthStarted);
    on<LoginSubmitted>(_onLoginSubmitted);
    on<LogoutRequested>(_onLogoutRequested);
  }

  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;
  final RestoreSessionUseCase _restoreSessionUseCase;

  Future<void> _onAuthStarted(
    AuthStarted event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final session = await _restoreSessionUseCase();
      if (session != null) {
        emit(AuthAuthenticated(session: session));
      } else {
        emit(const AuthInitial());
      }
    } catch (_) {
      emit(const AuthInitial());
    }
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final session = await _loginUseCase(
        email: event.email,
        password: event.password,
      );
      emit(AuthAuthenticated(session: session));
    } on AuthFailure catch (error) {
      emit(AuthError(message: error.message));
      emit(const AuthInitial());
    } catch (_) {
      emit(const AuthError(message: 'Unable to login. Please try again.'));
      emit(const AuthInitial());
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    await _logoutUseCase();
    emit(const AuthInitial());
  }
}
