import 'package:kuemele/features/explore/data/models/event_guest_model.dart';
import 'package:kuemele/features/explore/data/models/explore_event_detail_model.dart';
import 'package:kuemele/features/explore/data/models/explore_events_page_model.dart';
import 'package:kuemele/shared/services/api_service/api_service.dart';
import 'package:kuemele/shared/services/api_service/generated/generated_api_catalog_lookup.dart';

class ExploreRemoteDataSource {
  /// Discover / Explore / nearby — George's Primary Rule:
  /// Use /match/events for all event discovery. Backend applies hard filters
  /// (location, capacity, moderation, blocked users) before AI/ML scoring.
  /// Frontend never talks to AI/ML directly.
  Future<ExploreEventsPageModel> fetchEvents({
    int limit = 20,
    String? cursor,
    String? hostId,
    double? latitude,
    double? longitude,
    double? radiusKm,
  }) async {
    final api = GeneratedApiOperations.getMatchEvents;
    final response = await ApiService.callRequest(
      api.method.toRequestMethod(),
      api.path,
      api.operationId,
      params: {
        'limit': limit,
        if (cursor != null && cursor.isNotEmpty) 'cursor': cursor,
        if (hostId != null && hostId.isNotEmpty) 'hostId': hostId,
        if (latitude != null) 'centerLat': latitude,
        if (longitude != null) 'centerLon': longitude,
        if (radiusKm != null) 'radiusKm': radiusKm,
      },
      useAuthenHeader: api.requiresAuth,
    );

    return ApiService.handleResponse<ExploreEventsPageModel>(() {
          return ExploreEventsPageModel.fromResponse(response);
        }) ??
        const ExploreEventsPageModel(events: [], limit: 20);
  }

  /// "Recommended for you" — George's Primary Rule:
  /// Use /recommendations/events for personalised recommendations ONLY.
  /// Must NOT be merged with fetchEvents in UI logic. The backend internally
  /// queries AI/ML for scoring; the frontend never calls AI/ML directly.
  Future<ExploreEventsPageModel> fetchRecommendations({
    double? latitude,
    double? longitude,
    double? radius,
    String? city,
    int limit = 10,
  }) async {
    final api = GeneratedApiOperations.getEventRecommendations;
    final response = await ApiService.callRequest(
      api.method.toRequestMethod(),
      api.path,
      api.operationId,
      params: {
        'limit': limit,
        if (latitude != null) 'lat': latitude,
        if (longitude != null) 'lon': longitude,
        if (radius != null) 'radius': radius,
        if (city != null && city.isNotEmpty) 'city': city,
      },
      useAuthenHeader: api.requiresAuth,
    );

    return ApiService.handleResponse<ExploreEventsPageModel>(() {
          return ExploreEventsPageModel.fromResponse(response);
        }) ??
        ExploreEventsPageModel(events: const [], limit: limit);
  }


  Future<ExploreEventDetailModel> fetchEventById(String id) async {
    final api = GeneratedApiOperations.getEventDetails;
    final url = GeneratedApiOperations.resolvePath(
      api,
      pathValues: {'id': id},
    );

    final response = await ApiService.callRequest(
      api.method.toRequestMethod(),
      url,
      api.operationId,
      useAuthenHeader: api.requiresAuth,
    );

    return ApiService.handleResponse<ExploreEventDetailModel>(() {
      return ExploreEventDetailModel.fromJson(ApiService.extractMap(response));
    })!;
  }

  Future<void> joinEvent(String eventId) async {
    final api = GeneratedApiOperations.joinEvent;
    final url = GeneratedApiOperations.resolvePath(
      api,
      pathValues: {'id': eventId},
    );

    await ApiService.callRequest(
      api.method.toRequestMethod(),
      url,
      api.operationId,
      useAuthenHeader: api.requiresAuth,
    );
  }

  Future<void> hostCheckInGuest({
    required String eventId,
    required String guestUserId,
    String? note,
  }) async {
    final api = GeneratedApiOperations.hostCheckInGuest;
    final url = GeneratedApiOperations.resolvePath(
      api,
      pathValues: {'id': eventId},
    );

    await ApiService.callRequest(
      api.method.toRequestMethod(),
      url,
      api.operationId,
      body: {
        'guestUserId': guestUserId,
        'note': note ?? '',
      },
      useAuthenHeader: api.requiresAuth,
    );
  }

  Future<List<EventGuestModel>> fetchEventGuests(String eventId) async {
    final api = GeneratedApiOperations.getEventGuestList;
    final url = GeneratedApiOperations.resolvePath(
      api,
      pathValues: {'id': eventId},
    );

    final response = await ApiService.callRequest(
      api.method.toRequestMethod(),
      url,
      api.operationId,
      useAuthenHeader: api.requiresAuth,
    );

    return ApiService.handleResponse<List<EventGuestModel>>(() {
          final data = ApiService.extractList(response);
          return data.map((json) => EventGuestModel.fromJson(json)).toList();
        }) ??
        [];
  }
}
