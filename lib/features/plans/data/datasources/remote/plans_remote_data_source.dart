import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../models/plan_business_model.dart';
import '../../models/plan_model.dart';
import '../../models/pro_subscription_model.dart';

class PlansRemoteDataSource {
  PlansRemoteDataSource(this._client);

  final SupabaseClient _client;

  static const String _plansTable = 'plans';
  static const String _businessesTable = 'businesses';
  static const String _subscriptionsTable = 'pro_subscriptions';
  static const String _imagesBucket = 'vikus';
  static const Uuid _uuid = Uuid();

  Future<List<PlanModel>> fetchPlans() async {
    try {
      final rows = await _client
          .from(_plansTable)
          .select()
          .eq('is_active', true)
          .order('price', ascending: true);

      return rows.map((row) => PlanModel.fromRemote(row)).toList();
    } on PostgrestException catch (error) {
      throw PlansRemoteException(error.message);
    }
  }

  Future<List<PlanBusinessModel>> fetchMyBusinesses() async {
    final user = _client.auth.currentUser;
    if (user == null) {
      throw const PlansRemoteException('Debes iniciar sesión para continuar');
    }

    try {
      final rows =
          await _client
                  .from(_businessesTable)
                  .select('id, name, address, is_pro, pro_expires_at, status')
                  .eq('owner_id', user.id)
                  .neq('status', 'deleted')
                  .order('created_at', ascending: false)
              as List<dynamic>;

      final businessList = rows.whereType<Map<String, dynamic>>().toList();
      if (businessList.isEmpty) return [];

      final coverImages = <String, String>{};
      try {
        final businessIds =
            businessList.map((b) => b['id'] as String).toList();
        final imageRows =
            await _client
                    .from('business_images')
                    .select('business_id, url, is_cover')
                    .inFilter('business_id', businessIds)
                    .order('is_cover', ascending: false)
                as List<dynamic>;

        for (final img in imageRows.whereType<Map<String, dynamic>>()) {
          final bId = img['business_id'] as String?;
          final rawUrl = img['url'] as String?;
          if (bId != null && rawUrl != null && !coverImages.containsKey(bId)) {
            coverImages[bId] = _resolveImageUrl(rawUrl) ?? rawUrl;
          }
        }
      } catch (_) {
        // Si no existen fotos o falla la consulta secundaria, continuamos sin imágenes
      }

      return businessList.map((row) {
        final id = row['id'] as String;
        final rawExpiry = row['pro_expires_at'];
        final proExpiresAt = rawExpiry is DateTime
            ? rawExpiry
            : DateTime.tryParse(rawExpiry?.toString() ?? '')?.toUtc();

        return PlanBusinessModel(
          id: id,
          name: (row['name'] as String?) ?? 'Negocio',
          address: (row['address'] as String?) ?? '',
          imageUrl: coverImages[id],
          isPro: row['is_pro'] as bool? ?? false,
          proExpiresAt: proExpiresAt,
        );
      }).toList();
    } on PostgrestException catch (error) {
      throw PlansRemoteException(error.message);
    }
  }

  Future<ProSubscriptionModel> subscribeBusiness({
    required String businessId,
    required String planId,
    required double priceBought,
  }) async {
    final user = _client.auth.currentUser;
    if (user == null) {
      throw const PlansRemoteException('Debes iniciar sesión para continuar');
    }

    final now = DateTime.now().toUtc();
    final endDate = DateTime(
      now.year,
      now.month + 1,
      now.day,
      now.hour,
      now.minute,
      now.second,
    ).toUtc();

    try {
      final subscriptionId = _uuid.v4();
      final subscriptionPayload = <String, dynamic>{
        'id': subscriptionId,
        'business_id': businessId,
        'plan_id': planId,
        'price_bought': priceBought,
        'payment_id': null,
        'start_date': now.toIso8601String(),
        'end_date': endDate.toIso8601String(),
        'is_active': true,
        'created_at': now.toIso8601String(),
      };

      final response = await _client
          .from(_subscriptionsTable)
          .insert(subscriptionPayload)
          .select()
          .single();

      await _client.from(_businessesTable).update({
        'is_pro': true,
        'pro_expires_at': endDate.toIso8601String(),
        'updated_at': now.toIso8601String(),
        'updated_by': user.id,
      }).eq('id', businessId);

      return ProSubscriptionModel.fromRemote(response);
    } on PostgrestException catch (error) {
      throw PlansRemoteException(error.message);
    }
  }

  String? _resolveImageUrl(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    if (raw.startsWith('http://') || raw.startsWith('https://')) return raw;
    return _client.storage.from(_imagesBucket).getPublicUrl(raw);
  }
}

class PlansRemoteException implements Exception {
  const PlansRemoteException(this.message);

  final String message;

  @override
  String toString() => message;
}
