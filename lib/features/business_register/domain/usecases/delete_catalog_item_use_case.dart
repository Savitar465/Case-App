import '../entities/catalog_item.dart';
import '../repositories/catalog_repository.dart';

class DeleteCatalogItemUseCase {
  const DeleteCatalogItemUseCase(this._repository);

  final CatalogRepository _repository;

  Future<void> call(CatalogItem item) => _repository.deleteItem(item);
}
