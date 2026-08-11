class EventSearchFilters {
  const EventSearchFilters({
    this.city,
    this.address,
    this.centerLat,
    this.centerLon,
    this.radiusKm,
    required this.minimumAge,
    required this.maximumAge,
    this.paidOnly,
    this.limit = 50,
  });

  final String? city;
  final String? address;
  final double? centerLat;
  final double? centerLon;
  final double? radiusKm;
  final int minimumAge;
  final int maximumAge;
  final bool? paidOnly;
  final int limit;

  bool get hasLocation => centerLat != null && centerLon != null;
  bool get hasPaidOnly => paidOnly == true;

  String get summary {
    final parts = <String>[
      if (city != null && city!.trim().isNotEmpty) city!.trim(),
      if (hasLocation && radiusKm != null) '${radiusKm!.ceil()} km',
      '$minimumAge-$maximumAge',
      if (hasPaidOnly) 'Paid',
    ];
    return parts.join(' • ');
  }
}
