import '../../domain/entities/review.dart';

class ReviewModel extends Review {
  const ReviewModel({
    required super.id,
    required super.businessId,
    required super.userId,
    required super.authorName,
    required super.rating,
    required super.createdAt,
    super.comment,
  });

  /// Maps a `public.reviews` row. The table has no display-name column (and
  /// there is no profiles table to join), so the author is shown as "Tú" for
  /// the signed-in user's own review and "Usuario" otherwise.
  factory ReviewModel.fromRemote(
    Map<String, dynamic> data, {
    String? currentUserId,
  }) {
    final userId = data['user_id'] as String? ?? '';
    final isMine = currentUserId != null && currentUserId == userId;
    return ReviewModel(
      id: data['id'] as String,
      businessId: data['business_id'] as String,
      userId: userId,
      authorName: isMine ? 'Tú' : 'Usuario',
      rating: (data['rating'] as num?)?.toInt() ?? 0,
      comment: data['comment'] as String?,
      createdAt: _readDateTime(data['created_at']) ?? DateTime.now().toUtc(),
    );
  }

  static DateTime? _readDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    return DateTime.tryParse(value.toString());
  }
}
