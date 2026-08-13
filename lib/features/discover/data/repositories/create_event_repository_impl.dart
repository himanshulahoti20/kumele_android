import 'package:kuemele/features/discover/data/datasources/create_event_remote_data_source.dart';
import 'package:kuemele/features/discover/data/models/availability_check_result.dart';
import 'package:kuemele/features/discover/data/models/create_event_request_model.dart';
import 'package:kuemele/features/discover/data/models/create_event_response_model.dart';
import 'package:kuemele/features/discover/data/models/event_plan_model.dart';
import 'package:kuemele/features/discover/data/models/upload_banner_response_model.dart';
import 'package:kuemele/features/discover/domain/repositories/create_event_repository.dart';

class CreateEventRepositoryImpl implements CreateEventRepository {
  CreateEventRepositoryImpl({CreateEventRemoteDataSource? remoteDataSource})
      : _remoteDataSource = remoteDataSource ?? CreateEventRemoteDataSource();

  final CreateEventRemoteDataSource _remoteDataSource;

  @override
  Future<UploadBannerResponseModel> uploadEventBanner(
    String filePath, {
    String? eventId,
  }) {
    return _remoteDataSource.uploadEventBanner(filePath, eventId: eventId);
  }

  @override
  Future<CreateEventResponseModel> createEvent(
    CreateEventRequestModel request,
  ) {
    return _remoteDataSource.createEvent(request);
  }

  @override
  Future<List<EventPlanModel>> fetchEventPlans() {
    return _remoteDataSource.fetchEventPlans();
  }

  @override
  Future<EventPlanQuoteModel?> fetchEventPlanQuote(int capacity) {
    return _remoteDataSource.fetchEventPlanQuote(capacity);
  }

  @override
  Future<AvailabilityCheckResult> checkAvailability({
    required List<String> userIds,
    required String startsAt,
    required String endsAt,
  }) {
    return _remoteDataSource.checkAvailability(
      userIds: userIds,
      startsAt: startsAt,
      endsAt: endsAt,
    );
  }
}
