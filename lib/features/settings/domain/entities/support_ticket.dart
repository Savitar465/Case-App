import 'package:equatable/equatable.dart';

/// Support request submitted by a user to the platform team.
class SupportTicket extends Equatable {
  const SupportTicket({
    required this.id,
    required this.userId,
    required this.subject,
    required this.message,
    required this.status,
    this.response,
    required this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String userId;
  final String subject;
  final String message;
  final String status;
  final String? response;
  final DateTime createdAt;
  final DateTime? updatedAt;

  bool get hasResponse => response != null && response!.trim().isNotEmpty;

  SupportTicket copyWith({
    String? id,
    String? userId,
    String? subject,
    String? message,
    String? status,
    String? response,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SupportTicket(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      subject: subject ?? this.subject,
      message: message ?? this.message,
      status: status ?? this.status,
      response: response ?? this.response,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    subject,
    message,
    status,
    response,
    createdAt,
    updatedAt,
  ];
}

