import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../models/follow_model.dart';

class FollowRemoteDataSource {
  FollowRemoteDataSource(this._client);

  final SupabaseClient _client;

  static const String _schema = 'public';
  static const String _table = 'follows';
  static const Uuid _uuid = Uuid();

  /// Id of the authenticated Supabase user. Resolving it here keeps Supabase
  /// auth out of the domain/presentation layers.
  String get currentUserId {
    final id = _client.auth.currentUser?.id;
    if (id == null || id.isEmpty) {
      throw const FollowRemoteException('No authenticated user');
    }
    return id;
  }

  Future<List<FollowModel>> fetchFollows(String userId) async {
    try {
      final rows =
          await _client
                  .schema(_schema)
                  .from(_table)
                  .select()
                  .eq('user_id', userId)
                  .order('created_at', ascending: false)
              as List<dynamic>;
      return rows
          .whereType<Map<String, dynamic>>()
          .map(FollowModel.fromRemote)
          .toList();
    } on PostgrestException catch (error) {
      throw FollowRemoteException(error.message);
    }
  }

  Future<void> createFollow(String userId, String businessId) async {
    try {
      final existing = await _client
          .schema(_schema)
          .from(_table)
          .select('id')
          .eq('user_id', userId)
          .eq('business_id', businessId)
          .maybeSingle();
      if (existing != null) return;

      final model = FollowModel(
        id: _uuid.v4(),
        userId: userId,
        businessId: businessId,
        createdAt: DateTime.now().toUtc(),
      );
      await _client.schema(_schema).from(_table).insert(model.toRemoteMap());
    } on PostgrestException catch (error) {
      throw FollowRemoteException(error.message);
    }
  }

  Future<void> deleteFollow(String userId, String businessId) async {
    try {
      await _client
          .schema(_schema)
          .from(_table)
          .delete()
          .eq('user_id', userId)
          .eq('business_id', businessId);
    } on PostgrestException catch (error) {
      throw FollowRemoteException(error.message);
    }
  }
}

class FollowRemoteException implements Exception {
  const FollowRemoteException(this.message);

  final String message;

  @override
  String toString() => message;
}
