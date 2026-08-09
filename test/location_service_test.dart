import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:kuemele/shared/services/location_service.dart';

/// Behaviour of the fake platform's `getCurrentPosition` per accuracy tier.
enum FixBehavior {
  /// Return a configured [Position].
  success,

  /// Throw a `TimeoutException` (no fix within the native time limit).
  timeout,

  /// Throw a generic provider error.
  error,
}

class FakeGeolocatorPlatform extends GeolocatorPlatform {
  FakeGeolocatorPlatform({
    this.lastKnown,
    this.highPosition,
    this.lowPosition,
    this.highAccuracy = FixBehavior.success,
    this.lowAccuracy = FixBehavior.success,
  });

  Position? lastKnown;
  Position? highPosition;
  Position? lowPosition;
  FixBehavior highAccuracy;
  FixBehavior lowAccuracy;
  int highAccuracyCalls = 0;
  int lowAccuracyCalls = 0;

  @override
  Future<bool> isLocationServiceEnabled() async => true;

  @override
  Future<LocationPermission> checkPermission() async =>
      LocationPermission.always;

  @override
  Future<LocationPermission> requestPermission() async =>
      LocationPermission.always;

  @override
  Future<Position?> getLastKnownPosition({
    bool forceLocationManager = false,
  }) async =>
      lastKnown;

  @override
  Future<Position> getCurrentPosition({
    LocationSettings? locationSettings,
  }) {
    final settings = locationSettings;
    final isHigh =
        settings == null || settings.accuracy == LocationAccuracy.high;
    if (isHigh) {
      highAccuracyCalls++;
      return _resolve(highAccuracy, highPosition);
    }
    lowAccuracyCalls++;
    return _resolve(lowAccuracy, lowPosition);
  }

  Future<Position> _resolve(FixBehavior behavior, Position? position) {
    switch (behavior) {
      case FixBehavior.success:
        if (position == null) {
          return Future.error(
            StateError('No position configured for this accuracy tier'),
          );
        }
        return Future.value(position);
      case FixBehavior.timeout:
        return Future.error(TimeoutException('No fix within time limit'));
      case FixBehavior.error:
        return Future.error(Exception('Transient provider error'));
    }
  }
}

Position _position({
  required double latitude,
  required double longitude,
  DateTime? timestamp,
}) {
  return Position(
    longitude: longitude,
    latitude: latitude,
    timestamp: timestamp ?? DateTime.now(),
    accuracy: 5.0,
    altitude: 0.0,
    altitudeAccuracy: 0.0,
    heading: 0.0,
    headingAccuracy: 0.0,
    speed: 0.0,
    speedAccuracy: 0.0,
  );
}

LocationService _service(FakeGeolocatorPlatform platform) {
  GeolocatorPlatform.instance = platform;
  return LocationService(httpClient: _geocodingClient());
}

http.Client _geocodingClient() {
  return MockClient((request) async {
    expect(request.url.path, '/reverse');
    return http.Response(
      jsonEncode({
        'address': {'city': 'Berlin', 'country': 'Germany'},
      }),
      200,
      headers: {'content-type': 'application/json; charset=utf-8'},
    );
  });
}

void main() {
  test('uses a fresh cached position without requesting a new fix', () async {
    final platform = FakeGeolocatorPlatform(
      lastKnown: _position(latitude: 52.52, longitude: 13.405),
      highAccuracy: FixBehavior.timeout,
      lowAccuracy: FixBehavior.timeout,
    );
    final service = _service(platform);

    final result = await service.getCurrentLocation();

    expect(result.latitude, 52.52);
    expect(result.longitude, 13.405);
    expect(result.city, 'Berlin');
    expect(result.country, 'Germany');
    expect(platform.highAccuracyCalls, 0);
    expect(platform.lowAccuracyCalls, 0);
  });

  test('falls back to low accuracy when the high-accuracy fix times out',
      () async {
    final platform = FakeGeolocatorPlatform(
      highAccuracy: FixBehavior.timeout,
      highPosition: _position(latitude: 52.52, longitude: 13.405),
      lowAccuracy: FixBehavior.success,
      lowPosition: _position(latitude: 48.13, longitude: 11.57),
    );
    final service = _service(platform);

    final result = await service.getCurrentLocation();

    expect(result.latitude, 48.13);
    expect(result.longitude, 11.57);
    expect(platform.highAccuracyCalls, 1);
    expect(platform.lowAccuracyCalls, 1);
  });

  test('falls back to low accuracy on any high-accuracy provider error',
      () async {
    final platform = FakeGeolocatorPlatform(
      highAccuracy: FixBehavior.error,
      lowAccuracy: FixBehavior.success,
      lowPosition: _position(latitude: 40.71, longitude: -74.01),
    );
    final service = _service(platform);

    final result = await service.getCurrentLocation();

    expect(result.latitude, 40.71);
    expect(platform.highAccuracyCalls, 1);
    expect(platform.lowAccuracyCalls, 1);
  });

  test('uses a stale cached position when no fresh fix is available', () async {
    final platform = FakeGeolocatorPlatform(
      lastKnown: _position(
        latitude: 51.5,
        longitude: -0.12,
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      highAccuracy: FixBehavior.timeout,
      lowAccuracy: FixBehavior.timeout,
    );
    final service = _service(platform);

    final result = await service.getCurrentLocation();

    expect(result.latitude, 51.5);
    expect(result.longitude, -0.12);
    expect(platform.highAccuracyCalls, 1);
    expect(platform.lowAccuracyCalls, 1);
  });

  test('throws LocationServiceException, never a raw TimeoutException',
      () async {
    final platform = FakeGeolocatorPlatform(
      highAccuracy: FixBehavior.timeout,
      lowAccuracy: FixBehavior.timeout,
    );
    final service = _service(platform);

    await expectLater(
      service.getCurrentLocation(),
      throwsA(isA<LocationServiceException>()),
    );
  });

  test('reports null city/country when reverse geocoding fails', () async {
    final platform = FakeGeolocatorPlatform(
      lowAccuracy: FixBehavior.success,
      lowPosition: _position(latitude: 48.13, longitude: 11.57),
    );
    GeolocatorPlatform.instance = platform;
    final client = MockClient(
      (request) async => http.Response('server error', 500),
    );
    final service = LocationService(httpClient: client);

    final result = await service.getCurrentLocation();

    expect(result.latitude, 48.13);
    expect(result.city, isNull);
    expect(result.country, isNull);
  });
}
