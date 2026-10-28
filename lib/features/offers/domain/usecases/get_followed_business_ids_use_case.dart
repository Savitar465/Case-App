import '../repositories/offer_repository.dart';

class GetFollowedBusinessIdsUseCase {
  const GetFollowedBusinessIdsUseCase(this._repository);

  final OfferRepository _repository;

  Future<Set<String>> call() => _repository.getFollowedBusinessIds();
}
