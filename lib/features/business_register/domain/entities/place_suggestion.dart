import 'package:equatable/equatable.dart';

/// One autocomplete match for an address/place search.
class PlaceSuggestion extends Equatable {
  const PlaceSuggestion({
    required this.placeId,
    required this.title,
    this.subtitle = '',
  });

  final String placeId;

  /// Main line, e.g. the street or place name.
  final String title;

  /// Secondary line, e.g. zone, city and country. May be empty.
  final String subtitle;

  String get fullText => subtitle.isEmpty ? title : '$title, $subtitle';

  @override
  List<Object?> get props => [placeId, title, subtitle];
}
