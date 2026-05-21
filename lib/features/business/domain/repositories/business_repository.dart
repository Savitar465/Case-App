import '../entities/business.dart';
import '../entities/business_image.dart';

abstract class BusinessRepository {
  Stream<List<Business>> watchBusinesses();
  Future<void> refreshBusinesses();
  Future<Business?> getBusiness(String id);
  Future<List<BusinessImage>> getBusinessImages(String businessId);
}
