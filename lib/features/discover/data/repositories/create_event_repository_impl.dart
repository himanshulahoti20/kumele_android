import 'package:kuemele/features/discover/data/datasources/create_event_remote_data_source.dart';
import 'package:kuemele/features/discover/data/models/create_event_request_model.dart';
import 'package:kuemele/features/discover/data/models/create_event_response_model.dart';
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
}
