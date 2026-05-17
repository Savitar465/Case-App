import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:market_app/features/business/data/models/business_model.dart';

class BusinessRemoteDataSource {
  BusinessRemoteDataSource(this._client);

  final SupabaseClient _client;

  static const String _table = 'business';

  Future<List<BusinessModel>> fetchBusinesses() async {
    try {
      final response = await _client
          .from(_table)
          .select()
          .order('name', ascending: true) as List<dynamic>;
      return response
          .whereType<Map<String, dynamic>>()
          .map(BusinessModel.fromRemote)
          .toList();
    } on PostgrestException catch (error) {
      throw BusinessRemoteException(error.message);
    }
  }
}

class BusinessRemoteException implements Exception {
  const BusinessRemoteException(this.message);

  final String message;

  @override
  String toString() => 'BusinessRemoteException: $message';
}
