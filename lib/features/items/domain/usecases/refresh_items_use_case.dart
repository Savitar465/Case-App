import '../repositories/item_repository.dart';

class RefreshItemsUseCase {
  const RefreshItemsUseCase(this._repository);

  final ItemRepository _repository;

  Future<void> call({required String businessId}) =>
      _repository.refreshItems(businessId);
}
