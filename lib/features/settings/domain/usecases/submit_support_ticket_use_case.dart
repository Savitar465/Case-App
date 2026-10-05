import '../repositories/settings_repository.dart';

class SubmitSupportTicketUseCase {
  const SubmitSupportTicketUseCase(this._repository);

  final SettingsRepository _repository;

  Future<void> call({required String subject, required String message}) =>
      _repository.submitSupportTicket(subject: subject, message: message);
}
