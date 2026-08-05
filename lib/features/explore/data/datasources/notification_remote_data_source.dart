import 'package:kuemele/features/explore/data/models/notifications_page_model.dart';
import 'package:kuemele/shared/services/api_service/api_service.dart';
import 'package:kuemele/shared/services/api_service/generated/generated_api_catalog_lookup.dart';

class NotificationRemoteDataSource {
  Future<NotificationsPageModel> fetchNotifications({
    int page = 1,
    int limit = 20,
  }) async {
    final api = GeneratedApiOperations.getNotifications;
    final response = await ApiService.callRequest(
      api.method.toRequestMethod(),
      api.path,
      api.operationId,
      params: {
        'page': page,
        'limit': limit,
      },
    );

    return ApiService.handleResponse<NotificationsPageModel>(() {
          return NotificationsPageModel.fromResponse(
            response,
            fallbackPage: page,
            fallbackLimit: limit,
          );
        }) ??
        NotificationsPageModel.empty(page: page, limit: limit);
  }

  Future<void> markAsRead(String notificationId) async {
    final api = GeneratedApiOperations.markNotificationAsRead;
    final path = GeneratedApiOperations.resolvePath(
      api,
      pathValues: {'id': notificationId},
    );

    await ApiService.callRequest(
      api.method.toRequestMethod(),
      path,
      api.operationId,
    );
  }

  Future<void> registerPushToken({
    required String fcmToken,
    required String platform,
    String? deviceId,
    String? language,
  }) async {
    final api = GeneratedApiOperations.registerPushToken;

    await ApiService.callRequest(
      api.method.toRequestMethod(),
      api.path,
      api.operationId,
      body: {
        'fcmToken': fcmToken,
        'platform': platform,
        if (deviceId != null) 'deviceId': deviceId,
        if (language != null) 'language': language,
      },
    );
  }
}
