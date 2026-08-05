class ExploreLocationDetails {
  const ExploreLocationDetails({
    this.address,
    this.displayAddress,
    this.city,
    this.country,
    this.latitude,
    this.longitude,
    this.venueName,
  });

  final String? address;
  final String? displayAddress;
  final String? city;
  final String? country;
  final double? latitude;
  final double? longitude;
  final String? venueName;

  String get displayLocation {
    for (final value in [venueName, displayAddress, address, city, country]) {
      final trimmed = value?.trim();
      if (trimmed != null && trimmed.isNotEmpty) return trimmed;
    }
    return '--';
  }
}
