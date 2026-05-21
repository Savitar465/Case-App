import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/business_model.dart';

class BusinessRemoteDataSource {
  BusinessRemoteDataSource(this._client);

  final SupabaseClient _client;

  static const String _schema = 'public';
  static const String _table = 'businesses';

  Future<List<BusinessModel>> fetchBusinesses() async {
    try {
      final response = await _client
          .schema(_schema)
          .from(_table)
          .select()
          .order('created_at', ascending: false) as List<dynamic>;
      return response
          .whereType<Map<String, dynamic>>()
          .map(BusinessModel.fromRemote)
          .toList();
    } on PostgrestException catch (error) {
      throw BusinessRemoteException(error.message);
    }
  }

  Future<BusinessModel?> fetchBusinessById(String id) async {
    try {
      final response = await _client
          .schema(_schema)
          .from(_table)
          .select()
          .eq('id', id)
          .maybeSingle();
      if (response == null) return null;
      return BusinessModel.fromRemote(response);
    } on PostgrestException catch (error) {
      throw BusinessRemoteException(error.message);
    }
  }
}

class BusinessRemoteException implements Exception {
  const BusinessRemoteException(this.message);

  final String message;

  @override
  String toString() => message;
}
