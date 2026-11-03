part of 'password_reset_cubit.dart';

class PasswordResetState extends Equatable {
  const PasswordResetState({
    this.isLoading = false,
    this.error,
    this.sentToEmail,
    this.passwordUpdated = false,
  });

  final bool isLoading;
  final String? error;

  /// Address the reset link was last sent to; `null` until sent.
  final String? sentToEmail;
  final bool passwordUpdated;

  PasswordResetState copyWith({
    bool? isLoading,
    String? error,
    bool clearError = false,
    String? sentToEmail,
    bool? passwordUpdated,
  }) {
    return PasswordResetState(
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : error ?? this.error,
      sentToEmail: sentToEmail ?? this.sentToEmail,
      passwordUpdated: passwordUpdated ?? this.passwordUpdated,
    );
  }

  @override
  List<Object?> get props => [isLoading, error, sentToEmail, passwordUpdated];
}
