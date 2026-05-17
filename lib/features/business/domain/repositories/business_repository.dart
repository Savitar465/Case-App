import 'package:market_app/features/business/domain/entities/business.dart';

abstract class BusinessRepository {
  Stream<List<Business>> watchBusinesses();

  Future<void> refreshBusinesses();
}
