/// Result of `POST /events/audience-estimate` — an estimate of how many
/// users are reachable for the event's current location + guest count.
/// [basis] is `"coordinates"` (a real radius search, when lat/lng were
/// sent), `"city"`/`"country"` (coarser fallback), or `"none"` (nothing
/// usable was sent). [confidence] reflects how much of the user base has
/// a saved location at all, not how precise this one estimate is.
class AudienceEstimateResult {
  const AudienceEstimateResult({
    required this.estimatedAvailable,
    required this.enoughForGuests,
    required this.guests,
    required this.radiusKm,
    required this.basis,
    required this.confidence,
    required this.locationCoverage,
    required this.message,
  });

  final int estimatedAvailable;
  final bool enoughForGuests;
  final int guests;
  final num radiusKm;
  final String basis;
  final String confidence;
  final double locationCoverage;
  final String message;

  factory AudienceEstimateResult.fromJson(Map<String, dynamic> json) {
    return AudienceEstimateResult(
      estimatedAvailable: (json['estimatedAvailable'] as num?)?.toInt() ?? 0,
      enoughForGuests: json['enoughForGuests'] == true,
      guests: (json['guests'] as num?)?.toInt() ?? 0,
      radiusKm: (json['radiusKm'] as num?) ?? 0,
      basis: (json['basis'] ?? 'none').toString(),
      confidence: (json['confidence'] ?? '').toString(),
      locationCoverage: (json['locationCoverage'] as num?)?.toDouble() ?? 0,
      message: (json['message'] ?? '').toString(),
    );
  }
}
