import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../domain/entities/review_stats.dart';
import '../../models/review_model.dart';

class ReviewRemoteDataSource {
  ReviewRemoteDataSource(this._client);

  final SupabaseClient _client;

  static const String _schema = 'public';
  static const String _table = 'reviews';
  static const String _activeStatus = 'active';
  static const Uuid _uuid = Uuid();

  String? get _currentUserId => _client.auth.currentUser?.id;

  /// Aggregate rating computed from the review rows (no DB view required).
  Future<ReviewStats> fetchStats(String businessId) async {
    try {
      final rows =
          await _client
                  .schema(_schema)
                  .from(_table)
                  .select('rating')
                  .eq('business_id', businessId)
              as List<dynamic>;
      final ratings = rows
          .whereType<Map<String, dynamic>>()
          .map((row) => (row['rating'] as num?)?.toDouble() ?? 0)
          .where((value) => value > 0)
          .toList();
      if (ratings.isEmpty) return ReviewStats.empty;
      final sum = ratings.reduce((a, b) => a + b);
      return ReviewStats(average: sum / ratings.length, count: ratings.length);
    } on PostgrestException catch (error) {
      throw ReviewRemoteException(error.message);
    }
  }

  Future<List<ReviewModel>> fetchReviews(
    String businessId, {
    int limit = 20,
  }) async {
    try {
      final rows =
          await _client
                  .schema(_schema)
                  .from(_table)
                  .select()
                  .eq('business_id', businessId)
                  .order('created_at', ascending: false)
                  .limit(limit)
              as List<dynamic>;
      final me = _currentUserId;
      return rows
          .whereType<Map<String, dynamic>>()
          .map((row) => ReviewModel.fromRemote(row, currentUserId: me))
          .toList();
    } on PostgrestException catch (error) {
      throw ReviewRemoteException(error.message);
    }
  }

  Future<ReviewModel?> fetchMyReview(String businessId) async {
    final userId = _currentUserId;
    if (userId == null) return null;
    try {
      final row = await _client
          .schema(_schema)
          .from(_table)
          .select()
          .eq('business_id', businessId)
          .eq('user_id', userId)
          .maybeSingle();
      if (row == null) return null;
      return ReviewModel.fromRemote(row, currentUserId: userId);
    } on PostgrestException catch (error) {
      throw ReviewRemoteException(error.message);
    }
  }

  /// Inserts a new review or updates the current user's existing one. Uses an
  /// explicit read-then-write so it does not depend on a unique constraint.
  Future<ReviewModel> upsertReview({
    required String businessId,
    required int rating,
    String? comment,
  }) async {
    final user = _client.auth.currentUser;
    if (user == null) throw const ReviewRemoteException.notAuthenticated();
    final table = _client.schema(_schema).from(_table);
    try {
      final existing = await table
          .select('id')
          .eq('business_id', businessId)
          .eq('user_id', user.id)
          .maybeSingle();

      final Map<String, dynamic> row;
      if (existing != null) {
        row = await table
            .update({
              'rating': rating,
              'comment': comment,
              'updated_by': user.id,
              'updated_at': DateTime.now().toIso8601String(),
            })
            .eq('id', existing['id'] as String)
            .select()
            .single();
      } else {
        row = await table
            .insert({
              // id and created_at have no DB default, so set them here.
              'id': _uuid.v4(),
              'business_id': businessId,
              'user_id': user.id,
              'rating': rating,
              'comment': comment,
              'status': _activeStatus,
              'created_by': user.id,
              'created_at': DateTime.now().toIso8601String(),
            })
            .select()
            .single();
      }
      return ReviewModel.fromRemote(row, currentUserId: user.id);
    } on PostgrestException catch (error) {
      throw ReviewRemoteException(error.message);
    }
  }
}

class ReviewRemoteException implements Exception {
  const ReviewRemoteException(this.message);

  const ReviewRemoteException.notAuthenticated()
    : message = 'Inicia sesión para dejar una opinión';

  final String message;

  @override
  String toString() => message;
}
