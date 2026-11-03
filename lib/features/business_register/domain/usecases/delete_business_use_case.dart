import '../repositories/business_registration_repository.dart';

class DeleteBusinessUseCase {
  const DeleteBusinessUseCase(this._repository);

  final BusinessRegistrationRepository _repository;

  Future<void> call(String businessId) =>
      _repository.deleteBusiness(businessId);
}
