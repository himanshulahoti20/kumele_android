import 'package:kuemele/features/explore/data/models/explore_event_model.dart';
import 'package:kuemele/features/explore/domain/entities/explore_events_page.dart';

class ExploreEventsPageModel {
  const ExploreEventsPageModel({
    required this.events,
    required this.limit,
    this.cursor,
    this.hasNext = false,
  });

  final List<ExploreEventModel> events;
  final int limit;
  final String? cursor;
  final bool hasNext;

  factory ExploreEventsPageModel.fromResponse(dynamic response) {
    final json = _asJsonMap(response);
    final payload = _unwrapPagePayload(json);
    // /events/recommendations doesn't use the standard {ok,data} envelope —
    // its array lives under 'recommendations' (alongside advisory_only /
    // fallback_used fields), not 'data'/'items'/'events'.
    final eventsJson = payload['data'] ??
        payload['items'] ??
        payload['events'] ??
        payload['recommendations'] ??
        payload['matches'];
    final meta = _readMeta(payload, json);

    return ExploreEventsPageModel(
      events: _parseEvents(eventsJson),
      limit: _parseInt(meta['limit'], fallback: 20),
      cursor: meta['cursor']?.toString(),
      hasNext: meta['hasNext'] == true || meta['has_next'] == true,
    );
  }

  ExploreEventsPage toEntity() {
    return ExploreEventsPage(
      events: events.map((event) => event.toEntity()).toList(),
      limit: limit,
      cursor: cursor,
      hasNext: hasNext,
    );
  }

  static Map<String, dynamic> _asJsonMap(dynamic response) {
    if (response is Map<String, dynamic>) return response;
    if (response is Map) return Map<String, dynamic>.from(response);
    return {};
  }

  static Map<String, dynamic> _unwrapPagePayload(Map<String, dynamic> json) {
    final data = json['data'];
    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }
    return json;
  }

  static Map<String, dynamic> _readMeta(
    Map<String, dynamic> payload,
    Map<String, dynamic> root,
  ) {
    final meta = payload['meta'] ?? root['meta'];
    if (meta is Map<String, dynamic>) return meta;
    if (meta is Map) return Map<String, dynamic>.from(meta);
    return const {};
  }

  static List<ExploreEventModel> _parseEvents(dynamic eventsJson) {
    if (eventsJson is! List) return const [];

    return eventsJson
        .whereType<Map>()
        .map((item) => ExploreEventModel.fromJson(
              Map<String, dynamic>.from(item),
            ))
        .where((event) => event.eventId.isNotEmpty)
        .toList();
  }

  static int _parseInt(dynamic value, {required int fallback}) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? fallback;
  }
}
