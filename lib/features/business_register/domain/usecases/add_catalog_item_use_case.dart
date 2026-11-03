import '../entities/catalog_item_draft.dart';
import '../repositories/catalog_repository.dart';

class AddCatalogItemUseCase {
  const AddCatalogItemUseCase(this._repository);

  final CatalogRepository _repository;

  Future<void> call(String businessId, CatalogItemDraft draft) =>
      _repository.addItem(businessId, draft);
}
