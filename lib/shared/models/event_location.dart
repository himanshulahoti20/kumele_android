/// Represents a location selected by the user on the map.
class EventLocation {
  const EventLocation({
    required this.latitude,
    required this.longitude,
    required this.displayAddress,
  });

  final double latitude;
  final double longitude;

  /// Human-readable address returned by Nominatim reverse-geocoding.
  final String displayAddress;

  @override
  String toString() => displayAddress;
}
