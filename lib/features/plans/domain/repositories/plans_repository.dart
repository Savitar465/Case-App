import '../entities/plan.dart';
import '../entities/plan_business.dart';
import '../entities/pro_subscription.dart';

abstract class PlansRepository {
  Future<List<Plan>> getPlans();
  Future<List<PlanBusiness>> getMyBusinesses();
  Future<ProSubscription> subscribeBusiness({
    required String businessId,
    required Plan plan,
  });
}
