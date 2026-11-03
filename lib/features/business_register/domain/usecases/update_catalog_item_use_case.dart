import '../entities/catalog_item.dart';
import '../entities/catalog_item_draft.dart';
import '../repositories/catalog_repository.dart';

class UpdateCatalogItemUseCase {
  const UpdateCatalogItemUseCase(this._repository);

  final CatalogRepository _repository;

  Future<void> call(CatalogItem item, CatalogItemDraft draft) =>
      _repository.updateItem(item, draft);
}
