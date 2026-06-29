import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../domain/entities/profile_business.dart';
import '../../../domain/entities/profile_overview.dart';
import '../../../domain/entities/profile_user.dart';

class ProfileRemoteDataSource {
  ProfileRemoteDataSource(this._client);

  final SupabaseClient _client;

  static const String _businessesTable = 'businesses';
  static const String _followsTable = 'business_follows';
  static const String _imagesBucket = 'vikus';

  Future<ProfileOverview> loadOverview() async {
    final user = _client.auth.currentUser;
    final profileUser = ProfileUser(
      isGuest: user == null,
      id: user?.id,
      email: user?.email,
      displayName: _displayName(user),
      location: user?.userMetadata?['location'] as String?,
    );

    if (user == null) {
      return ProfileOverview(user: profileUser);
    }

    try {
      final followed = await _fetchFollowed(user.id);
      final owned = await _fetchOwned(user.id);
      return ProfileOverview(
        user: profileUser,
        followed: followed,
        owned: owned,
      );
    } on PostgrestException catch (error) {
      throw ProfileRemoteException(error.message);
    }
  }

  Future<void> unfollow(String businessId) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) {
      throw const ProfileRemoteException('Inicia sesión para continuar');
    }
    try {
      await _client
          .from(_followsTable)
          .delete()
          .eq('user_id', userId)
          .eq('business_id', businessId);
    } on PostgrestException catch (error) {
      throw ProfileRemoteException(error.message);
    }
  }

  Future<List<ProfileBusiness>> _fetchFollowed(String userId) async {
    final rows =
        await _client
                .from(_followsTable)
                .select('businesses(*)')
                .eq('user_id', userId)
            as List<dynamic>;
    return rows
        .whereType<Map<String, dynamic>>()
        .map((row) => row['businesses'])
        .whereType<Map<String, dynamic>>()
        .map(_mapBusiness)
        .toList();
  }

  Future<List<ProfileBusiness>> _fetchOwned(String userId) async {
    final rows =
        await _client
                .from(_businessesTable)
                .select()
                .eq('owner_id', userId)
                .neq('status', 'deleted')
                .order('created_at', ascending: false)
            as List<dynamic>;
    return rows
        .whereType<Map<String, dynamic>>()
        .map(_mapBusiness)
        .toList();
  }

  ProfileBusiness _mapBusiness(Map<String, dynamic> json) {
    return ProfileBusiness(
      id: json['id'] as String,
      name: (json['name'] as String?) ?? 'Negocio',
      address: (json['address'] as String?) ?? '',
      imageUrl: _resolveImageUrl(json['image_url'] as String?),
      status: (json['status'] as String?) ?? 'pending',
      isPro: json['is_pro'] as bool? ?? false,
      followersCount: (json['followers_count'] as num?)?.toInt() ?? 0,
      viewsCount: (json['views_count'] as num?)?.toInt() ?? 0,
    );
  }

  /// Converts a storage path into a public URL; passes through absolute URLs.
  String? _resolveImageUrl(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    if (raw.startsWith('http://') || raw.startsWith('https://')) return raw;
    return _client.storage.from(_imagesBucket).getPublicUrl(raw);
  }

  String? _displayName(User? user) {
    final meta = user?.userMetadata;
    if (meta == null) return null;
    for (final key in const ['full_name', 'name', 'display_name']) {
      final value = meta[key];
      if (value is String && value.trim().isNotEmpty) return value.trim();
    }
    return null;
  }
}

class ProfileRemoteException implements Exception {
  const ProfileRemoteException(this.message);

  final String message;

  @override
  String toString() => message;
}
