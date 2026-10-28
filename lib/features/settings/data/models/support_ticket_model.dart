import '../../domain/entities/support_ticket.dart';

class SupportTicketModel extends SupportTicket {
  const SupportTicketModel({
    required super.id,
    required super.userId,
    required super.subject,
    required super.message,
    required super.status,
    super.response,
    required super.createdAt,
    super.updatedAt,
  });

  factory SupportTicketModel.fromRemote(Map<String, dynamic> map) {
    return SupportTicketModel(
      id: map['id']?.toString() ?? '',
      userId: map['user_id']?.toString() ?? '',
      subject: map['subject'] as String? ?? '',
      message: map['message'] as String? ?? '',
      status: map['status'] as String? ?? 'open',
      response: map['response'] as String?,
      createdAt: map['created_at'] != null
          ? DateTime.tryParse(map['created_at'].toString())?.toLocal() ??
              DateTime.now()
          : DateTime.now(),
      updatedAt: map['updated_at'] != null
          ? DateTime.tryParse(map['updated_at'].toString())?.toLocal()
          : null,
    );
  }

  Map<String, dynamic> toRemoteMap() {
    return {
      'id': id,
      'user_id': userId,
      'subject': subject,
      'message': message,
      'status': status,
      if (response != null) 'response': response,
      'created_at': createdAt.toUtc().toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toUtc().toIso8601String(),
    };
  }
}

