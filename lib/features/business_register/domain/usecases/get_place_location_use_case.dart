import '../entities/place_location.dart';
import '../repositories/place_search_repository.dart';

class GetPlaceLocationUseCase {
  const GetPlaceLocationUseCase(this._repository);

  final PlaceSearchRepository _repository;

  Future<PlaceLocation> call(String placeId) =>
      _repository.getPlaceLocation(placeId);
}
