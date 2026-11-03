import '../entities/catalog_item.dart';
import '../repositories/catalog_repository.dart';

class GetCatalogItemsUseCase {
  const GetCatalogItemsUseCase(this._repository);

  final CatalogRepository _repository;

  Future<List<CatalogItem>> call(String businessId) =>
      _repository.getItems(businessId);
}
