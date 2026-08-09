import 'package:kuemele/features/explore/data/datasources/notification_remote_data_source.dart';
import 'package:kuemele/features/explore/data/mappers/notification_item_mapper.dart';
import 'package:kuemele/features/explore/domain/repositories/notification_repository.dart';
import 'package:kuemele/features/explore/presentation/notification/notification_data.dart';
import 'package:kuemele/shared/services/pagination/pagination_service.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  NotificationRepositoryImpl({NotificationRemoteDataSource? remoteDataSource})
      : _remoteDataSource = remoteDataSource ?? NotificationRemoteDataSource();

  final NotificationRemoteDataSource _remoteDataSource;

  @override
  Future<PaginatedResult<NotificationItem>> getNotifications({
    int page = 1,
    int limit = 20,
  }) async {
    final pageModel = await _remoteDataSource.fetchNotifications(
      page: page,
      limit: limit,
    );

    return PaginatedResult(
      items: NotificationItemMapper.fromModels(pageModel.notifications),
      page: pageModel.page,
      hasMore: pageModel.hasMore,
    );
  }

  @override
  Future<void> markAsRead(String notificationId) {
    return _remoteDataSource.markAsRead(notificationId);
  }

  @override
  Future<void> markAllAsRead() {
    return _remoteDataSource.markAllAsRead();
  }

  @override
  Future<int> getUnreadCount() async {
    final page = await _remoteDataSource.fetchNotifications(limit: 1);
    return page.unreadCount;
  }

  @override
  Future<void> registerPushToken({
    required String fcmToken,
    required String platform,
    String? deviceId,
    String? language,
  }) {
    return _remoteDataSource.registerPushToken(
      fcmToken: fcmToken,
      platform: platform,
      deviceId: deviceId,
      language: language,
    );
  }
}
