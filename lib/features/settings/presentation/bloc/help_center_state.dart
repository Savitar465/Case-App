part of 'help_center_cubit.dart';

class HelpCenterState extends Equatable {
  const HelpCenterState({
    this.isLoading = false,
    this.tickets = const [],
    this.error,
  });

  final bool isLoading;
  final List<SupportTicket> tickets;
  final String? error;

  HelpCenterState copyWith({
    bool? isLoading,
    List<SupportTicket>? tickets,
    String? error,
    bool clearError = false,
  }) {
    return HelpCenterState(
      isLoading: isLoading ?? this.isLoading,
      tickets: tickets ?? this.tickets,
      error: clearError ? null : error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [isLoading, tickets, error];
}

