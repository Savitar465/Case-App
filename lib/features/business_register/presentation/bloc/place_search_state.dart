part of 'place_search_cubit.dart';

class PlaceSearchState extends Equatable {
  const PlaceSearchState({this.suggestions = const [], this.isLoading = false});

  final List<PlaceSuggestion> suggestions;
  final bool isLoading;

  PlaceSearchState copyWith({
    List<PlaceSuggestion>? suggestions,
    bool? isLoading,
  }) {
    return PlaceSearchState(
      suggestions: suggestions ?? this.suggestions,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [suggestions, isLoading];
}
