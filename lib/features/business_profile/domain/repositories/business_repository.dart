import '../entities/business.dart';

abstract class BusinessRepository {
  Stream<List<Business>> watchBusinesses();
  Future<void> refreshBusinesses();
  Future<Business?> getBusiness(String id);
}
