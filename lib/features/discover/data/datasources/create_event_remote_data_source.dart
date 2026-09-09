import 'package:dio/dio.dart';
import 'package:kuemele/features/discover/data/models/audience_estimate_result.dart';
import 'package:kuemele/features/discover/data/models/availability_check_result.dart';
import 'package:kuemele/features/discover/data/models/create_event_request_model.dart';
import 'package:kuemele/features/discover/data/models/create_event_response_model.dart';
import 'package:kuemele/features/discover/data/models/event_plan_model.dart';
import 'package:kuemele/features/discover/data/models/upload_banner_response_model.dart';
import 'package:kuemele/shared/services/api_service/api_service.dart';
import 'package:kuemele/shared/services/api_service/generated/generated_api_catalog_lookup.dart';

class CreateEventRemoteDataSource {
  Future<UploadBannerResponseModel> uploadEventBanner(
    String filePath, {
    String? eventId,
  }) async {
    final api = GeneratedApiOperations.uploadEventBanner;

    final formData = FormData.fromMap(<String, dynamic>{
      'file': await MultipartFile.fromFile(filePath),
      if (eventId != null && eventId.isNotEmpty) 'eventId': eventId,
    });

    final response = await ApiService.uploadMultipart(
      api.path,
      api.operationId,
      formData,
    );

    return ApiService.handleResponse<UploadBannerResponseModel>(() {
      return UploadBannerResponseModel.fromJson(
          ApiService.extractMap(response));
    })!;
  }

  Future<CreateEventResponseModel> createEvent(
    CreateEventRequestModel request,
  ) async {
    final api = GeneratedApiOperations.createEvent;

    final response = await ApiService.callRequest(
      api.method.toRequestMethod(),
      api.path,
      api.operationId,
      body: request.toJson(),
    );

    return ApiService.handleResponse<CreateEventResponseModel>(() {
      return CreateEventResponseModel.fromResponse(response);
    })!;
  }

  Future<List<EventPlanModel>> fetchEventPlans() async {
    final response = await ApiService.callRequest(
      RequestMethod.GET,
      '/event-plans',
      'EventPlansController_list_v1',
      useAuthenHeader: false,
    );

    return ApiService.handleResponse<List<EventPlanModel>>(() {
          return ApiService.extractList(response)
              .whereType<Map>()
              .map((item) =>
                  EventPlanModel.fromJson(item.cast<String, dynamic>()))
              .where((plan) => plan.minGuests > 0 && plan.maxGuests > 0)
              .toList();
        }) ??
        [];
  }

  Future<AvailabilityCheckResult> checkAvailability({
    required List<String> userIds,
    required String startsAt,
    required String endsAt,
  }) async {
    final api = GeneratedApiOperations.checkAvailability;

    final response = await ApiService.callRequest(
      api.method.toRequestMethod(),
      api.path,
      api.operationId,
      body: {
        'userIds': userIds,
        'startsAt': startsAt,
        'endsAt': endsAt,
      },
    );

    return ApiService.handleResponse<AvailabilityCheckResult>(() {
          return AvailabilityCheckResult.fromResponse(response);
        }) ??
        const AvailabilityCheckResult(conflicts: []);
  }

  /// `POST /events/audience-estimate` — not yet in the generated API
  /// catalog, so this calls the raw path directly (same pattern as
  /// [fetchEventPlanQuote] below). All fields optional; send coordinates
  /// when available — the city/country fallback is coarser.
  Future<AudienceEstimateResult> getAudienceEstimate({
    double? latitude,
    double? longitude,
    double? radiusKm,
    String? city,
    String? state,
    String? country,
    String? postcode,
    int? guests,
  }) async {
    final response = await ApiService.callRequest(
      RequestMethod.POST,
      '/events/audience-estimate',
      'EventsController_audienceEstimate_v1',
      body: {
        if (latitude != null) 'latitude': latitude,
        if (longitude != null) 'longitude': longitude,
        if (radiusKm != null) 'radiusKm': radiusKm,
        if (city != null && city.isNotEmpty) 'city': city,
        if (state != null && state.isNotEmpty) 'state': state,
        if (country != null && country.isNotEmpty) 'country': country,
        if (postcode != null && postcode.isNotEmpty) 'postcode': postcode,
        if (guests != null) 'guests': guests,
      },
    );

    return ApiService.handleResponse<AudienceEstimateResult>(() {
          return AudienceEstimateResult.fromJson(
            ApiService.extractMap(response),
          );
        }) ??
        const AudienceEstimateResult(
          estimatedAvailable: 0,
          enoughForGuests: false,
          guests: 0,
          radiusKm: 0,
          basis: 'none',
          confidence: '',
          locationCoverage: 0,
          message: '',
        );
  }

  Future<EventPlanQuoteModel?> fetchEventPlanQuote(int capacity) async {
    final response = await ApiService.callRequest(
      RequestMethod.GET,
      '/event-plans/quote',
      'EventPlansController_quote_v1',
      params: {'capacity': capacity},
      useAuthenHeader: false,
    );

    return ApiService.handleResponse<EventPlanQuoteModel?>(
      () => EventPlanQuoteModel.fromJson(ApiService.extractMap(response)),
    );
  }
}
