import 'package:kuemele/features/profile/presentation/connections/data/models/follow_connections_page_model.dart';
import 'package:kuemele/shared/services/api_service/api_service.dart';
import 'package:kuemele/shared/services/api_service/generated/generated_api_catalog.dart';
import 'package:kuemele/shared/services/api_service/generated/generated_api_catalog_lookup.dart';

class ConnectionsRemoteDataSource {
  Future<FollowConnectionsPageModel> fetchFollowers({
    required String userId,
    int page = 1,
    int limit = 20,
  }) {
    return _fetchConnections(
      api: GeneratedApiOperations.getFollowers,
      userId: userId,
      page: page,
      limit: limit,
    );
  }

  Future<FollowConnectionsPageModel> fetchFollowing({
    required String userId,
    int page = 1,
    int limit = 20,
  }) {
    return _fetchConnections(
      api: GeneratedApiOperations.getFollowing,
      userId: userId,
      page: page,
      limit: limit,
    );
  }

  Future<FollowConnectionsPageModel> _fetchConnections({
    required GeneratedApiDescriptor api,
    required String userId,
    required int page,
    required int limit,
  }) async {
    final path = GeneratedApiOperations.resolvePath(
      api,
      pathValues: {'id': userId},
    );

    final response = await ApiService.callRequest(
      api.method.toRequestMethod(),
      path,
      api.operationId,
      params: {
        'page': page,
        'limit': limit,
      },
    );

    return ApiService.handleResponse<FollowConnectionsPageModel>(() {
          return FollowConnectionsPageModel.fromResponse(
            response,
            fallbackPage: page,
            fallbackLimit: limit,
          );
        }) ??
        FollowConnectionsPageModel.empty(page: page, limit: limit);
  }
}
