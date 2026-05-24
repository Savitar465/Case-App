import 'package:market_app/features/market/domain/entities/business.dart';
import 'package:market_app/features/market/domain/entities/category.dart';

abstract class MarketRepository {
  Stream<List<MarketCategory>> watchCategories();
  Stream<List<Business>> watchBusinesses();
  Future<void> refresh();
}
