import '../repositories/catalog_repository.dart';

class SetCatalogItemActiveUseCase {
  const SetCatalogItemActiveUseCase(this._repository);

  final CatalogRepository _repository;

  Future<void> call(String itemId, {required bool isActive}) =>
      _repository.setItemActive(itemId, isActive: isActive);
}
