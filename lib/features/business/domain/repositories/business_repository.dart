import '../entities/business.dart';
import '../entities/business_image.dart';

abstract class BusinessRepository {
  Stream<List<Business>> watchBusinesses();
  Future<void> refreshBusinesses();
  Future<Business?> getBusiness(String id);
  Future<List<BusinessImage>> getBusinessImages(String businessId);

  /// Whether the signed-in user follows [businessId] (false when signed out).
  Future<bool> isFollowing(String businessId);

  /// Toggles follow state for the signed-in user; returns the new state.
  Future<bool> toggleFollow(String businessId);
}
