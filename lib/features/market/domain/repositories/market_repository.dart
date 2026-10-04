import 'package:market_app/features/market/domain/entities/business.dart';
import 'package:market_app/features/market/domain/entities/category.dart';
import 'package:market_app/features/market/domain/entities/home_offer.dart';

abstract class MarketRepository {
  Stream<List<MarketCategory>> watchCategories();
  Stream<List<Business>> watchBusinesses();

  Stream<List<HomeOffer>> watchOffers();
  Future<void> refresh();

  /// Ids of the businesses the signed-in user follows (empty when signed out).
  Future<Set<String>> getFavoriteBusinessIds();
}
