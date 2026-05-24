import '../repositories/offer_repository.dart';

class RefreshOffersUseCase {
  const RefreshOffersUseCase(this._repository);

  final OfferRepository _repository;

  Future<void> call({required String businessId}) =>
      _repository.refreshOffers(businessId);
}
