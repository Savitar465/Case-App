import '../entities/support_ticket.dart';
import '../repositories/settings_repository.dart';

class GetSupportTicketsUseCase {
  const GetSupportTicketsUseCase(this._repository);

  final SettingsRepository _repository;

  Future<List<SupportTicket>> call() => _repository.getSupportTickets();
}

