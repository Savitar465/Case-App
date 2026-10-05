part of 'contact_support_cubit.dart';

class ContactSupportState extends Equatable {
  const ContactSupportState({
    this.isSubmitting = false,
    this.sent = false,
    this.error,
  });

  final bool isSubmitting;
  final bool sent;
  final String? error;

  ContactSupportState copyWith({
    bool? isSubmitting,
    bool? sent,
    String? error,
    bool clearError = false,
  }) {
    return ContactSupportState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      sent: sent ?? this.sent,
      error: clearError ? null : error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [isSubmitting, sent, error];
}
