import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:market_app/features/auth/domain/entities/auth_failure.dart';
import 'package:market_app/features/auth/domain/entities/auth_session.dart';
import 'package:market_app/features/auth/domain/usecases/login_use_case.dart';
import 'package:market_app/features/auth/domain/usecases/logout_use_case.dart';
import 'package:market_app/features/auth/domain/usecases/restore_session_use_case.dart';
import 'package:market_app/features/auth/domain/usecases/signup_use_case.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required LoginUseCase loginUseCase,
    required LogoutUseCase logoutUseCase,
    required RestoreSessionUseCase restoreSessionUseCase,
    required SignUpUseCase signUpUseCase,
  }) : _loginUseCase = loginUseCase,
       _logoutUseCase = logoutUseCase,
       _restoreSessionUseCase = restoreSessionUseCase,
       _signUpUseCase = signUpUseCase,
       super(const AuthInitial()) {
    on<AuthStarted>(_onAuthStarted);
    on<LoginSubmitted>(_onLoginSubmitted);
    on<SignupSubmitted>(_onSignupSubmitted);
    on<LogoutRequested>(_onLogoutRequested);
  }

  static const _genericLoginError = 'Unable to login. Please try again.';
  static const _genericSignupError =
      'No se pudo crear la cuenta. Inténtalo de nuevo.';

  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;
  final RestoreSessionUseCase _restoreSessionUseCase;
  final SignUpUseCase _signUpUseCase;

  Future<void> _onAuthStarted(
    AuthStarted event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final session = await _restoreSessionUseCase();
      emit(
        session != null
            ? AuthAuthenticated(session: session)
            : const AuthInitial(),
      );
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
      _emitTransientError(emit, error.message);
    } catch (_) {
      _emitTransientError(emit, _genericLoginError);
    }
  }

  Future<void> _onSignupSubmitted(
    SignupSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final session = await _signUpUseCase(
        email: event.email,
        password: event.password,
      );
      if (session != null) {
        emit(AuthAuthenticated(session: session));
      } else {
        // Email confirmation required: surface a message and return to the
        // unauthenticated state so the user can sign in once confirmed.
        emit(
          const AuthInfo(
            message:
                'Cuenta creada. Revisa tu correo para confirmar tu cuenta '
                'antes de iniciar sesión.',
          ),
        );
        emit(const AuthInitial());
      }
    } on AuthFailure catch (error) {
      _emitTransientError(emit, error.message);
    } catch (_) {
      _emitTransientError(emit, _genericSignupError);
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

  /// Surfaces an [AuthError] to listeners (snackbars, banners) and immediately
  /// resets to [AuthInitial] so the login form is re-enabled.
  void _emitTransientError(Emitter<AuthState> emit, String message) {
    emit(AuthError(message: message));
    emit(const AuthInitial());
  }
}
