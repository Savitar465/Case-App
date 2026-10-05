import 'dart:developer' as developer;

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../domain/entities/favorite_kind.dart';
import '../../models/favorite_entry_model.dart';

class FavoritesRemoteDataSource {
  FavoritesRemoteDataSource(this._client);

  final SupabaseClient _client;

  static const String _followsTable = 'business_follows';
  static const String _itemFavoritesTable = 'favorites';
  static const String _offerFavoritesTable = 'offer_favorites';
  static const String _imagesBucket = 'vikus';
  static const Uuid _uuid = Uuid();

  String? get currentUserId => _client.auth.currentUser?.id;

  /// All favorites of the signed-in user, or empty when signed out. Queries
  /// run in sequence; each one is small.
  Future<List<FavoriteEntryModel>> fetchFavorites() async {
    final userId = currentUserId;
    if (userId == null) return const [];
    try {
      final follows = await _client
          .from(_followsTable)
          .select(
            '*, businesses(id, name, address, '
            'business_images(url, is_cover, display_order))',
          )
          .eq('user_id', userId);
      final items = await _client
          .from(_itemFavoritesTable)
          .select(
            'created_at, items(id, name, type, price, currency, business_id, '
            'businesses(name), item_images(url, display_order))',
          )
          .eq('user_id', userId);
      final offers = await _client
          .from(_offerFavoritesTable)
          .select(
            'created_at, offers(id, title, business_id, image_url, '
            'businesses(name))',
          )
          .eq('user_id', userId);

      return [
        ..._rows(
          follows,
        ).map((r) => FavoriteEntryModel.fromFollowRow(r, _resolveImageUrl)),
        ..._rows(
          items,
        ).map((r) => FavoriteEntryModel.fromItemRow(r, _resolveImageUrl)),
        ..._rows(
          offers,
        ).map((r) => FavoriteEntryModel.fromOfferRow(r, _resolveImageUrl)),
      ].whereType<FavoriteEntryModel>().toList();
    } on PostgrestException catch (e) {
      developer.log(
        'Error fetching favorites: ${e.message}',
        name: 'FavoritesRemoteDataSource',
        error: e,
      );
      throw FavoritesRemoteException(e.message);
    }
  }

  Future<void> addFavorite(FavoriteKind kind, String targetId) async {
    final userId = _requireUser();
    try {
      switch (kind) {
        case FavoriteKind.business:
          await _client.from(_followsTable).insert({
            'user_id': userId,
            'business_id': targetId,
          });
        case FavoriteKind.service:
        case FavoriteKind.product:
          // The live `favorites` table may lack an id default; send one.
          await _client.from(_itemFavoritesTable).insert({
            'id': _uuid.v4(),
            'user_id': userId,
            'item_id': targetId,
            'created_at': DateTime.now().toUtc().toIso8601String(),
          });
        case FavoriteKind.offer:
          await _client.from(_offerFavoritesTable).insert({
            'user_id': userId,
            'offer_id': targetId,
          });
      }
    } on PostgrestException catch (e) {
      throw FavoritesRemoteException(e.message);
    }
  }

  Future<void> removeFavorite(FavoriteKind kind, String targetId) async {
    final userId = _requireUser();
    final (table, column) = switch (kind) {
      FavoriteKind.business => (_followsTable, 'business_id'),
      FavoriteKind.service ||
      FavoriteKind.product => (_itemFavoritesTable, 'item_id'),
      FavoriteKind.offer => (_offerFavoritesTable, 'offer_id'),
    };
    try {
      await _client
          .from(table)
          .delete()
          .eq('user_id', userId)
          .eq(column, targetId);
    } on PostgrestException catch (e) {
      throw FavoritesRemoteException(e.message);
    }
  }

  String _requireUser() {
    final userId = currentUserId;
    if (userId == null) {
      throw const FavoritesRemoteException(
        'Inicia sesión para guardar favoritos',
      );
    }
    return userId;
  }

  Iterable<Map<String, dynamic>> _rows(dynamic response) =>
      (response as List<dynamic>).whereType<Map<String, dynamic>>();

  String _resolveImageUrl(String raw) {
    if (raw.startsWith('http://') || raw.startsWith('https://')) return raw;
    return _client.storage.from(_imagesBucket).getPublicUrl(raw);
  }
}

class FavoritesRemoteException implements Exception {
  const FavoritesRemoteException(this.message);

  final String message;

  @override
  String toString() => message;
}
