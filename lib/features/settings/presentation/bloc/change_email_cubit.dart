import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/settings_failure.dart';
import '../../domain/usecases/request_email_change_use_case.dart';
import '../../domain/usecases/watch_email_changes_use_case.dart';

part 'change_email_state.dart';

/// Drives "Correo electrónico" → "Enlace de verificación enviado" →
/// "Correo actualizado". The last step fires when Supabase reports the user
/// updated with the requested address (the link was opened on this device).
class ChangeEmailCubit extends Cubit<ChangeEmailState> {
  ChangeEmailCubit({
    required String currentEmail,
    required RequestEmailChangeUseCase requestEmailChange,
    required WatchEmailChangesUseCase watchEmailChanges,
  }) : _requestEmailChange = requestEmailChange,
       super(ChangeEmailState(currentEmail: currentEmail)) {
    _subscription = watchEmailChanges().listen(_onEmailChanged);
  }

  final RequestEmailChangeUseCase _requestEmailChange;
  StreamSubscription<String>? _subscription;

  Future<void> submit(String newEmail) async {
    final email = newEmail.trim().toLowerCase();
    if (email == state.currentEmail.toLowerCase()) {
      // Clear first so repeating the same mistake shows the message again.
      emit(state.copyWith(clearError: true));
      emit(state.copyWith(error: 'Ese ya es tu correo actual'));
      return;
    }
    emit(state.copyWith(isSubmitting: true, clearError: true));
    try {
      await _requestEmailChange(email);
      emit(state.copyWith(isSubmitting: false, pendingEmail: email));
    } on SettingsFailure catch (failure) {
      emit(state.copyWith(isSubmitting: false, error: failure.message));
    } catch (_) {
      emit(
        state.copyWith(
          isSubmitting: false,
          error: 'No se pudo enviar el enlace de verificación',
        ),
      );
    }
  }

  void _onEmailChanged(String email) {
    final pending = state.pendingEmail;
    if (pending == null || email.toLowerCase() != pending) return;
    emit(state.copyWith(currentEmail: email, isUpdated: true));
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
