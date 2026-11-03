import '../entities/editable_business.dart';
import '../repositories/business_registration_repository.dart';

class GetBusinessForEditUseCase {
  const GetBusinessForEditUseCase(this._repository);

  final BusinessRegistrationRepository _repository;

  Future<EditableBusiness> call(String businessId) =>
      _repository.getBusinessForEdit(businessId);
}
