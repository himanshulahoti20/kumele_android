import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/features/explore/domain/entities/explore_event_detail.dart';

/// `GET /chat/rooms` doesn't include event category or attendee count, so
/// each chat list card lazily fetches full event details via the existing
/// explore endpoint and caches the result by event id.
class ChatEventDetailsCache {
  ChatEventDetailsCache._();

  static final Map<String, ExploreEventDetail?> _cache = {};
  static final Map<String, Future<ExploreEventDetail?>> _inFlight = {};

  static ExploreEventDetail? peek(String eventId) => _cache[eventId];

  static Future<ExploreEventDetail?> load(String eventId) {
    if (_cache.containsKey(eventId)) {
      return Future.value(_cache[eventId]);
    }
    return _inFlight[eventId] ??= _fetch(eventId);
  }

  static Future<ExploreEventDetail?> _fetch(String eventId) async {
    try {
      final detail = await InjectionHelper.exploreRepository.getEventById(
        eventId,
      );
      return _cache[eventId] = detail;
    } catch (_) {
      return _cache[eventId] = null;
    } finally {
      _inFlight.remove(eventId);
    }
  }
}
