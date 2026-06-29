import '../../../market/domain/entities/category.dart';
import '../entities/business_draft.dart';

abstract class BusinessRegistrationRepository {
  /// Loads the selectable business categories for the category step.
  Future<List<MarketCategory>> getCategories();

  /// Persists [draft] as a new business owned by the signed-in user and
  /// returns the new business id. Throws when there is no session.
  Future<String> publish(BusinessDraft draft);
}
