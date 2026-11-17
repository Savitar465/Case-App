import '../entities/place_location.dart';
import '../entities/place_suggestion.dart';

/// Address autocomplete for the business location picker.
abstract class PlaceSearchRepository {
  /// Suggestions for [query], biased towards the given coordinates when set.
  Future<List<PlaceSuggestion>> searchPlaces(
    String query, {
    double? nearLatitude,
    double? nearLongitude,
  });

  Future<PlaceLocation> getPlaceLocation(String placeId);
}
