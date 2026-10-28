import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/settings_failure.dart';
import '../../domain/entities/support_ticket.dart';
import '../../domain/usecases/get_support_tickets_use_case.dart';

part 'help_center_state.dart';

class HelpCenterCubit extends Cubit<HelpCenterState> {
  HelpCenterCubit({required GetSupportTicketsUseCase getSupportTickets})
    : _getSupportTickets = getSupportTickets,
      super(const HelpCenterState());

  final GetSupportTicketsUseCase _getSupportTickets;

  Future<void> loadTickets() async {
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      final tickets = await _getSupportTickets();
      emit(state.copyWith(isLoading: false, tickets: tickets));
    } on SettingsFailure catch (failure) {
      emit(state.copyWith(isLoading: false, error: failure.message));
    } catch (_) {
      emit(
        state.copyWith(
          isLoading: false,
          error: 'No se pudieron cargar tus solicitudes de soporte',
        ),
      );
    }
  }
}

