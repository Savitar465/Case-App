import '../entities/plan.dart';

abstract class PlansRepository {
  Future<List<Plan>> getPlans();
}

