import 'package:geolocator/geolocator.dart';

class LocationServiceException implements Exception {
  final String message;
  const LocationServiceException(this.message);

  @override
  String toString() => 'LocationServiceException: $message';
}

class UserCoordinates {
  final double latitude;
  final double longitude;

  const UserCoordinates({
    required this.latitude,
    required this.longitude,
  });

  @override
  String toString() =>
      'UserCoordinates(latitude: $latitude, longitude: $longitude)';
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

      return UserCoordinates(
        latitude: position.latitude,
        longitude: position.longitude,
      );
    } catch (e) {
      throw LocationServiceException('Failed to get current location: $e');
    }
  }
}
