import '../entities/business_draft.dart';
import '../entities/editable_photo.dart';
import '../repositories/business_registration_repository.dart';

class UpdateBusinessUseCase {
  const UpdateBusinessUseCase(this._repository);

  final BusinessRegistrationRepository _repository;

  Future<void> call({
    required String businessId,
    required BusinessDraft draft,
    List<EditablePhoto>? photos,
    List<EditablePhoto>? removedPhotos,
  }) => _repository.updateBusiness(
    businessId: businessId,
    draft: draft,
    photos: photos,
    removedPhotos: removedPhotos,
  );
}
