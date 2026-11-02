import '../entities/plan.dart';
import '../entities/pro_subscription.dart';
import '../repositories/plans_repository.dart';

class SubscribeBusinessUseCase {
  const SubscribeBusinessUseCase(this._repository);

  final PlansRepository _repository;

  Future<ProSubscription> call({
    required String businessId,
    required Plan plan,
  }) =>
      _repository.subscribeBusiness(
        businessId: businessId,
        plan: plan,
      );
}

