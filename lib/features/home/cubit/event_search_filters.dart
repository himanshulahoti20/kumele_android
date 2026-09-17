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

  // Matches iOS's HomeView filterSummary(_:) exactly: same field order,
  // the en dash for the age range, and the " · " separator.
  String get summary {
    final parts = <String>[
      if (city != null && city!.trim().isNotEmpty) city!.trim(),
      if (radiusKm != null) '${radiusKm!.round()} km',
      'Age $minimumAge–$maximumAge',
      if (hasPaidOnly) 'Paid',
    ];
    return parts.isEmpty ? 'Filters applied' : parts.join(' · ');
  }
}
