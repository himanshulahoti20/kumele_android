import 'package:kuemele/features/discover/data/models/create_event_request_model.dart';
import 'package:kuemele/features/discover/data/models/create_event_response_model.dart';
import 'package:kuemele/features/discover/data/models/event_plan_model.dart';
import 'package:kuemele/features/discover/data/models/upload_banner_response_model.dart';

abstract class CreateEventRepository {
  Future<UploadBannerResponseModel> uploadEventBanner(
    String filePath, {
    String? eventId,
  });

  Future<CreateEventResponseModel> createEvent(
    CreateEventRequestModel request,
  );

  Future<List<EventPlanModel>> fetchEventPlans();

  Future<EventPlanQuoteModel?> fetchEventPlanQuote(int capacity);
}
