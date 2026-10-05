import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/account_settings.dart';
import '../../domain/entities/settings_failure.dart';
import '../../domain/usecases/load_account_settings_use_case.dart';
import '../../domain/usecases/update_profile_use_case.dart';

part 'edit_profile_state.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  EditProfileCubit({
    required LoadAccountSettingsUseCase loadSettings,
    required UpdateProfileUseCase updateProfile,
  }) : _loadSettings = loadSettings,
       _updateProfile = updateProfile,
       super(const EditProfileState());

  final LoadAccountSettingsUseCase _loadSettings;
  final UpdateProfileUseCase _updateProfile;

  Future<void> load() async {
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      final settings = await _loadSettings();
      if (settings == null) {
        emit(
          state.copyWith(
            isLoading: false,
            error: 'Inicia sesión para editar tu perfil',
          ),
        );
        return;
      }
      emit(state.copyWith(isLoading: false, settings: settings));
    } on SettingsFailure catch (failure) {
      emit(state.copyWith(isLoading: false, error: failure.message));
    } catch (_) {
      emit(
        state.copyWith(
          isLoading: false,
          error: 'No se pudo cargar tu información',
        ),
      );
    }
  }

  Future<void> save({required String fullName, String? phone}) async {
    emit(state.copyWith(isSaving: true, saved: false, clearError: true));
    try {
      final settings = await _updateProfile(fullName: fullName, phone: phone);
      emit(state.copyWith(isSaving: false, saved: true, settings: settings));
    } on SettingsFailure catch (failure) {
      emit(state.copyWith(isSaving: false, error: failure.message));
    } catch (_) {
      emit(
        state.copyWith(
          isSaving: false,
          error: 'No se pudieron guardar los cambios',
        ),
      );
    }
  }

  /// Re-reads the account after the email screen returns, so the E-mail row
  /// shows the confirmed address.
  Future<void> refreshEmail() async {
    try {
      final settings = await _loadSettings();
      if (settings != null) emit(state.copyWith(settings: settings));
    } catch (_) {
      // Non-critical: the row keeps showing the previous address.
    }
  }
}
