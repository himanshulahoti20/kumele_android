/// Result of `POST /events/availability-check` for a single checked user.
class AvailabilityConflict {
  const AvailabilityConflict({
    required this.available,
    this.eventTitle,
  });

  final bool available;
  final String? eventTitle;

  factory AvailabilityConflict.fromJson(Map<String, dynamic> json) {
    final available = json['available'] ?? json['isAvailable'];
    final conflict = json['conflictingEvent'] ?? json['conflict'] ?? json['event'];
    final title = conflict is Map
        ? (conflict['title'] ?? conflict['name'])?.toString()
        : null;
    return AvailabilityConflict(
      available: available is bool ? available : conflict == null,
      eventTitle: title,
    );
  }
}

class AvailabilityCheckResult {
  const AvailabilityCheckResult({required this.conflicts});

  final List<AvailabilityConflict> conflicts;

  bool get hasConflict => conflicts.any((c) => !c.available);

  String? get firstConflictTitle => conflicts
      .firstWhere((c) => !c.available, orElse: () => conflicts.first)
      .eventTitle;

  factory AvailabilityCheckResult.fromResponse(dynamic response) {
    final list = response is List
        ? response
        : response is Map
            ? (response['results'] ?? response['availability'] ?? response['users'] ?? [response])
            : const [];
    final items = (list is List ? list : const [])
        .whereType<Map>()
        .map((item) => AvailabilityConflict.fromJson(item.cast<String, dynamic>()))
        .toList();
    return AvailabilityCheckResult(conflicts: items);
  }
}
