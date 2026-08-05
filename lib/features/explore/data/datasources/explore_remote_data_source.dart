import 'package:kuemele/features/explore/data/models/event_guest_model.dart';
import 'package:kuemele/features/explore/data/models/explore_event_detail_model.dart';
import 'package:kuemele/features/explore/data/models/explore_events_page_model.dart';
import 'package:kuemele/shared/services/api_service/api_service.dart';
import 'package:kuemele/shared/services/api_service/generated/generated_api_catalog_lookup.dart';

class ExploreRemoteDataSource {
  Future<ExploreEventsPageModel> fetchEvents({
    int limit = 20,
    String? cursor,
    String? hostId,
  }) async {
    final api = GeneratedApiOperations.listEvents;
    final url = GeneratedApiOperations.resolvePath(api);

    final response = await ApiService.callRequest(
      api.method.toRequestMethod(),
      url,
      api.operationId,
      params: {
        'limit': limit,
        if (cursor != null && cursor.isNotEmpty) 'cursor': cursor,
        if (hostId != null && hostId.isNotEmpty) 'hostId': hostId,
      },
      useAuthenHeader: api.requiresAuth,
    );

    return ApiService.handleResponse<ExploreEventsPageModel>(() {
          return ExploreEventsPageModel.fromResponse(response);
        }) ??
        const ExploreEventsPageModel(events: [], limit: 20);
  }

  Future<ExploreEventsPageModel> fetchRecommendations({
    double? latitude,
    double? longitude,
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
      },
      useAuthenHeader: false,
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
