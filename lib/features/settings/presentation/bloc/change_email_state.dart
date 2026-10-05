part of 'change_email_cubit.dart';

class ChangeEmailState extends Equatable {
  const ChangeEmailState({
    required this.currentEmail,
    this.pendingEmail,
    this.isSubmitting = false,
    this.isUpdated = false,
    this.error,
  });

  final String currentEmail;

  /// Address the verification link was sent to; non-null once sent.
  final String? pendingEmail;
  final bool isSubmitting;

  /// True once Supabase confirmed the new address.
  final bool isUpdated;
  final String? error;

  bool get linkSent => pendingEmail != null;

  ChangeEmailState copyWith({
    String? currentEmail,
    String? pendingEmail,
    bool? isSubmitting,
    bool? isUpdated,
    String? error,
    bool clearError = false,
  }) {
    return ChangeEmailState(
      currentEmail: currentEmail ?? this.currentEmail,
      pendingEmail: pendingEmail ?? this.pendingEmail,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isUpdated: isUpdated ?? this.isUpdated,
      error: clearError ? null : error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
    currentEmail,
    pendingEmail,
    isSubmitting,
    isUpdated,
    error,
  ];
}
