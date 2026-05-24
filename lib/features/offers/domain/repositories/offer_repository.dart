import '../entities/offer.dart';

abstract class OfferRepository {
  Stream<List<Offer>> watchOffers(String businessId);

  Future<void> refreshOffers(String businessId);

  Future<Offer?> getOffer(String id);
}
