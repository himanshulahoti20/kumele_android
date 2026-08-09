import 'package:kuemele/shared/services/api_service/api_service.dart';
import 'package:kuemele/shared/services/api_service/generated/generated_api_catalog_lookup.dart';

class EventsRepo extends ApiService {
  static Future<bool> rateEvent({
    required String eventId,
    required int eventRating,
    String? comment,
    int? communication,
    int? respect,
    int? professionalism,
    int? atmosphere,
    int? valueForMoney,
  }) async {
    final api = GeneratedApiOperations.rateEvent;
    final path = GeneratedApiOperations.resolvePath(
      api,
      pathValues: {'id': eventId},
    );
    await ApiService.callRequest(
      api.method.toRequestMethod(),
      path,
      api.operationId,
      body: {
        'eventRating': eventRating,
        if (comment != null && comment.isNotEmpty) 'comment': comment,
        if (communication != null) 'communication': communication,
        if (respect != null) 'respect': respect,
        if (professionalism != null) 'professionalism': professionalism,
        if (atmosphere != null) 'atmosphere': atmosphere,
        if (valueForMoney != null) 'valueForMoney': valueForMoney,
      },
    );
    return ApiService.handleResponse<bool>(() => true) ?? false;
  }

  static Future<List<Map<String, dynamic>>> getEventRatings({
    required String eventId,
    int page = 1,
    int limit = 20,
  }) async {
    final api = GeneratedApiOperations.getEventRatings;
    final path = GeneratedApiOperations.resolvePath(
      api,
      pathValues: {'id': eventId},
    );
    final response = await ApiService.callRequest(
      api.method.toRequestMethod(),
      path,
      api.operationId,
      params: {'page': page, 'limit': limit},
      useAuthenHeader: api.requiresAuth,
    );
    return ApiService.handleResponse<List<Map<String, dynamic>>>(() =>
            ApiService.extractList(response)
                .whereType<Map>()
                .map((e) => Map<String, dynamic>.from(e))
                .toList()) ??
        [];
  }

  static Future<Map<String, dynamic>?> getEventRatingsSummary(
      String eventId) async {
    final api = GeneratedApiOperations.getEventRatingsSummary;
    final path = GeneratedApiOperations.resolvePath(
      api,
      pathValues: {'id': eventId},
    );
    final response = await ApiService.callRequest(
      api.method.toRequestMethod(),
      path,
      api.operationId,
      useAuthenHeader: api.requiresAuth,
    );
    return ApiService.handleResponse<Map<String, dynamic>?>(
      () => ApiService.extractMap(response),
    );
  }

  static Future<Map<String, dynamic>?> getMyEventRating(
      String eventId) async {
    final api = GeneratedApiOperations.getMyEventRating;
    final path = GeneratedApiOperations.resolvePath(
      api,
      pathValues: {'id': eventId},
    );
    final response = await ApiService.callRequest(
      api.method.toRequestMethod(),
      path,
      api.operationId,
    );
    return ApiService.handleResponse<Map<String, dynamic>?>(() {
      final data = ApiService.extractMap(response);
      return data.isEmpty ? null : data;
    });
  }

  static Future<bool> deleteEventRating({
    required String eventId,
    required String ratingId,
  }) async {
    final api = GeneratedApiOperations.deleteEventRating;
    final path = GeneratedApiOperations.resolvePath(
      api,
      pathValues: {'id': eventId, 'ratingId': ratingId},
    );
    await ApiService.callRequest(
      api.method.toRequestMethod(),
      path,
      api.operationId,
    );
    return ApiService.handleResponse<bool>(() => true) ?? false;
  }

  static Future<bool> reportEvent({
    required String eventId,
    required String reason,
    String? details,
  }) async {
    final api = GeneratedApiOperations.reportEvent;
    final path = GeneratedApiOperations.resolvePath(
      api,
      pathValues: {'id': eventId},
    );
    await ApiService.callRequest(
      api.method.toRequestMethod(),
      path,
      api.operationId,
      body: {
        'reason': reason,
        if (details != null && details.isNotEmpty) 'details': details,
      },
    );
    return ApiService.handleResponse<bool>(() => true) ?? false;
  }

  static Future<bool> cancelEvent({
    required String eventId,
    required String reason,
  }) async {
    final api = GeneratedApiOperations.cancelEvent;
    final path = GeneratedApiOperations.resolvePath(
      api,
      pathValues: {'id': eventId},
    );
    await ApiService.callRequest(
      api.method.toRequestMethod(),
      path,
      api.operationId,
      body: {'reason': reason},
    );
    return ApiService.handleResponse<bool>(() => true) ?? false;
  }

  static Future<bool> selfCheckIn({
    required String eventId,
    required double guestLat,
    required double guestLng,
  }) async {
    final api = GeneratedApiOperations.selfCheckin;
    final path = GeneratedApiOperations.resolvePath(
      api,
      pathValues: {'id': eventId},
    );
    await ApiService.callRequest(
      api.method.toRequestMethod(),
      path,
      api.operationId,
      body: {'guestLat': guestLat, 'guestLng': guestLng},
    );
    return ApiService.handleResponse<bool>(() => true) ?? false;
  }
}
