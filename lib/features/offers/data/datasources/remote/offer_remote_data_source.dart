import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/offer_detail_model.dart';
import '../../models/offer_model.dart';

class OfferRemoteDataSource {
  OfferRemoteDataSource(this._client);

  final SupabaseClient _client;

  static const String _schema = 'public';
  static const String _table = 'offers';
  static const String _followsTable = 'business_follows';
  static const String _imagesBucket = 'vikus';

  static const String _detailSelect =
      '*, businesses(name, whatsapp, latitude, longitude, '
      'categories(name_es, icon)), items(price, currency, stock)';

  Future<List<OfferModel>> fetchOffers(String businessId) async {
    try {
      final rows =
          await _client
                  .schema(_schema)
                  .from(_table)
                  .select()
                  .eq('business_id', businessId)
                  .order('created_at', ascending: false)
              as List<dynamic>;
      return rows.whereType<Map<String, dynamic>>().map(_mapRow).toList();
    } on PostgrestException catch (error) {
      throw OfferRemoteException(error.message);
    }
  }

  Future<OfferModel?> fetchOfferById(String id) async {
    try {
      final row = await _client
          .schema(_schema)
          .from(_table)
          .select()
          .eq('id', id)
          .maybeSingle();
      if (row == null) return null;
      return _mapRow(row);
    } on PostgrestException catch (error) {
      throw OfferRemoteException(error.message);
    }
  }

  /// Active offers across all businesses whose end date hasn't passed yet,
  /// soonest-ending first.
  Future<List<OfferDetailModel>> fetchActiveOffers() async {
    try {
      final rows =
          await _client
                  .schema(_schema)
                  .from(_table)
                  .select(_detailSelect)
                  .eq('is_active', true)
                  .gte('end_date', DateTime.now().toIso8601String())
                  .order('end_date', ascending: true)
              as List<dynamic>;
      return rows
          .whereType<Map<String, dynamic>>()
          .map(
            (row) => OfferDetailModel.fromRemote(
              row,
              imageUrl: _resolveImageUrl(row['image_url'] as String?),
            ),
          )
          .toList();
    } on PostgrestException catch (error) {
      throw OfferRemoteException(error.message);
    }
  }

  Future<Set<String>> fetchFollowedBusinessIds() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return const {};
    try {
      final rows =
          await _client
                  .schema(_schema)
                  .from(_followsTable)
                  .select('business_id')
                  .eq('user_id', userId)
              as List<dynamic>;
      return rows
          .whereType<Map<String, dynamic>>()
          .map((row) => row['business_id'])
          .whereType<String>()
          .toSet();
    } on PostgrestException catch (error) {
      throw OfferRemoteException(error.message);
    }
  }

  OfferModel _mapRow(Map<String, dynamic> row) {
    final resolved = _resolveImageUrl(row['image_url'] as String?);
    return OfferModel.fromRemote({...row, 'image_url': resolved});
  }

  String? _resolveImageUrl(String? raw) {
    if (raw == null ||
        raw.isEmpty ||
        raw.startsWith('http://') ||
        raw.startsWith('https://')) {
      return raw;
    }
    return _client.storage.from(_imagesBucket).getPublicUrl(raw);
  }
}

class OfferRemoteException implements Exception {
  const OfferRemoteException(this.message);

  final String message;

  @override
  String toString() => message;
}
