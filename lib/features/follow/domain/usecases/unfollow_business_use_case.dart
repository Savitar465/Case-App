import '../repositories/follow_repository.dart';

class UnfollowBusinessUseCase {
  const UnfollowBusinessUseCase(this._repository);

  final FollowRepository _repository;

  Future<void> call({required String businessId}) =>
      _repository.unfollowBusiness(businessId);
}
