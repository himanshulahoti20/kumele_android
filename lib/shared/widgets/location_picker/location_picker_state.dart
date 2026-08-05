import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';

class LocationPickerState extends Equatable {
  final LatLng centre;
  final String address;
  final bool isGeocoding;
  final bool isLocating;
  final LatLng? mapTargetMove;
  final String? errorMessage;

  const LocationPickerState({
    required this.centre,
    required this.address,
    this.isGeocoding = false,
    this.isLocating = false,
    this.mapTargetMove,
    this.errorMessage,
  });

  LocationPickerState copyWith({
    LatLng? centre,
    String? address,
    bool? isGeocoding,
    bool? isLocating,
    LatLng? mapTargetMove,
    String? errorMessage,
    bool clearMapTargetMove = false,
    bool clearError = false,
  }) {
    return LocationPickerState(
      centre: centre ?? this.centre,
      address: address ?? this.address,
      isGeocoding: isGeocoding ?? this.isGeocoding,
      isLocating: isLocating ?? this.isLocating,
      mapTargetMove:
          clearMapTargetMove ? null : (mapTargetMove ?? this.mapTargetMove),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props =>
      [centre, address, isGeocoding, isLocating, mapTargetMove, errorMessage];
}
