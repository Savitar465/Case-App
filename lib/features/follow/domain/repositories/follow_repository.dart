import '../entities/follow.dart';

abstract class FollowRepository {
  Stream<List<Follow>> watchFollows();

  Future<void> refreshFollows();

  Future<void> followBusiness(String businessId);

  Future<void> unfollowBusiness(String businessId);
}
