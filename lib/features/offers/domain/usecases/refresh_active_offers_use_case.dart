import '../repositories/offer_repository.dart';

class RefreshActiveOffersUseCase {
  const RefreshActiveOffersUseCase(this._repository);

  final OfferRepository _repository;

  Future<void> call() => _repository.refreshActiveOffers();
}
