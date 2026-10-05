part of 'appearance_cubit.dart';

class AppearanceState extends Equatable {
  const AppearanceState({this.preference = ThemePreference.system, this.error});

  final ThemePreference preference;
  final String? error;

  AppearanceState copyWith({
    ThemePreference? preference,
    String? error,
    bool clearError = false,
  }) {
    return AppearanceState(
      preference: preference ?? this.preference,
      error: clearError ? null : error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [preference, error];
}
