import '../entities/catalog_offer.dart';
import '../repositories/catalog_repository.dart';

class GetCatalogOffersUseCase {
  const GetCatalogOffersUseCase(this._repository);

  final CatalogRepository _repository;

  Future<List<CatalogOffer>> call(String businessId) =>
      _repository.getOffers(businessId);
}
