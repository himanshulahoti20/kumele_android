import 'package:kuemele/features/explore/domain/entities/event_guest_entity.dart';
import 'package:kuemele/features/explore/domain/entities/explore_event_detail.dart';
import 'package:kuemele/features/explore/domain/entities/explore_events_page.dart';
import 'package:kuemele/features/explore/domain/entities/explore_host_profile.dart';

abstract class ExploreRepository {
  Future<ExploreEventsPage> getEvents({
    int limit = 20,
    String? cursor,
    double? latitude,
    double? longitude,
    double? radius,
    String? city,
    String? hobby,
  });

  Future<ExploreEventsPage> getRecommendations({
    double? latitude,
    double? longitude,
    double? radius,
    String? city,
    int limit = 10,
  });

  Future<ExploreEventsPage> getEventsByHostId(
    String hostId, {
    int limit = 20,
  });

  Future<ExploreEventDetail> getEventById(String id);

  Future<ExploreHostProfile> getHostProfile(String hostId);

  Future<List<EventGuestEntity>> getEventGuests(String eventId);

  Future<void> hostCheckInGuest({
    required String eventId,
    required String guestUserId,
    String? note,
  });

  Future<void> joinEvent(String eventId);
}
