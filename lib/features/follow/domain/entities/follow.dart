import 'package:equatable/equatable.dart';

class Follow extends Equatable {
  const Follow({
    required this.id,
    required this.userId,
    required this.businessId,
    required this.createdAt,
  });

  final String id;
  final String userId;
  final String businessId;
  final DateTime createdAt;

  @override
  List<Object?> get props => [id, userId, businessId, createdAt];
}
