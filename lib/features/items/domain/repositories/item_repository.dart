import '../entities/item.dart';

abstract class ItemRepository {
  Stream<List<Item>> watchItems(String businessId);
  Future<void> refreshItems(String businessId);
  Future<Item?> getItem(String id);
}
