import 'package:equatable/equatable.dart';

/// Coordinates (and formatted address) of a chosen place suggestion.
class PlaceLocation extends Equatable {
  const PlaceLocation({
    required this.latitude,
    required this.longitude,
    this.address = '',
  });

  final double latitude;
  final double longitude;
  final String address;

  @override
  List<Object?> get props => [latitude, longitude, address];
}
