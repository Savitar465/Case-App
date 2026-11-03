import '../repositories/catalog_repository.dart';

class DeleteOfferUseCase {
  const DeleteOfferUseCase(this._repository);

  final CatalogRepository _repository;

  Future<void> call(String offerId) => _repository.deleteOffer(offerId);
}
