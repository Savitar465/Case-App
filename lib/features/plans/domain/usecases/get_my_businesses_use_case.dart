import '../entities/plan_business.dart';
import '../repositories/plans_repository.dart';

class GetMyBusinessesUseCase {
  const GetMyBusinessesUseCase(this._repository);

  final PlansRepository _repository;

  Future<List<PlanBusiness>> call() => _repository.getMyBusinesses();
}
