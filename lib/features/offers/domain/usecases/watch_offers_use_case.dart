import '../entities/offer.dart';
import '../repositories/offer_repository.dart';

class WatchOffersUseCase {
  const WatchOffersUseCase(this._repository);

  final OfferRepository _repository;

  Stream<List<Offer>> call({required String businessId}) =>
      _repository.watchOffers(businessId);
}
