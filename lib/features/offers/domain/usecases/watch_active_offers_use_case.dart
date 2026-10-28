import '../entities/offer_detail.dart';
import '../repositories/offer_repository.dart';

class WatchActiveOffersUseCase {
  const WatchActiveOffersUseCase(this._repository);

  final OfferRepository _repository;

  Stream<List<OfferDetail>> call() => _repository.watchActiveOffers();
}
