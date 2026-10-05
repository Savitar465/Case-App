part of 'edit_profile_cubit.dart';

class EditProfileState extends Equatable {
  const EditProfileState({
    this.settings,
    this.isLoading = false,
    this.isSaving = false,
    this.saved = false,
    this.error,
  });

  final AccountSettings? settings;
  final bool isLoading;
  final bool isSaving;

  /// True right after a successful save (drives the snackbar + pop).
  final bool saved;
  final String? error;

  EditProfileState copyWith({
    AccountSettings? settings,
    bool? isLoading,
    bool? isSaving,
    bool? saved,
    String? error,
    bool clearError = false,
  }) {
    return EditProfileState(
      settings: settings ?? this.settings,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      saved: saved ?? this.saved,
      error: clearError ? null : error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [settings, isLoading, isSaving, saved, error];
}
