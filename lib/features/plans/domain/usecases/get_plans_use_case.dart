import '../entities/plan.dart';
import '../repositories/plans_repository.dart';

class GetPlansUseCase {
  const GetPlansUseCase(this._repository);

  final PlansRepository _repository;

  Future<List<Plan>> call() => _repository.getPlans();
}

