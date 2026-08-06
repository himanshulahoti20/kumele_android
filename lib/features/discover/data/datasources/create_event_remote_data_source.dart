import 'package:dio/dio.dart';
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
      'EventPlansController_listPlans_v1',
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
