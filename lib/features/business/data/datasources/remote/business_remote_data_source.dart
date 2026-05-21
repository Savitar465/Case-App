import 'dart:developer' as developer;

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/business_image_model.dart';
import '../../models/business_model.dart';

class BusinessRemoteDataSource {
  BusinessRemoteDataSource(this._client);

  final SupabaseClient _client;

  static const String _schema = 'public';
  static const String _table = 'businesses';
  static const String _imagesTable = 'business_images';
  static const String _imagesBucket = 'vikus';

  Future<List<BusinessModel>> fetchBusinesses() async {
    try {
      final response =
          await _client
                  .schema(_schema)
                  .from(_table)
                  .select()
                  .order('created_at', ascending: false)
              as List<dynamic>;
      return response
          .whereType<Map<String, dynamic>>()
          .map(BusinessModel.fromRemote)
          .toList();
    } on PostgrestException catch (error) {
      throw BusinessRemoteException(error.message);
    }
  }

  Future<List<BusinessImageModel>> fetchBusinessImages(String businessId) async {
    developer.log('fetchBusinessImages start id=$businessId', name: 'BusinessImages');
    try {
      final response =
          await _client
                  .schema(_schema)
                  .from(_imagesTable)
                  .select()
                  .eq('business_id', businessId)
                  .order('is_cover', ascending: false)
                  .order('display_order', ascending: true)
              as List<dynamic>;
      developer.log(
        'fetchBusinessImages rows=${response.length} raw=$response',
        name: 'BusinessImages',
      );
      return response
          .whereType<Map<String, dynamic>>()
          .map(BusinessImageModel.fromRemote)
          .map(_resolveImageUrl)
          .toList();
    } on PostgrestException catch (error) {
      developer.log(
        'fetchBusinessImages PostgrestException: ${error.message}',
        name: 'BusinessImages',
        error: error,
      );
      throw BusinessRemoteException(error.message);
    } catch (error, st) {
      developer.log(
        'fetchBusinessImages error: $error',
        name: 'BusinessImages',
        error: error,
        stackTrace: st,
      );
      rethrow;
    }
  }

  BusinessImageModel _resolveImageUrl(BusinessImageModel image) {
    final raw = image.url;
    developer.log('business_images raw url=$raw', name: 'BusinessImages');
    if (raw.isEmpty || raw.startsWith('http://') || raw.startsWith('https://')) {
      return image;
    }
    final resolved = _client.storage.from(_imagesBucket).getPublicUrl(raw);
    developer.log('business_images resolved=$resolved', name: 'BusinessImages');
    return BusinessImageModel(
      id: image.id,
      businessId: image.businessId,
      url: resolved,
      isCover: image.isCover,
      displayOrder: image.displayOrder,
      createdAt: image.createdAt,
    );
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
