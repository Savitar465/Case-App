import '../repositories/catalog_repository.dart';

class SetOfferActiveUseCase {
  const SetOfferActiveUseCase(this._repository);

  final CatalogRepository _repository;

  Future<void> call(String offerId, {required bool isActive}) =>
      _repository.setOfferActive(offerId, isActive: isActive);
}
