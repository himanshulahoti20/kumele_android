import 'package:flutter_test/flutter_test.dart';
import 'package:kuemele/features/explore/cubit/explore_cubit.dart';
import 'package:kuemele/features/explore/cubit/explore_state.dart';
import 'package:kuemele/features/explore/domain/entities/event_guest_entity.dart';
import 'package:kuemele/features/explore/domain/entities/explore_event_detail.dart';
import 'package:kuemele/features/explore/domain/entities/explore_events_page.dart';
import 'package:kuemele/features/explore/domain/entities/explore_host_profile.dart';
import 'package:kuemele/features/explore/domain/repositories/explore_repository.dart';

void main() {
  test('home feed uses events endpoint even with location', () async {
    final repository = _FakeExploreRepository();
    final cubit = ExploreCubit(repository: repository);

    await cubit.loadEvents(
      latitude: 26.49532,
      longitude: 88.2357161,
      radius: 28,
      limit: 10,
    );

    expect(repository.eventsCalled, isTrue);
    expect(repository.recommendationsCalled, isTrue);
    expect(repository.latitude, 26.49532);
    expect(repository.longitude, 88.2357161);
    expect(repository.radius, 28);
    expect(cubit.state.status, ExploreStatus.loaded);
  });
}

class _FakeExploreRepository implements ExploreRepository {
  bool eventsCalled = false;
  bool recommendationsCalled = false;
  double? latitude;
  double? longitude;
  double? radius;

  @override
  Future<ExploreEventsPage> getEvents({
    int limit = 20,
    String? cursor,
    double? latitude,
    double? longitude,
    double? radius,
    String? city,
  }) async {
    eventsCalled = true;
    this.latitude = latitude;
    this.longitude = longitude;
    this.radius = radius;
    return ExploreEventsPage(events: const [], limit: limit);
  }

  @override
  Future<ExploreEventsPage> getRecommendations({
    double? latitude,
    double? longitude,
    double? radius,
    String? city,
    int limit = 10,
  }) async {
    recommendationsCalled = true;
    return ExploreEventsPage(events: const [], limit: limit);
  }

  @override
  Future<ExploreEventDetail> getEventById(String id) =>
      throw UnimplementedError();

  @override
  Future<ExploreHostProfile> getHostProfile(String hostId) =>
      throw UnimplementedError();

  @override
  Future<List<EventGuestEntity>> getEventGuests(String eventId) =>
      throw UnimplementedError();

  @override
  Future<ExploreEventsPage> getEventsByHostId(String hostId,
          {int limit = 20}) =>
      throw UnimplementedError();

  @override
  Future<void> hostCheckInGuest({
    required String eventId,
    required String guestUserId,
    String? note,
  }) =>
      throw UnimplementedError();

  @override
  Future<void> joinEvent(String eventId) => throw UnimplementedError();
}
