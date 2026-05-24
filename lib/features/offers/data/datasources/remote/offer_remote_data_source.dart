import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/offer_model.dart';

class OfferRemoteDataSource {
  OfferRemoteDataSource(this._client);

  final SupabaseClient _client;

  static const String _schema = 'public';
  static const String _table = 'offers';
  static const String _imagesBucket = 'vikus';

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
