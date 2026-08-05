import 'package:kuemele/features/explore/domain/entities/event_guest_entity.dart';
import 'package:kuemele/features/explore/domain/entities/explore_event_detail.dart';
import 'package:kuemele/features/explore/domain/entities/explore_events_page.dart';

abstract class ExploreRepository {
  Future<ExploreEventsPage> getEvents({
    int limit = 20,
    String? cursor,
  });

  Future<ExploreEventsPage> getRecommendations({
    double? latitude,
    double? longitude,
    int limit = 10,
  });

  Future<ExploreEventsPage> getEventsByHostId(
    String hostId, {
    int limit = 20,
  });

  Future<ExploreEventDetail> getEventById(String id);

  Future<List<EventGuestEntity>> getEventGuests(String eventId);

  Future<void> hostCheckInGuest({
    required String eventId,
    required String guestUserId,
    String? note,
  });

  Future<void> joinEvent(String eventId);
}
