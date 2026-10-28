import '../entities/offer.dart';
import '../entities/offer_detail.dart';

abstract class OfferRepository {
  Stream<List<Offer>> watchOffers(String businessId);

  Future<void> refreshOffers(String businessId);

  Future<Offer?> getOffer(String id);

  /// Every active, not-yet-expired offer across businesses ("Ofertas" tab).
  Stream<List<OfferDetail>> watchActiveOffers();

  /// Reloads the active-offers cache from Supabase.
  Future<void> refreshActiveOffers();

  /// Ids of the businesses the signed-in user follows (empty for guests).
  Future<Set<String>> getFollowedBusinessIds();
}
