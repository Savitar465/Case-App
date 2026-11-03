import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/auth_failure.dart';
import '../../domain/usecases/send_password_reset_email_use_case.dart';
import '../../domain/usecases/update_password_use_case.dart';

part 'password_reset_state.dart';

/// Drives "¿Olvidaste tu contraseña?" (send the link) and "Nueva contraseña"
/// (save the password once the link is opened).
class PasswordResetCubit extends Cubit<PasswordResetState> {
  PasswordResetCubit({
    required SendPasswordResetEmailUseCase sendPasswordResetEmail,
    required UpdatePasswordUseCase updatePassword,
  }) : _sendPasswordResetEmail = sendPasswordResetEmail,
       _updatePassword = updatePassword,
       super(const PasswordResetState());

  final SendPasswordResetEmailUseCase _sendPasswordResetEmail;
  final UpdatePasswordUseCase _updatePassword;

  Future<void> sendResetEmail(String email) async {
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      await _sendPasswordResetEmail(email: email);
      emit(state.copyWith(isLoading: false, sentToEmail: email));
    } on AuthFailure catch (failure) {
      emit(state.copyWith(isLoading: false, error: failure.message));
    } catch (_) {
      emit(
        state.copyWith(
          isLoading: false,
          error: 'No se pudo enviar el correo. Inténtalo de nuevo.',
        ),
      );
    }
  }

  Future<void> updatePassword(String newPassword) async {
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      await _updatePassword(newPassword: newPassword);
      emit(state.copyWith(isLoading: false, passwordUpdated: true));
    } on AuthFailure catch (failure) {
      emit(state.copyWith(isLoading: false, error: failure.message));
    } catch (_) {
      emit(
        state.copyWith(
          isLoading: false,
          error: 'No se pudo actualizar la contraseña. Inténtalo de nuevo.',
        ),
      );
    }
  }
}
