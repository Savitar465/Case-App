import '../../../market/domain/entities/category.dart';
import '../entities/business_draft.dart';
import '../entities/editable_business.dart';
import '../entities/editable_photo.dart';

abstract class BusinessRegistrationRepository {
  /// Loads the selectable business categories for the category step.
  Future<List<MarketCategory>> getCategories();

  /// Persists [draft] as a new business owned by the signed-in user and
  /// returns the new business id. Throws when there is no session.
  Future<String> publish(BusinessDraft draft);

  /// Loads an owned business into an editable draft plus its photos.
  Future<EditableBusiness> getBusinessForEdit(String businessId);

  /// Saves the edited fields of [businessId]. [photos] is the final ordered
  /// list (first = cover; local ones get uploaded) and [removedPhotos] the
  /// stored photos to delete; pass null for both to leave photos untouched.
  /// The business status is left unchanged.
  Future<void> updateBusiness({
    required String businessId,
    required BusinessDraft draft,
    List<EditablePhoto>? photos,
    List<EditablePhoto>? removedPhotos,
  });

  /// Soft-deletes [businessId] (status `deleted`) and deactivates its items
  /// and offers so it disappears from every listing.
  Future<void> deleteBusiness(String businessId);
}
