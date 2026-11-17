import 'dart:async';
import 'dart:io';

import '../../domain/entities/business_registration_failure.dart';
import '../../domain/entities/place_location.dart';
import '../../domain/entities/place_suggestion.dart';
import '../../domain/repositories/place_search_repository.dart';
import '../datasources/remote/places_remote_data_source.dart';

class PlaceSearchRepositoryImpl implements PlaceSearchRepository {
  PlaceSearchRepositoryImpl({required PlacesRemoteDataSource remoteDataSource})
    : _remote = remoteDataSource;

  final PlacesRemoteDataSource _remote;

  @override
  Future<List<PlaceSuggestion>> searchPlaces(
    String query, {
    double? nearLatitude,
    double? nearLongitude,
  }) => _run(
    () => _remote.autocomplete(
      query,
      nearLatitude: nearLatitude,
      nearLongitude: nearLongitude,
    ),
  );

  @override
  Future<PlaceLocation> getPlaceLocation(String placeId) =>
      _run(() => _remote.fetchLocation(placeId));

  Future<T> _run<T>(Future<T> Function() action) async {
    try {
      return await action();
    } catch (error) {
      throw _mapInfraError(error);
    }
  }

  BusinessRegistrationFailure _mapInfraError(Object error) {
    if (error is BusinessRegistrationFailure) return error;
    if (error is PlacesRemoteException) {
      return BusinessRegistrationFailure(error.message);
    }
    if (error is SocketException) {
      return const BusinessRegistrationFailure('Sin conexión a internet');
    }
    if (error is TimeoutException) {
      return const BusinessRegistrationFailure('La solicitud tardó demasiado');
    }
    return BusinessRegistrationFailure(error.toString());
  }
}
