import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
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
  bool _manualLocationEnabled = false;

  /// Free-tier users can't pick a custom search location — the "Change"
  /// toggle is locked off and the filter always searches from the device's
  /// current location instead.
  bool get _canChangeLocation =>
      InjectionHelper.profileCubit.entitlements.unlimitedLocationChange;

  /// Whether the Country/Postal/State fields are editable: entitled *and*
  /// the user has flipped the location-change switch on.
  bool get _fieldsEditable => _canChangeLocation && _manualLocationEnabled;

  @override
  void initState() {
    super.initState();
    final filters = InjectionHelper.homePageCubit.state.eventFilters;
    final hasSavedLocation =
        _canChangeLocation && filters != null && filters.hasLocation;

    if (hasSavedLocation) {
      _manualLocationEnabled = true;
      _district.text = filters.city ?? '';
      _latitude = filters.centerLat;
      _longitude = filters.centerLon;
    } else {
      _useCurrentLocationAsDefault();
    }

    if (filters == null) return;
    final radius = filters.radiusKm?.round();
    if (radius != null) _distanceEnd = radius.clamp(1, 100);
    _ageStart = filters.minimumAge;
    _ageEnd = filters.maximumAge;
    _paidOnly = filters.paidOnly == true;
  }

  void _useCurrentLocationAsDefault() {
    final coords = InjectionHelper.locationCubit.state.coordinates;
    final user = InjectionHelper.profileCubit.userData;
    _latitude = coords?.latitude ?? user?.latitude;
    _longitude = coords?.longitude ?? user?.longitude;
    _district.text = coords?.city ?? user?.city ?? '';
  }

  /// The location-change switch: locked (and forced off) for free-tier
  /// users. Turning it off clears any typed address and reverts to the
  /// device's current location; turning it on unlocks the Country/Postal/
  /// State fields for a custom search location.
  void _toggleManualLocation() {
    if (!_canChangeLocation) return;
    setState(() {
      _manualLocationEnabled = !_manualLocationEnabled;
      _locationError = null;
      if (_manualLocationEnabled) {
        _street.clear();
        _number.clear();
        _state.clear();
        _country.clear();
        _postalCode.clear();
        _district.clear();
        _latitude = null;
        _longitude = null;
      } else {
        _useCurrentLocationAsDefault();
      }
    });
  }

  Future<void> _geocodeManualAddress() async {
    if (!_fieldsEditable) return;
    final query = _address;
    if (query == 'Choose a location') return;
    try {
      final place = await _geocode(query);
      if (place == null) throw 'Could not geocode this address.';
      if (!mounted) return;
      _fillFromPlace(place);
      setState(() {
        _latitude = place.latitude;
        _longitude = place.longitude;
        _locationError = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _locationError = e.toString());
    }
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
    if (!_fieldsEditable) {
      final city = _district.text.trim();
      return city.isEmpty ? 'Current location' : city;
    }
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
        height: 680,
        width: 700,
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
                    onTap: _canChangeLocation ? _toggleManualLocation : null,
                    child: Text(
                      AppLocalizations.of(context)!.change,
                      style: context.textTheme.bodyLargeBold.copyWith(
                        color: _canChangeLocation
                            ? ColorSet.specialYellowColor
                            : ColorSet.color525252,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: _locationField(
                        _country, AppLocalizations.of(context)!.countryHint),
                  ),
                  const Gap(10),
                  Expanded(
                    child: _locationField(_postalCode,
                        AppLocalizations.of(context)!.postalZipCodeHint),
                  ),
                ],
              ),
              _locationField(_state, AppLocalizations.of(context)!.stateHint),
              if (_locationError != null)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(_locationError!,
                      style: context.textTheme.bodySmall
                          .copyWith(color: Colors.red)),
                ),
              Row(
                children: [
                  Image.asset(IconSet.location,
                      width: 20, height: 20, color: ColorSet.textColor),
                  const Gap(10),
                  Expanded(
                    child: Text(_address, style: context.textTheme.bodyLarge),
                  ),
                  Image.asset(
                    _latitude == null
                        ? IconSet.tickUnselected
                        : IconSet.tickSelected,
                    width: 28,
                    height: 28,
                  ),
                  const Gap(8),
                  GestureDetector(
                    onTap: _canChangeLocation ? _toggleManualLocation : null,
                    child: Image.asset(
                      _manualLocationEnabled
                          ? IconSet.switchSelected
                          : IconSet.switchUnselected,
                      width: 40,
                      height: 28,
                    ),
                  ),
                ],
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

  Widget _locationField(TextEditingController controller, String hint) {
    return KumeleTextField(
      controller: controller,
      hintText: hint,
      fillColor: ColorSet.tileFillColor,
      borderRadius: 5,
      enabled: _fieldsEditable,
      textInputAction: TextInputAction.done,
      onSubmitted: (_) => _geocodeManualAddress(),
    );
  }

  void _fillFromPlace(_Place place) {
    _street.text = place.street ?? _street.text;
    _number.text = place.number ?? _number.text;
    _district.text = place.city ?? _district.text;
    _state.text = place.state ?? _state.text;
    _country.text = place.country ?? _country.text;
    _postalCode.text = place.postalCode ?? _postalCode.text;
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
