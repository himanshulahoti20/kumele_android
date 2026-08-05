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

  Future<void> requestLocation() async {
    emit(state.copyWith(status: LocationStatus.loading));

    try {
      final coords = await _locationService.getCurrentLocation();
      DebugLogger.log(
        name: 'LocationService',
        log:
            'Coordinates: latitude: ${coords.latitude}, longitude: ${coords.longitude}',
      );
      emit(LocationState(
        status: LocationStatus.granted,
        coordinates: coords,
      ));
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
