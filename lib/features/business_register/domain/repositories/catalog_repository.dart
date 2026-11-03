import '../entities/catalog_item.dart';
import '../entities/catalog_item_draft.dart';
import '../entities/catalog_offer.dart';

/// Owner-side management of a business's products, services and flash
/// offers.
abstract class CatalogRepository {
  /// Every item of [businessId], paused ones included.
  Future<List<CatalogItem>> getItems(String businessId);

  /// Every offer of [businessId], paused and expired ones included.
  Future<List<CatalogOffer>> getOffers(String businessId);

  /// Inserts [draft] (and its flash offer, if any) into [businessId].
  Future<void> addItem(String businessId, CatalogItemDraft draft);

  /// Saves [draft]'s fields onto [item]; replaces or clears its photo when
  /// [CatalogItemDraft.photoPath] / [CatalogItemDraft.clearPhoto] say so.
  Future<void> updateItem(CatalogItem item, CatalogItemDraft draft);

  Future<void> setItemActive(String itemId, {required bool isActive});

  /// Permanently deletes [item]; its photos, offers and favorites cascade.
  Future<void> deleteItem(CatalogItem item);

  /// Creates (when [offerId] is null) or updates a flash offer on [item].
  Future<void> saveOffer({
    required CatalogItem item,
    required FlashOffer offer,
    String? offerId,
  });

  Future<void> setOfferActive(String offerId, {required bool isActive});

  Future<void> deleteOffer(String offerId);
}
