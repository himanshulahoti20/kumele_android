import 'package:kuemele/features/explore/data/models/notification_model.dart';
import 'package:kuemele/shared/services/api_service/api_service.dart';

class NotificationsPageModel {
  const NotificationsPageModel({
    required this.notifications,
    required this.total,
    required this.unreadCount,
    required this.page,
    required this.limit,
    this.hasMore = false,
  });

  final List<NotificationModel> notifications;
  final int total;
  final int unreadCount;
  final int page;
  final int limit;
  final bool hasMore;

  factory NotificationsPageModel.empty({
    required int page,
    required int limit,
  }) {
    return NotificationsPageModel(
      notifications: const [],
      total: 0,
      unreadCount: 0,
      page: page,
      limit: limit,
    );
  }

  factory NotificationsPageModel.fromResponse(
    dynamic response, {
    int fallbackPage = 1,
    int fallbackLimit = 20,
  }) {
    final json = _asJsonMap(response);
    final payload = _unwrapPagePayload(json);
    final notificationsJson =
        _resolveNotificationsJson(payload, json, response);
    final notifications = _parseNotifications(notificationsJson);
    final meta = _readMeta(payload, json);

    final page =
        _parseInt(meta['page'] ?? payload['page'], fallback: fallbackPage);
    final limit =
        _parseInt(meta['limit'] ?? payload['limit'], fallback: fallbackLimit);
    final total = _parseInt(
      meta['total'] ?? payload['total'],
      fallback: notifications.length,
    );
    final unreadCount = _parseInt(
      meta['unreadCount'] ??
          meta['unread_count'] ??
          payload['unreadCount'] ??
          payload['unread_count'],
      fallback: notifications.where((item) => !item.readStatus).length,
    );
    final hasMore = meta['hasMore'] == true ||
        meta['has_more'] == true ||
        payload['hasMore'] == true ||
        payload['has_more'] == true ||
        (page * limit < total);

    return NotificationsPageModel(
      notifications: notifications,
      total: total,
      unreadCount: unreadCount,
      page: page,
      limit: limit,
      hasMore: hasMore,
    );
  }

  static Map<String, dynamic> _asJsonMap(dynamic response) {
    if (response is Map<String, dynamic>) return response;
    if (response is Map) return Map<String, dynamic>.from(response);
    return {};
  }

  static Map<String, dynamic> _unwrapPagePayload(Map<String, dynamic> json) {
    final data = json['data'];
    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }
    return json;
  }

  static Map<String, dynamic> _readMeta(
    Map<String, dynamic> payload,
    Map<String, dynamic> root,
  ) {
    final meta = payload['meta'] ?? root['meta'] ?? payload['pagination'];
    if (meta is Map<String, dynamic>) return meta;
    if (meta is Map) return Map<String, dynamic>.from(meta);
    return const {};
  }

  static dynamic _resolveNotificationsJson(
    Map<String, dynamic> payload,
    Map<String, dynamic> root,
    dynamic response,
  ) {
    for (final key in const ['notifications', 'data', 'items', 'results']) {
      final candidate = payload[key] ?? root[key];
      if (candidate is List) return candidate;
    }

    return ApiService.extractList(response);
  }

  static List<NotificationModel> _parseNotifications(
      dynamic notificationsJson) {
    if (notificationsJson is! List) return const [];

    return notificationsJson
        .whereType<Map>()
        .map(
          (item) => NotificationModel.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
        .where((notification) => notification.notificationId.isNotEmpty)
        .toList();
  }

  static int _parseInt(dynamic value, {required int fallback}) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? fallback;
  }
}
