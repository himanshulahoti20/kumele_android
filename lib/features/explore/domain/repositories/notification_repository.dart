import 'package:kuemele/features/explore/presentation/notification/notification_data.dart';
import 'package:kuemele/shared/services/pagination/pagination_service.dart';

abstract class NotificationRepository {
  Future<PaginatedResult<NotificationItem>> getNotifications({
    int page = 1,
    int limit = 20,
  });

  Future<void> markAsRead(String notificationId);

  Future<void> markAllAsRead();

  Future<int> getUnreadCount();

  Future<void> registerPushToken({
    required String fcmToken,
    required String platform,
    String? deviceId,
    String? language,
  });
}
