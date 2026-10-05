import 'dart:developer' as developer;

import 'package:market_app/features/market/data/models/business_model.dart';
import 'package:market_app/features/market/data/models/category_model.dart';
import 'package:market_app/features/market/data/models/home_offer_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MarketRemoteDataSource {
  MarketRemoteDataSource(this._supabase);
  final SupabaseClient _supabase;

  static const String _imagesBucket = 'vikus';

  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await _supabase
          .from('categories')
          .select()
          .eq('is_active', true)
          .order('order', ascending: true);

      return (response as List)
          .map((json) => CategoryModel.fromRemote(json as Map<String, dynamic>))
          .toList();
    } on PostgrestException catch (e) {
      developer.log(
        'Error fetching categories: ${e.message}',
        name: 'MarketRemoteDataSource',
        error: e,
      );
      throw MarketRemoteException(e.message);
    }
  }

  Future<List<BusinessModel>> getBusinesses() async {
    try {
      final response = await _supabase
          .from('businesses')
          .select(
            '*, business_images(url, is_cover, display_order), '
            'reviews(rating, status)',
          )
          .neq('status', 'deleted')
          .order('is_pro', ascending: false)
          .order('created_at', ascending: false);

      return (response as List)
          .map(
            (json) => BusinessModel.fromRemote(
              json as Map<String, dynamic>,
              resolveImageUrl: _resolveImageUrl,
            ),
          )
          .toList();
    } on PostgrestException catch (e) {
      developer.log(
        'Error fetching businesses: ${e.message}',
        name: 'MarketRemoteDataSource',
        error: e,
      );
      throw MarketRemoteException(e.message);
    }
  }

  /// Active offers whose end date has not passed yet, soonest-ending first.
  Future<List<HomeOfferModel>> getActiveOffers() async {
    try {
      final response = await _supabase
          .from('offers')
          .select('*, businesses(name)')
          .eq('is_active', true)
          .gte('end_date', DateTime.now().toIso8601String())
          .order('end_date', ascending: true)
          .limit(10);

      return (response as List)
          .map(
            (json) => HomeOfferModel.fromRemote(
              json as Map<String, dynamic>,
              resolveImageUrl: _resolveImageUrl,
            ),
          )
          .toList();
    } on PostgrestException catch (e) {
      developer.log(
        'Error fetching offers: ${e.message}',
        name: 'MarketRemoteDataSource',
        error: e,
      );
      throw MarketRemoteException(e.message);
    }
  }

  /// Storage paths become public URLs; absolute URLs pass through.
  String _resolveImageUrl(String raw) {
    if (raw.startsWith('http://') || raw.startsWith('https://')) return raw;
    return _supabase.storage.from(_imagesBucket).getPublicUrl(raw);
  }
}

class MarketRemoteException implements Exception {
  const MarketRemoteException(this.message);
  final String message;
}
