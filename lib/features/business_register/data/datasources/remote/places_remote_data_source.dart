import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import '../../../domain/entities/place_location.dart';
import '../../../domain/entities/place_suggestion.dart';

/// Google Places API (New): autocomplete + place details over HTTP.
///
/// Autocomplete calls made while the user types share one session token and
/// the details call that follows closes it, so Google bills the whole search
/// as a single session instead of per keystroke.
class PlacesRemoteDataSource {
  PlacesRemoteDataSource({required String apiKey, http.Client? client})
    : _apiKey = apiKey,
      _client = client ?? http.Client();

  final String _apiKey;
  final http.Client _client;

  static const String _baseUrl = 'https://places.googleapis.com/v1';
  static const String _language = 'es';
  static const Duration _timeout = Duration(seconds: 10);
  static const double _biasRadiusMeters = 50000;
  static const Uuid _uuid = Uuid();

  String? _sessionToken;

  Future<List<PlaceSuggestion>> autocomplete(
    String query, {
    double? nearLatitude,
    double? nearLongitude,
  }) async {
    _requireKey();
    final token = _sessionToken ??= _uuid.v4();
    final response = await _client
        .post(
          Uri.parse('$_baseUrl/places:autocomplete'),
          headers: {
            'Content-Type': 'application/json',
            'X-Goog-Api-Key': _apiKey,
          },
          body: jsonEncode({
            'input': query,
            'languageCode': _language,
            'sessionToken': token,
            if (nearLatitude != null && nearLongitude != null)
              'locationBias': {
                'circle': {
                  'center': {
                    'latitude': nearLatitude,
                    'longitude': nearLongitude,
                  },
                  'radius': _biasRadiusMeters,
                },
              },
          }),
        )
        .timeout(_timeout);
    final body = _decode(response);

    final suggestions = <PlaceSuggestion>[];
    for (final entry in (body['suggestions'] as List<dynamic>? ?? const [])) {
      final prediction = (entry as Map<String, dynamic>)['placePrediction'];
      if (prediction is! Map<String, dynamic>) continue;
      final placeId = prediction['placeId'] as String?;
      final format = prediction['structuredFormat'] as Map<String, dynamic>?;
      final title =
          _text(format?['mainText']) ?? _text(prediction['text']) ?? '';
      if (placeId == null || title.isEmpty) continue;
      suggestions.add(
        PlaceSuggestion(
          placeId: placeId,
          title: title,
          subtitle: _text(format?['secondaryText']) ?? '',
        ),
      );
    }
    return suggestions;
  }

  Future<PlaceLocation> fetchLocation(String placeId) async {
    _requireKey();
    final token = _sessionToken;
    // A details call ends the billing session; the next search starts anew.
    _sessionToken = null;
    final uri = Uri.parse('$_baseUrl/places/$placeId').replace(
      queryParameters: {
        'languageCode': _language,
        if (token != null) 'sessionToken': token,
      },
    );
    final response = await _client
        .get(
          uri,
          headers: {
            'X-Goog-Api-Key': _apiKey,
            'X-Goog-FieldMask': 'location,formattedAddress',
          },
        )
        .timeout(_timeout);
    final body = _decode(response);

    final location = body['location'] as Map<String, dynamic>?;
    final latitude = (location?['latitude'] as num?)?.toDouble();
    final longitude = (location?['longitude'] as num?)?.toDouble();
    if (latitude == null || longitude == null) {
      throw const PlacesRemoteException('El lugar no tiene coordenadas');
    }
    return PlaceLocation(
      latitude: latitude,
      longitude: longitude,
      address: body['formattedAddress'] as String? ?? '',
    );
  }

  void _requireKey() {
    if (_apiKey.isEmpty) {
      throw const PlacesRemoteException(
        'Falta MAPS_API_KEY (--dart-define) para buscar direcciones',
      );
    }
  }

  Map<String, dynamic> _decode(http.Response response) {
    Map<String, dynamic> body = const {};
    try {
      final decoded = jsonDecode(utf8.decode(response.bodyBytes));
      if (decoded is Map<String, dynamic>) body = decoded;
    } on FormatException {
      // Non-JSON body (proxy/HTML error page): the status check below
      // reports it.
    }
    if (response.statusCode != 200) {
      final error = body['error'];
      final message = error is Map<String, dynamic>
          ? error['message'] as String?
          : null;
      throw PlacesRemoteException(
        message ?? 'Google Places respondió ${response.statusCode}',
      );
    }
    return body;
  }

  String? _text(Object? node) =>
      node is Map<String, dynamic> ? node['text'] as String? : null;
}

class PlacesRemoteException implements Exception {
  const PlacesRemoteException(this.message);

  final String message;

  @override
  String toString() => 'PlacesRemoteException: $message';
}
