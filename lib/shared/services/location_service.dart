import 'dart:convert';
import 'dart:async';

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
  LocationService({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  final http.Client _httpClient;

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
      final position = await _getBestAvailablePosition();

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
    } on LocationServiceException {
      rethrow;
    } catch (e) {
      throw LocationServiceException('Failed to get current location: $e');
    }
  }

  static const Duration _positionFreshnessWindow = Duration(minutes: 15);
  static const Duration _highAccuracyTimeout = Duration(seconds: 8);
  static const Duration _lowAccuracyTimeout = Duration(seconds: 6);

  /// Acquires a position using a layered fallback strategy so that a single
  /// slow provider (e.g. no GPS fix indoors or on an emulator) does not make
  /// the whole request fail:
  ///
  ///   1. a recent cached position (instant),
  ///   2. a fresh high-accuracy fix (GPS + network),
  ///   3. a low-accuracy / network fix (much faster to satisfy),
  ///   4. any cached position, even a stale one.
  ///
  /// Throws a [LocationServiceException] only when nothing at all is
  /// available.
  Future<Position> _getBestAvailablePosition() async {
    final lastKnown = await Geolocator.getLastKnownPosition();
    if (lastKnown != null && _isFresh(lastKnown.timestamp)) {
      return lastKnown;
    }

    try {
      return await _getCurrentPosition(
        accuracy: LocationAccuracy.high,
        timeLimit: _highAccuracyTimeout,
      );
    } on TimeoutException {
      // No high-accuracy fix within the limit – fall back.
    } catch (_) {
      // Transient provider error – fall back.
    }

    try {
      return await _getCurrentPosition(
        accuracy: LocationAccuracy.low,
        timeLimit: _lowAccuracyTimeout,
      );
    } on TimeoutException {
      // Still no fresh fix – use whatever is cached below.
    } catch (_) {
      // Same.
    }

    if (lastKnown != null) {
      return lastKnown;
    }

    throw const LocationServiceException(
      "We couldn't determine your location right now. Please move to an open "
      'area and make sure GPS or Wi-Fi location is enabled, then try again.',
    );
  }

  Future<Position> _getCurrentPosition({
    required LocationAccuracy accuracy,
    required Duration timeLimit,
  }) {
    return Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(
        accuracy: accuracy,
        timeLimit: timeLimit,
      ),
    );
  }

  bool _isFresh(DateTime timestamp) {
    return DateTime.now().difference(timestamp).abs() <=
        _positionFreshnessWindow;
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
      final response = await _httpClient.get(
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
