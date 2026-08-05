class MapConfig {
  static const String osmUrlTemplate =
      'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
  static const String nominatimReverseUrl =
      'https://nominatim.openstreetmap.org/reverse';

  static const double defaultLatitude = 52.5200; // Berlin
  static const double defaultLongitude = 13.4050;
  static const double defaultZoom = 14.0;
  static const double locateZoom = 16.0;

  static const String nominatimUserAgent = 'kuemele-app/1.0';
  static const String userAgentPackageName = 'com.kuemele.app';
}
