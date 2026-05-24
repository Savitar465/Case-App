import 'dart:developer' as developer;

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:market_app/features/market/data/models/business_model.dart';
import 'package:market_app/features/market/data/models/category_model.dart';

class MarketRemoteDataSource {
  MarketRemoteDataSource(this._supabase);
  final SupabaseClient _supabase;

  Future<List<CategoryModel>> getCategories() async {
    developer.log(
      'Fetching categories from Supabase...',
      name: 'MarketRemoteDataSource',
    );
    try {
      final response = await _supabase
          .from('categories')
          .select()
          .order('order', ascending: true);

      developer.log(
        'Categories raw response: $response',
        name: 'MarketRemoteDataSource',
      );
      return (response as List)
          .map((json) => CategoryModel.fromRemote(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      developer.log(
        'Error fetching categories: $e',
        name: 'MarketRemoteDataSource',
        error: e,
      );
      rethrow;
    }
  }

  Future<List<BusinessModel>> getBusinesses() async {
    developer.log(
      'Fetching businesses from Supabase...',
      name: 'MarketRemoteDataSource',
    );
    try {
      final response = await _supabase
          .from('businesses')
          .select()
          .neq('status', 'deleted');

      developer.log(
        'Businesses raw response: $response',
        name: 'MarketRemoteDataSource',
      );
      return (response as List)
          .map((json) => BusinessModel.fromRemote(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      developer.log(
        'Error fetching businesses: $e',
        name: 'MarketRemoteDataSource',
        error: e,
      );
      rethrow;
    }
  }
}

class MarketRemoteException implements Exception {
  const MarketRemoteException(this.message);
  final String message;
}
