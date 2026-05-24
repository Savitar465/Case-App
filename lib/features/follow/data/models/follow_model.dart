import '../../domain/entities/follow.dart';

class FollowModel extends Follow {
  const FollowModel({
    required super.id,
    required super.userId,
    required super.businessId,
    required super.createdAt,
  });

  factory FollowModel.fromRemote(Map<String, dynamic> data) {
    return FollowModel(
      id: data['id'] as String,
      userId: data['user_id'] as String,
      businessId: data['business_id'] as String,
      createdAt: _readDateTime(data['created_at']) ?? DateTime.now().toUtc(),
    );
  }

  Map<String, dynamic> toRemoteMap() {
    return {
      'id': id,
      'user_id': userId,
      'business_id': businessId,
      'created_at': createdAt.toIso8601String(),
    };
  }

  static DateTime? _readDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    return DateTime.tryParse(value.toString())?.toUtc();
  }
}
