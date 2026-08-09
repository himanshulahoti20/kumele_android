/// Represents a location selected by the user on the map.
class EventLocation {
  const EventLocation({
    required this.latitude,
    required this.longitude,
    required this.displayAddress,
    this.street = '',
    this.homeNumber = '',
    this.district = '',
    this.postalCode = '',
    this.stateName = '',
  });

  final double latitude;
  final double longitude;

  /// Human-readable address returned by Nominatim reverse-geocoding.
  final String displayAddress;
  final String street;
  final String homeNumber;
  final String district;
  final String postalCode;
  final String stateName;

  bool get hasManualAddress =>
      street.trim().isNotEmpty ||
      homeNumber.trim().isNotEmpty ||
      district.trim().isNotEmpty ||
      postalCode.trim().isNotEmpty ||
      stateName.trim().isNotEmpty;

  bool get isComplete =>
      !hasManualAddress ||
      (street.trim().isNotEmpty &&
          district.trim().isNotEmpty &&
          postalCode.trim().isNotEmpty &&
          stateName.trim().isNotEmpty);

  @override
  String toString() => displayAddress;
}
