import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../domain/entities/profile_business.dart';
import '../../../domain/entities/profile_overview.dart';
import '../../../domain/entities/profile_user.dart';

class ProfileRemoteDataSource {
  ProfileRemoteDataSource(this._client);

  final SupabaseClient _client;

  static const String _businessesTable = 'businesses';
  static const String _followsTable = 'business_follows';
  static const String _usersTable = 'users';
  static const String _imagesBucket = 'vikus';

  Future<ProfileOverview> loadOverview() async {
    final user = _client.auth.currentUser;
    if (user == null) {
      return const ProfileOverview(user: ProfileUser.guest());
    }

    try {
      // Username and photo are edited in "Editar perfil" and only live in
      // public.users, not in the auth metadata.
      final row = await _client
          .from(_usersTable)
          .select('username, avatar_url')
          .eq('id', user.id)
          .maybeSingle();
      final profileUser = ProfileUser(
        isGuest: false,
        id: user.id,
        email: user.email,
        displayName: _displayName(user),
        location: user.userMetadata?['location'] as String?,
        username: row?['username'] as String?,
        avatarUrl: _resolveImageUrl(row?['avatar_url'] as String?),
      );
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
                .select('businesses($_businessSelect)')
                .eq('user_id', userId)
            as List<dynamic>;
    return rows
        .whereType<Map<String, dynamic>>()
        .map((row) => row['businesses'])
        .whereType<Map<String, dynamic>>()
        .where((business) => business['status'] != 'deleted')
        .map(_mapBusiness)
        .toList();
  }

  /// Business columns plus the embeds needed for the thumbnail (cover photo)
  /// and the owner dashboard stats (rating, active offers).
  static const String _businessSelect =
      '*, business_images(url, is_cover, display_order), '
      'reviews(rating, status), offers(is_active, end_date)';

  Future<List<ProfileBusiness>> _fetchOwned(String userId) async {
    final rows =
        await _client
                .from(_businessesTable)
                .select(_businessSelect)
                .eq('owner_id', userId)
                .neq('status', 'deleted')
                .order('created_at', ascending: false)
            as List<dynamic>;
    return rows.whereType<Map<String, dynamic>>().map(_mapBusiness).toList();
  }

  ProfileBusiness _mapBusiness(Map<String, dynamic> json) {
    List<Map<String, dynamic>> embedded(String key) =>
        (json[key] as List<dynamic>? ?? const [])
            .whereType<Map<String, dynamic>>()
            .toList();

    // `businesses` has no image column: the thumbnail is the cover photo
    // (or the first one by display order) from `business_images`.
    final images =
        embedded('business_images')
            .where((row) => (row['url'] as String?)?.isNotEmpty ?? false)
            .toList()
          ..sort((a, b) {
            final aCover = a['is_cover'] == true ? 0 : 1;
            final bCover = b['is_cover'] == true ? 0 : 1;
            if (aCover != bCover) return aCover - bCover;
            return ((a['display_order'] as num?) ?? 0).compareTo(
              (b['display_order'] as num?) ?? 0,
            );
          });

    final ratings = [
      for (final review in embedded('reviews'))
        if ((review['status'] as String? ?? 'active') == 'active' &&
            review['rating'] is num)
          (review['rating'] as num).toDouble(),
    ];

    final now = DateTime.now();
    final activeOffers = embedded('offers').where((offer) {
      final endDate = DateTime.tryParse(offer['end_date']?.toString() ?? '');
      return offer['is_active'] == true &&
          (endDate == null || !endDate.isBefore(now));
    }).length;

    return ProfileBusiness(
      id: json['id'] as String,
      name: (json['name'] as String?) ?? 'Negocio',
      address: (json['address'] as String?) ?? '',
      imageUrl: images.isEmpty
          ? null
          : _resolveImageUrl(images.first['url'] as String?),
      status: (json['status'] as String?) ?? 'pending',
      isPro: json['is_pro'] as bool? ?? false,
      followersCount: (json['followers_count'] as num?)?.toInt() ?? 0,
      viewsCount: (json['views_count'] as num?)?.toInt() ?? 0,
      rating: ratings.isEmpty
          ? null
          : ratings.reduce((a, b) => a + b) / ratings.length,
      reviewsCount: ratings.length,
      activeOffersCount: activeOffers,
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
