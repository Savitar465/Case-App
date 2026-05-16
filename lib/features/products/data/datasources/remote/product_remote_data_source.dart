import 'package:market_app/features/products/data/models/product_model.dart';
import 'package:market_app/features/products/data/models/seller_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductRemoteDataSource {
  ProductRemoteDataSource(this._client);

  final SupabaseClient _client;

  static const String _productsTable = 'products';
  static const String _sellersTable = 'sellers';
  static const String _schema = 'market';

  Future<List<ProductModel>> fetchProducts({String? sellerId}) async {
    final builder = _client.schema(_schema).from(_productsTable).select();
    if (sellerId != null) {
      builder.eq('seller_id', sellerId);
    }
    try {
      final response =
          await builder.order('updated_at', ascending: false) as List<dynamic>;
      return response
          .whereType<Map<String, dynamic>>()
          .map(ProductModel.fromRemote)
          .toList();
    } on PostgrestException catch (error) {
      throw ProductRemoteException(error.message);
    }
  }

  Future<ProductModel> upsertProduct(ProductModel product) async {
    try {
      final Map<String, dynamic> result = await _client
          .schema(_schema)
          .from(_productsTable)
          .upsert(product.toRemoteMap(), onConflict: 'id')
          .select()
          .single();
      return ProductModel.fromRemote(result);
    } on PostgrestException catch (error) {
      throw ProductRemoteException(error.message);
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      await _client
          .schema(_schema)
          .from(_productsTable)
          .delete()
          .eq('id', productId);
    } on PostgrestException catch (error) {
      throw ProductRemoteException(error.message);
    }
  }

  Future<SellerModel?> fetchSellerForUser(String userId) async {
    try {
      final response = await _client
          .schema(_schema)
          .from(_sellersTable)
          .select()
          .eq('user_id', userId)
          .maybeSingle();
      if (response == null) {
        return null;
      }
      return SellerModel.fromRemote(response);
    } on PostgrestException catch (error) {
      throw ProductRemoteException(error.message);
    }
  }

  Future<SellerModel?> fetchSellerById(String sellerId) async {
    try {
      final response = await _client
          .schema(_schema)
          .from(_sellersTable)
          .select()
          .eq('id', sellerId)
          .maybeSingle();
      if (response == null) {
        return null;
      }
      return SellerModel.fromRemote(response);
    } on PostgrestException catch (error) {
      throw ProductRemoteException(error.message);
    }
  }
}

class ProductRemoteException implements Exception {
  const ProductRemoteException(this.message);

  final String message;

  @override
  String toString() => message;
}
