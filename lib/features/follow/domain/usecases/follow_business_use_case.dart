import '../repositories/follow_repository.dart';

class FollowBusinessUseCase {
  const FollowBusinessUseCase(this._repository);

  final FollowRepository _repository;

  Future<void> call({required String businessId}) =>
      _repository.followBusiness(businessId);
}
