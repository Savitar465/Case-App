import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/plan_model.dart';

class PlansRemoteDataSource {
  PlansRemoteDataSource(this._client);

  final SupabaseClient _client;

  static const String _plansTable = 'plans';

  Future<List<PlanModel>> fetchPlans() async {
    try {
      final rows = await _client
          .from(_plansTable)
          .select()
          .eq('is_active', true)
          .order('price', ascending: true);

      return rows
          .map((row) => PlanModel.fromRemote(row))
          .toList();
    } on PostgrestException catch (error) {
      throw PlansRemoteException(error.message);
    }
  }
}

class PlansRemoteException implements Exception {
  const PlansRemoteException(this.message);

  final String message;

  @override
  String toString() => message;
}
