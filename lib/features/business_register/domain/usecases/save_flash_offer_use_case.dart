import '../entities/catalog_item.dart';
import '../entities/catalog_item_draft.dart';
import '../repositories/catalog_repository.dart';

class SaveFlashOfferUseCase {
  const SaveFlashOfferUseCase(this._repository);

  final CatalogRepository _repository;

  Future<void> call({
    required CatalogItem item,
    required FlashOffer offer,
    String? offerId,
  }) => _repository.saveOffer(item: item, offer: offer, offerId: offerId);
}
