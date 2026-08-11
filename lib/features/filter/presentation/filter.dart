import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:kuemele/core/app_config.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/features/home/cubit/event_search_filters.dart';
import 'package:kuemele/l10n/app_localizations.dart';
import 'package:kuemele/shared/base/base_page.dart';
import 'package:kuemele/shared/components/app_button.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/icons.dart';
import 'package:kuemele/shared/components/kumele_text_field.dart';
import 'package:kuemele/shared/components/limiter.dart';
import 'package:kuemele/shared/components/size.dart';
import 'package:kuemele/shared/components/switch.dart';
import 'package:kuemele/shared/utils/device_utils.dart';
import 'package:kuemele/shared/widgets/mobile_header.dart';
import 'package:kuemele/shared/widgets/widget_by_device.dart';

class Filter extends StatefulWidget implements BasePage {
  const Filter({super.key});

  @override
  State<Filter> createState() => _FilterState();

  @override
  String get screenName => 'Filter';
}

class _FilterState extends State<Filter> {
  final _street = TextEditingController();
  final _number = TextEditingController();
  final _district = TextEditingController();
  final _state = TextEditingController();
  final _country = TextEditingController();
  final _postalCode = TextEditingController();

  int _distanceStart = 18;
  int _distanceEnd = 28;
  int _ageStart = 18;
  int _ageEnd = 28;
  bool _paidOnly = false;
  double? _latitude;
  double? _longitude;
  String? _locationError;
  bool _isLocating = false;

  @override
  void initState() {
    super.initState();
    final filters = InjectionHelper.homePageCubit.state.eventFilters;
    if (filters == null) return;
    _district.text = filters.city ?? '';
    _latitude = filters.centerLat;
    _longitude = filters.centerLon;
    final radius = filters.radiusKm?.round();
    if (radius != null) _distanceEnd = radius.clamp(1, 100);
    _ageStart = filters.minimumAge;
    _ageEnd = filters.maximumAge;
    _paidOnly = filters.paidOnly == true;
  }

  @override
  void dispose() {
    _street.dispose();
    _number.dispose();
    _district.dispose();
    _state.dispose();
    _country.dispose();
    _postalCode.dispose();
    super.dispose();
  }

  String get _address {
    final parts = [
      _street.text,
      _number.text,
      _district.text,
      _state.text,
      _country.text,
      _postalCode.text,
    ].map((value) => value.trim()).where((value) => value.isNotEmpty);
    return parts.isEmpty ? 'Choose a location' : parts.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return WidgetByDevice(
      tablet: _buildTablet(context),
      phone: Scaffold(
        backgroundColor: ColorSet.bg3Color,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Column(
              children: [
                MobileHeader(label: AppLocalizations.of(context)!.filterTitle),
                const Gap(22),
                Expanded(child: SingleChildScrollView(child: _buildContent())),
                _buildButtonApply(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTablet(BuildContext context) {
    return Center(
      child: Container(
        height: 580,
        width: 600,
        padding: const EdgeInsets.fromLTRB(40, 30, 40, 30),
        decoration: BoxDecoration(
          color: ColorSet.bg3Color,
          borderRadius: BorderRadius.circular(size(19)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Gap(29),
                Text(AppLocalizations.of(context)!.filterTitle,
                    style: context.textTheme.titleLargeBold),
                GestureDetector(
                  onTap: () => Navigator.of(context).maybePop(),
                  child: Image.asset(IconSet.closeIcon, width: 29, height: 29),
                ),
              ],
            ),
            const Gap(40),
            Expanded(child: SingleChildScrollView(child: _buildContent())),
            const Gap(15),
            _buildButtonApply(),
          ],
        ),
      ),
    );
  }

  Widget _buildButtonApply() {
    return Align(
      alignment: Alignment.centerRight,
      child: AppButton.primary(
        onPressed: _apply,
        label: AppLocalizations.of(context)!.paymentApplyLabel,
      ),
    );
  }

  Widget _buildContent() {
    final horizontalPadding = FormFactor.isTablet ? 48.0 : 20.0;
    final sectionColor = FormFactor.isTablet ? ColorSet.tileFillColor : null;
    return Column(
      spacing: 15,
      children: [
        Container(
          padding:
              EdgeInsets.symmetric(vertical: 13, horizontal: horizontalPadding),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(size(10)),
            color: sectionColor,
          ),
          child: Column(
            spacing: 14,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(AppLocalizations.of(context)!.currentLocation,
                      style: context.textTheme.bodyLarge),
                  GestureDetector(
                    onTap: _showLocationEditor,
                    child: Text(
                      AppLocalizations.of(context)!.change,
                      style: context.textTheme.bodyLargeBold.copyWith(
                        color: ColorSet.specialYellowColor,
                      ),
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: _showLocationEditor,
                child: Row(
                  children: [
                    Image.asset(IconSet.location,
                        width: 20, height: 20, color: ColorSet.textColor),
                    const Gap(10),
                    Expanded(
                      child: Text(_address, style: context.textTheme.bodyLarge),
                    ),
                    Icon(
                      _latitude == null ? Icons.chevron_right : Icons.check,
                      color: _latitude == null
                          ? ColorSet.color525252
                          : ColorSet.snackBarSuccessBg,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          padding:
              EdgeInsets.symmetric(vertical: 13, horizontal: horizontalPadding),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(size(10)),
            color: sectionColor,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppLocalizations.of(context)!.distanceRangeLabel,
                  style: context.textTheme.bodyLarge),
              const Gap(20),
              RALimiter(
                min: 1,
                max: 100,
                initialStart: _distanceStart,
                initialEnd: _distanceEnd,
                bgWidth: 500,
                onChanged: (start, end) {
                  _distanceStart = start;
                  _distanceEnd = end;
                },
              ),
              const Gap(20),
              Text(AppLocalizations.of(context)!.ageRangeLabel,
                  style: context.textTheme.bodyMedium.copyWith(fontSize: 14)),
              const Gap(20),
              RALimiter(
                min: 18,
                max: 70,
                initialStart: _ageStart,
                initialEnd: _ageEnd,
                bgWidth: 500,
                onChanged: (start, end) {
                  _ageStart = start;
                  _ageEnd = end;
                },
              ),
              const Gap(20),
              Row(
                children: [
                  Text(AppLocalizations.of(context)!.paidEvent,
                      style: context.textTheme.bodyMedium),
                  const Spacer(),
                  RASwitch(
                    value: _paidOnly,
                    onTap: () => setState(() => _paidOnly = !_paidOnly),
                    size: Size(size(25), size(18)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _apply() {
    InjectionHelper.homePageCubit.applyEventFilters(
      EventSearchFilters(
        city: _district.text.trim().isEmpty ? null : _district.text.trim(),
        address: _address == 'Choose a location' ? null : _address,
        centerLat: _latitude,
        centerLon: _longitude,
        radiusKm:
            _latitude == null || _longitude == null ? null : _distanceEnd + .0,
        minimumAge: _ageStart,
        maximumAge: _ageEnd,
        paidOnly: _paidOnly ? true : null,
      ),
    );
    Navigator.of(context).maybePop();
  }

  Future<void> _showLocationEditor() async {
    _locationError = null;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: ColorSet.bg3Color,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppButton.primary(
                      label: 'Use Current Location',
                      isLoading: _isLocating,
                      onPressed: _isLocating
                          ? null
                          : () => _useCurrentLocation(sheetContext,
                              setModalState: setModalState),
                    ),
                    const Gap(18),
                    Text('OR ENTER AN ADDRESS',
                        textAlign: TextAlign.center,
                        style: context.textTheme.bodySmall),
                    const Gap(18),
                    _field(_street, 'Street'),
                    _field(_number, 'Number'),
                    _field(_district, 'District / City'),
                    _field(_state, AppLocalizations.of(context)!.stateHint),
                    _field(_country, AppLocalizations.of(context)!.countryHint),
                    _field(_postalCode,
                        AppLocalizations.of(context)!.postalZipCodeHint),
                    if (_locationError != null) ...[
                      const Gap(8),
                      Text(_locationError!,
                          style: context.textTheme.bodySmall
                              .copyWith(color: Colors.red)),
                      if (_locationError!.toLowerCase().contains('permanent'))
                        TextButton(
                          onPressed: Geolocator.openAppSettings,
                          child: const Text('Open Settings'),
                        ),
                    ],
                    const Gap(14),
                    AppButton.primary(
                      label: 'Save Location',
                      onPressed: () => _saveManualLocation(sheetContext,
                          setModalState: setModalState),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _field(TextEditingController controller, String hint) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: KumeleTextField(
        controller: controller,
        hintText: hint,
        fillColor: ColorSet.tileFillColor,
        borderRadius: 5,
      ),
    );
  }

  Future<void> _useCurrentLocation(
    BuildContext sheetContext, {
    required StateSetter setModalState,
  }) async {
    var closed = false;
    setModalState(() {
      _isLocating = true;
      _locationError = null;
    });
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        throw 'Location services are disabled.';
      }
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied) {
        throw 'Location permission denied.';
      }
      if (permission == LocationPermission.deniedForever) {
        throw 'Location permission permanently denied.';
      }

      final position = await Geolocator.getCurrentPosition();
      final place =
          await _reverseGeocode(position.latitude, position.longitude);
      _fillFromPlace(place);
      setState(() {
        _latitude = position.latitude;
        _longitude = position.longitude;
      });
      if (sheetContext.mounted) {
        closed = true;
        Navigator.of(sheetContext).pop();
      }
    } catch (e) {
      setModalState(() => _locationError = e.toString());
    } finally {
      if (mounted && !closed) {
        setModalState(() => _isLocating = false);
      }
    }
  }

  Future<void> _saveManualLocation(
    BuildContext sheetContext, {
    required StateSetter setModalState,
  }) async {
    setModalState(() => _locationError = null);
    try {
      final place = await _geocode(_address);
      if (place == null) throw 'Could not geocode this address.';
      _fillFromPlace(place);
      setState(() {
        _latitude = place.latitude;
        _longitude = place.longitude;
      });
      if (sheetContext.mounted) Navigator.of(sheetContext).pop();
    } catch (e) {
      setModalState(() => _locationError = e.toString());
    }
  }

  void _fillFromPlace(_Place place) {
    _street.text = place.street ?? _street.text;
    _number.text = place.number ?? _number.text;
    _district.text = place.city ?? _district.text;
    _state.text = place.state ?? _state.text;
    _country.text = place.country ?? _country.text;
    _postalCode.text = place.postalCode ?? _postalCode.text;
  }

  Future<_Place> _reverseGeocode(double latitude, double longitude) async {
    final uri = Uri.https('nominatim.openstreetmap.org', '/reverse', {
      'format': 'json',
      'lat': '$latitude',
      'lon': '$longitude',
      'zoom': '17',
      'addressdetails': '1',
    });
    final json = await _getJson(uri);
    if (json is! Map) throw 'Location lookup failed.';
    return _Place.fromJson(
      Map<String, dynamic>.from(json),
      latitude: latitude,
      longitude: longitude,
    );
  }

  Future<_Place?> _geocode(String address) async {
    final trimmed = address.trim();
    if (trimmed.isEmpty || trimmed == 'Choose a location') {
      throw 'Enter an address first.';
    }
    final uri = Uri.https('nominatim.openstreetmap.org', '/search', {
      'format': 'json',
      'q': trimmed,
      'limit': '1',
      'addressdetails': '1',
    });
    final json = await _getJson(uri);
    if (json is! List || json.isEmpty || json.first is! Map) return null;
    final item = Map<String, dynamic>.from(json.first as Map);
    return _Place.fromJson(
      item,
      latitude: double.tryParse(item['lat']?.toString() ?? ''),
      longitude: double.tryParse(item['lon']?.toString() ?? ''),
    );
  }

  Future<dynamic> _getJson(Uri uri) async {
    final response = await http.get(
      uri,
      headers: {'User-Agent': AppConfig.defaultUserAgent},
    ).timeout(const Duration(seconds: 8));
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw 'Location lookup failed.';
    }
    return jsonDecode(response.body);
  }
}

class _Place {
  const _Place({
    this.latitude,
    this.longitude,
    this.street,
    this.number,
    this.city,
    this.state,
    this.country,
    this.postalCode,
  });

  final double? latitude;
  final double? longitude;
  final String? street;
  final String? number;
  final String? city;
  final String? state;
  final String? country;
  final String? postalCode;

  factory _Place.fromJson(
    Map<String, dynamic> json, {
    double? latitude,
    double? longitude,
  }) {
    final address = json['address'] is Map
        ? Map<String, dynamic>.from(json['address'] as Map)
        : <String, dynamic>{};
    return _Place(
      latitude: latitude,
      longitude: longitude,
      street: _text(address['road'] ?? address['pedestrian']),
      number: _text(address['house_number']),
      city: _text(address['city'] ??
          address['town'] ??
          address['village'] ??
          address['municipality'] ??
          address['county']),
      state: _text(address['state']),
      country: _text(address['country']),
      postalCode: _text(address['postcode']),
    );
  }

  static String? _text(dynamic value) {
    final text = value?.toString().trim();
    return text == null || text.isEmpty ? null : text;
  }
}
