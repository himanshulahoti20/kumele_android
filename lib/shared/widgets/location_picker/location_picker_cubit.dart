import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kuemele/core/map_config.dart';
import 'package:kuemele/l10n/app_localizations_en.dart';
import 'package:kuemele/shared/services/location_service.dart';
import 'package:kuemele/shared/widgets/location_picker/location_picker_state.dart';
import 'package:latlong2/latlong.dart';

class LocationPickerCubit extends Cubit<LocationPickerState> {
  final LocationService _locationService;
  final Dio _dio;
  Timer? _debounce;

  LocationPickerCubit({
    required LocationService locationService,
    LatLng? initialCentre,
    String? initialAddress,
    Dio? dio,
  })  : _locationService = locationService,
        _dio = dio ?? Dio(),
        super(LocationPickerState(
          centre: initialCentre ??
              const LatLng(
                  MapConfig.defaultLatitude, MapConfig.defaultLongitude),
          address: initialAddress ?? AppLocalizationsEn().moveMapToPickLocation,
        ));

  void setInitialLocation({
    required LatLng initialCentre,
    String? initialAddress,
  }) {
    emit(LocationPickerState(
      centre: initialCentre,
      address: initialAddress ?? AppLocalizationsEn().moveMapToPickLocation,
    ));
    if (initialAddress == null) {
      _initUserLocation();
    }
  }

  void initializeLocation() {
    _initUserLocation();
  }

  void onMapMoved(LatLng newCentre) {
    emit(state.copyWith(
      centre: newCentre,
      address: AppLocalizationsEn().searching,
      clearError: true,
    ));

    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _reverseGeocode(newCentre);
    });
  }

  void onMapTargetMoveCompleted() {
    emit(state.copyWith(clearMapTargetMove: true));
  }

  void onErrorShown() {
    emit(state.copyWith(clearError: true));
  }

  Future<void> goToMyLocation() async {
    emit(state.copyWith(isLocating: true, clearError: true));
    try {
      final coordinates = await _locationService.getCurrentLocation();
      final point = LatLng(coordinates.latitude, coordinates.longitude);

      emit(state.copyWith(
        centre: point,
        isLocating: false,
        mapTargetMove: point,
      ));

      await _reverseGeocode(point);
    } on LocationServiceException catch (e) {
      emit(state.copyWith(
        isLocating: false,
        errorMessage: e.message,
      ));
    } catch (_) {
      emit(state.copyWith(
        isLocating: false,
        errorMessage: AppLocalizationsEn().somethingWentWrong,
      ));
    }
  }

  Future<void> _initUserLocation() async {
    try {
      final coordinates = await _locationService.getCurrentLocation();
      final point = LatLng(coordinates.latitude, coordinates.longitude);

      emit(state.copyWith(
        centre: point,
        mapTargetMove: point,
      ));

      await _reverseGeocode(point);
    } catch (_) {
      // Gracefully fall back to pre-configured defaults
    }
  }

  Future<void> _reverseGeocode(LatLng point) async {
    emit(state.copyWith(isGeocoding: true));
    try {
      final url = '${MapConfig.nominatimReverseUrl}'
          '?format=json&lat=${point.latitude}&lon=${point.longitude}&zoom=17&addressdetails=1';

      final response = await _dio.get(
        url,
        options: Options(
          headers: {
            'Accept-Language': 'en',
            'User-Agent': MapConfig.nominatimUserAgent,
          },
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        final display = data['display_name'] as String? ?? '';

        emit(state.copyWith(
          isGeocoding: false,
          address: display.isEmpty ? AppLocalizationsEn().unknownLocation : display,
        ));
      } else {
        emit(state.copyWith(
          isGeocoding: false,
          address: AppLocalizationsEn().couldNotFetchAddress,
        ));
      }
    } catch (_) {
      emit(state.copyWith(
        isGeocoding: false,
        address: AppLocalizationsEn().couldNotFetchAddress,
      ));
    }
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
