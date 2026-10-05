part of 'change_password_cubit.dart';

class ChangePasswordState extends Equatable {
  const ChangePasswordState({
    this.isLoading = false,
    this.hasPassword = true,
    this.isSubmitting = false,
    this.success = false,
    this.error,
  });

  final bool isLoading;
  final bool hasPassword;
  final bool isSubmitting;
  final bool success;
  final String? error;

  ChangePasswordState copyWith({
    bool? isLoading,
    bool? hasPassword,
    bool? isSubmitting,
    bool? success,
    String? error,
    bool clearError = false,
  }) {
    return ChangePasswordState(
      isLoading: isLoading ?? this.isLoading,
      hasPassword: hasPassword ?? this.hasPassword,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      success: success ?? this.success,
      error: clearError ? null : error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    hasPassword,
    isSubmitting,
    success,
    error,
  ];
}
