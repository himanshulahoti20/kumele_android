import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum NotificationType {
  welcome,
  birthday,
  eventJoin,
  eventReminder,
  eventConfirmed,
  eventCancelled,
  eventCreated,
  eventMatched,
  eventRate,
  checkin,
  chat,
  blogComment,
  blogFollow,
  blogNew,
  reward,
  paymentSuccess,
  paymentExpired,
  statusUpdate,
  unknown,
}

enum NotificationSection { matched, created, other }

class NotificationItemFactory {
  static NotificationItem createSkeleton({
    required String id,
    String title = 'Loading notification title',
    String timeLabel = 'Loading',
    String description = 'Loading notification description',
    NotificationType type = NotificationType.unknown,
    bool isRead = true,
  }) {
    return NotificationItem(
      id: id,
      title: title,
      timeLabel: timeLabel,
      description: description,
      type: type,
      actionType: NotificationActionType.none,
      isRead: isRead,
    );
  }

  static List<NotificationItem> createSkeletonPlaceholders({
    int count = 6,
    String prefix = 'skeleton-refresh-',
  }) {
    return List.generate(count, (index) => createSkeleton(id: '$prefix$index'));
  }

  static List<NotificationItem> createLoadMoreSkeletons({int count = 3}) {
    return List.generate(
      count,
      (index) => createSkeleton(id: 'skeleton-loadmore-$index'),
    );
  }
}

enum NotificationActionType {
  none,
  eventJoinPreview,
  welcomeDialog,
  blog,
  statusUpdateDialog,
  birthdayDialog,
  eventCancelledDialog,
  eventRate,
  chat,
  reward,
  payment,
  infoDialog,
}

class NotificationTag extends Equatable {
  const NotificationTag({
    required this.label,
    this.hasIcon = true,
    this.backgroundColor = const Color(0xFF1F1F1F),
    this.textColor = Colors.white,
    this.iconColor = Colors.white,
    this.iconPath = 'assets/icons/yin_yang.png',
  });

  final String label;
  final bool hasIcon;
  final Color backgroundColor;
  final Color textColor;
  final Color iconColor;
  final String iconPath;

  @override
  List<Object?> get props => [
        label,
        hasIcon,
        backgroundColor,
        textColor,
        iconColor,
        iconPath,
      ];
}

class NotificationItem extends Equatable {
  const NotificationItem({
    required this.id,
    required this.title,
    required this.timeLabel,
    required this.description,
    required this.actionType,
    this.type = NotificationType.unknown,
    this.accentText,
    this.iconKey,
    this.leadingAssetPath,
    this.leadingBackgroundColor,
    this.leadingBorder,
    this.tags = const [],
    this.isRead = false,
    this.targetReference = const {},
    this.category = '',
  });

  final String id;
  final String title;
  final String timeLabel;
  final String description;
  final NotificationType type;
  final String? accentText;
  final String? iconKey;
  final String? leadingAssetPath;
  final Color? leadingBackgroundColor;
  final BoxBorder? leadingBorder;
  final List<NotificationTag> tags;
  final bool isRead;
  final NotificationActionType actionType;
  final Map<String, dynamic> targetReference;
  final String category;

  String get blogId {
    return _referenceValue(const [
      'blogId',
      'blog_id',
      'postId',
      'post_id',
      'destinationId',
      'destination_id',
      'id',
    ], nestedKey: 'blog');
  }

  String get eventId {
    return _referenceValue(const [
      'eventId',
      'event_id',
      'eventID',
      'targetId',
      'target_id',
      'destinationId',
      'destination_id',
      'id',
    ], nestedKey: 'event');
  }

  bool get isEventJoined {
    for (final values in [
      targetReference,
      if (targetReference['event'] is Map)
        Map<String, dynamic>.from(targetReference['event'] as Map),
    ]) {
      for (final key in const ['isJoined', 'is_joined', 'joined']) {
        final value = values[key];
        if (value is bool) return value;
        if (value.toString().toLowerCase() == 'true' || value == 1) return true;
      }
    }
    return false;
  }

  /// True only while the event this notification is about is still
  /// upcoming and active — from the `canCancel` field on the backend's
  /// notification `data` payload (folded into [targetReference]).
  /// Defaults to true when the backend omits it, matching the previous
  /// behavior (every EVENT_CREATED notification showed an active Cancel
  /// chip) rather than silently hiding the action for older payloads.
  bool get canCancel {
    final value = targetReference['canCancel'] ?? targetReference['can_cancel'];
    if (value is bool) return value;
    if (value == null) return true;
    return value.toString().toLowerCase() == 'true' || value == 1;
  }

  String _referenceValue(List<String> keys, {required String nestedKey}) {
    for (final values in [
      targetReference,
      if (targetReference[nestedKey] is Map)
        Map<String, dynamic>.from(targetReference[nestedKey] as Map),
    ]) {
      for (final key in keys) {
        final value = values[key]?.toString().trim() ?? '';
        if (value.isNotEmpty) return value;
      }
    }
    return '';
  }

  NotificationSection get section {
    final normalizedCategory = category.toLowerCase();
    if (normalizedCategory.contains('match')) {
      return NotificationSection.matched;
    }
    if (normalizedCategory.contains('creat')) {
      return NotificationSection.created;
    }

    return switch (type) {
      NotificationType.eventJoin ||
      NotificationType.eventMatched ||
      NotificationType.eventReminder =>
        NotificationSection.matched,
      NotificationType.eventConfirmed ||
      NotificationType.eventCancelled ||
      NotificationType.eventCreated ||
      NotificationType.eventRate ||
      NotificationType.checkin =>
        NotificationSection.created,
      _ => NotificationSection.other,
    };
  }

  NotificationItem copyWith({
    String? id,
    String? title,
    String? timeLabel,
    String? description,
    NotificationType? type,
    String? accentText,
    String? iconKey,
    String? leadingAssetPath,
    Color? leadingBackgroundColor,
    BoxBorder? leadingBorder,
    List<NotificationTag>? tags,
    bool? isRead,
    NotificationActionType? actionType,
    Map<String, dynamic>? targetReference,
    String? category,
  }) {
    return NotificationItem(
      id: id ?? this.id,
      title: title ?? this.title,
      timeLabel: timeLabel ?? this.timeLabel,
      description: description ?? this.description,
      type: type ?? this.type,
      accentText: accentText ?? this.accentText,
      iconKey: iconKey ?? this.iconKey,
      leadingAssetPath: leadingAssetPath ?? this.leadingAssetPath,
      leadingBackgroundColor:
          leadingBackgroundColor ?? this.leadingBackgroundColor,
      leadingBorder: leadingBorder ?? this.leadingBorder,
      tags: tags ?? this.tags,
      isRead: isRead ?? this.isRead,
      actionType: actionType ?? this.actionType,
      targetReference: targetReference ?? this.targetReference,
      category: category ?? this.category,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        timeLabel,
        description,
        type,
        accentText,
        iconKey,
        leadingAssetPath,
        leadingBackgroundColor,
        leadingBorder,
        tags,
        isRead,
        actionType,
        targetReference,
        category,
      ];
}
