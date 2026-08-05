import 'package:kuemele/features/explore/data/datasources/explore_remote_data_source.dart';
import 'package:kuemele/features/explore/domain/entities/event_guest_entity.dart';
import 'package:kuemele/features/explore/domain/entities/explore_event_detail.dart';
import 'package:kuemele/features/explore/domain/entities/explore_events_page.dart';
import 'package:kuemele/features/explore/domain/repositories/explore_repository.dart';

class ExploreRepositoryImpl implements ExploreRepository {
  ExploreRepositoryImpl({ExploreRemoteDataSource? remoteDataSource})
      : _remoteDataSource = remoteDataSource ?? ExploreRemoteDataSource();

  final ExploreRemoteDataSource _remoteDataSource;

  @override
  Future<ExploreEventsPage> getEvents({
    int limit = 20,
    String? cursor,
  }) async {
    final page = await _remoteDataSource.fetchEvents(
      limit: limit,
      cursor: cursor,
    );

    return page.toEntity();
  }

  @override
  Future<ExploreEventsPage> getRecommendations({
    double? latitude,
    double? longitude,
    int limit = 10,
  }) async {
    final page = await _remoteDataSource.fetchRecommendations(
      latitude: latitude,
      longitude: longitude,
      limit: limit,
    );

    return page.toEntity();
  }

  @override
  Future<ExploreEventsPage> getEventsByHostId(
    String hostId, {
    int limit = 20,
  }) async {
    final page = await _remoteDataSource.fetchEvents(
      limit: limit,
      hostId: hostId,
    );

    return page.toEntity();
  }

  @override
  Future<ExploreEventDetail> getEventById(String id) async {
    final detail = await _remoteDataSource.fetchEventById(id);
    return detail.toEntity();
  }

  @override
  Future<List<EventGuestEntity>> getEventGuests(String eventId) async {
    final guests = await _remoteDataSource.fetchEventGuests(eventId);
    return guests.map((guest) => guest.toEntity()).toList();
  }

  @override
  Future<void> hostCheckInGuest({
    required String eventId,
    required String guestUserId,
    String? note,
  }) {
    return _remoteDataSource.hostCheckInGuest(
      eventId: eventId,
      guestUserId: guestUserId,
      note: note,
    );
  }

  @override
  Future<void> joinEvent(String eventId) {
    return _remoteDataSource.joinEvent(eventId);
  }
}
