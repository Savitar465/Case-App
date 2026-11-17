import '../entities/place_suggestion.dart';
import '../repositories/place_search_repository.dart';

class SearchPlacesUseCase {
  const SearchPlacesUseCase(this._repository);

  final PlaceSearchRepository _repository;

  Future<List<PlaceSuggestion>> call(
    String query, {
    double? nearLatitude,
    double? nearLongitude,
  }) => _repository.searchPlaces(
    query,
    nearLatitude: nearLatitude,
    nearLongitude: nearLongitude,
  );
}
