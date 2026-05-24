import '../entities/item.dart';
import '../repositories/item_repository.dart';

class WatchItemsUseCase {
  const WatchItemsUseCase(this._repository);

  final ItemRepository _repository;

  Stream<List<Item>> call({required String businessId}) =>
      _repository.watchItems(businessId);
}
