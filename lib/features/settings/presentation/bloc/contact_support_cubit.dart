import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/settings_failure.dart';
import '../../domain/usecases/submit_support_ticket_use_case.dart';

part 'contact_support_state.dart';

class ContactSupportCubit extends Cubit<ContactSupportState> {
  ContactSupportCubit({required SubmitSupportTicketUseCase submitTicket})
    : _submitTicket = submitTicket,
      super(const ContactSupportState());

  final SubmitSupportTicketUseCase _submitTicket;

  Future<void> submit({
    required String subject,
    required String message,
  }) async {
    emit(state.copyWith(isSubmitting: true, clearError: true));
    try {
      await _submitTicket(subject: subject, message: message);
      emit(state.copyWith(isSubmitting: false, sent: true));
    } on SettingsFailure catch (failure) {
      emit(state.copyWith(isSubmitting: false, error: failure.message));
    } catch (_) {
      emit(
        state.copyWith(
          isSubmitting: false,
          error: 'No se pudo enviar tu mensaje',
        ),
      );
    }
  }
}
