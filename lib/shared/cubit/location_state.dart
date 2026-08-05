import 'package:kuemele/shared/services/location_service.dart';

export 'location_cubit.dart';

enum LocationStatus {
  initial,
  loading,
  granted,
  denied,
  permanentlyDenied,
  serviceDisabled,
}

class LocationState {
  final LocationStatus status;
  final UserCoordinates? coordinates;

  const LocationState({
    this.status = LocationStatus.initial,
    this.coordinates,
  });

  bool get isGranted => status == LocationStatus.granted;

  bool get isDenied =>
      status == LocationStatus.denied ||
      status == LocationStatus.permanentlyDenied ||
      status == LocationStatus.serviceDisabled;

  LocationState copyWith({
    LocationStatus? status,
    UserCoordinates? coordinates,
  }) {
    return LocationState(
      status: status ?? this.status,
      coordinates: coordinates ?? this.coordinates,
    );
  }
}
