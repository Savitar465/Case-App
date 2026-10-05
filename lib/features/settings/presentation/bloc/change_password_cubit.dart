import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/settings_failure.dart';
import '../../domain/usecases/change_password_use_case.dart';
import '../../domain/usecases/load_account_settings_use_case.dart';

part 'change_password_state.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  ChangePasswordCubit({
    required LoadAccountSettingsUseCase loadSettings,
    required ChangePasswordUseCase changePassword,
  }) : _loadSettings = loadSettings,
       _changePassword = changePassword,
       super(const ChangePasswordState());

  final LoadAccountSettingsUseCase _loadSettings;
  final ChangePasswordUseCase _changePassword;

  /// Finds out whether the account already has a password (Google-only
  /// accounts don't, so there is nothing to verify).
  Future<void> load() async {
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      final settings = await _loadSettings();
      emit(
        state.copyWith(
          isLoading: false,
          hasPassword: settings?.hasPassword ?? true,
        ),
      );
    } catch (_) {
      // Assume a password exists: asking for it is the safe default.
      emit(state.copyWith(isLoading: false, hasPassword: true));
    }
  }

  Future<void> submit({
    String? currentPassword,
    required String newPassword,
  }) async {
    emit(state.copyWith(isSubmitting: true, clearError: true));
    try {
      await _changePassword(
        currentPassword: state.hasPassword ? currentPassword : null,
        newPassword: newPassword,
      );
      emit(state.copyWith(isSubmitting: false, success: true));
    } on SettingsFailure catch (failure) {
      emit(state.copyWith(isSubmitting: false, error: failure.message));
    } catch (_) {
      emit(
        state.copyWith(
          isSubmitting: false,
          error: 'No se pudo actualizar la contraseña',
        ),
      );
    }
  }
}
