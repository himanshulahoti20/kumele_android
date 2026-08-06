import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kuemele/features/debug_tools/debug_logger.dart';
import 'package:kuemele/shared/cubit/location_state.dart';
import 'package:kuemele/shared/services/location_service.dart';

export 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  LocationCubit({required LocationService locationService})
      : _locationService = locationService,
        super(const LocationState());

  final LocationService _locationService;
  Future<void>? _inFlightRequest;

  /// Guards against concurrent calls: this is invoked both at app startup
  /// (AppCubit.initialize, for already-logged-in users) and on the sign-in
  /// screen (for new logins), which can overlap in time. Firing two native
  /// permission requests at once makes the OS layer (Geolocator/
  /// permission_handler) throw "a request is already running", which the
  /// catch-all below previously mapped to a false "denied" state — showing
  /// Home's location-disabled view even though the user never denied
  /// anything. A second call while one is in flight just reuses it instead.
  Future<void> requestLocation() {
    return _inFlightRequest ??= _doRequestLocation().whenComplete(() {
      _inFlightRequest = null;
    });
  }

  Future<void> _doRequestLocation() async {
    emit(state.copyWith(status: LocationStatus.loading));

    try {
      final coords = await _locationService.getCurrentLocation().timeout(
            const Duration(seconds: 6),
          );
      DebugLogger.log(
        name: 'LocationService',
        log:
            'Coordinates: latitude: ${coords.latitude}, longitude: ${coords.longitude}',
      );
      emit(LocationState(
        status: LocationStatus.granted,
        coordinates: coords,
      ));
    } on TimeoutException {
      emit(const LocationState(status: LocationStatus.granted));
    } on LocationServiceException catch (e) {
      DebugLogger.errorLog(
        name: 'LocationService',
        log: 'LocationServiceException: ${e.message}',
      );
      if (e.message.contains('permanently denied')) {
        emit(state.copyWith(status: LocationStatus.permanentlyDenied));
      } else if (e.message.contains('services are disabled')) {
        emit(state.copyWith(status: LocationStatus.serviceDisabled));
      } else {
        emit(state.copyWith(status: LocationStatus.denied));
      }
    } catch (e) {
      DebugLogger.errorLog(
        name: 'LocationService',
        log: 'Unknown location error: $e',
      );
      emit(state.copyWith(status: LocationStatus.denied));
    }
  }
}
