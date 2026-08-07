import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:kuemele/core/app_config.dart';

class LocationServiceException implements Exception {
  final String message;
  const LocationServiceException(this.message);

  @override
  String toString() => 'LocationServiceException: $message';
}

class UserCoordinates {
  final double latitude;
  final double longitude;
  final String? city;
  final String? country;

  const UserCoordinates({
    required this.latitude,
    required this.longitude,
    this.city,
    this.country,
  });

  @override
  String toString() => 'UserCoordinates(latitude: $latitude, '
      'longitude: $longitude, city: $city, country: $country)';
}

class LocationService {
  Future<UserCoordinates> getCurrentLocation() async {
    final isServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isServiceEnabled) {
      throw const LocationServiceException('Location services are disabled.');
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw const LocationServiceException(
            'Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw const LocationServiceException(
        'Location permissions are permanently denied. We cannot request permissions.',
      );
    }

    try {
      final Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      final place = await _reverseGeocode(
        latitude: position.latitude,
        longitude: position.longitude,
      );

      return UserCoordinates(
        latitude: position.latitude,
        longitude: position.longitude,
        city: place.$1,
        country: place.$2,
      );
    } catch (e) {
      throw LocationServiceException('Failed to get current location: $e');
    }
  }

  Future<(String?, String?)> _reverseGeocode({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final uri = Uri.https(
        'nominatim.openstreetmap.org',
        '/reverse',
        {
          'format': 'json',
          'lat': '$latitude',
          'lon': '$longitude',
          'zoom': '10',
          'addressdetails': '1',
        },
      );
      final response = await http.get(
        uri,
        headers: {'User-Agent': AppConfig.defaultUserAgent},
      ).timeout(const Duration(seconds: 4));
      if (response.statusCode < 200 || response.statusCode >= 300) {
        return (null, null);
      }

      final json = jsonDecode(response.body);
      if (json is! Map) return (null, null);
      final address = json['address'];
      if (address is! Map) return (null, null);

      final city = address['city'] ??
          address['town'] ??
          address['village'] ??
          address['municipality'] ??
          address['county'] ??
          address['state'];
      final country = address['country'];
      return (city?.toString(), country?.toString());
    } catch (_) {
      return (null, null);
    }
  }
}
