import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum NotificationType {
  welcome,
  birthday,
  eventJoin,
  eventReminder,
  eventConfirmed,
  eventCancelled,
  eventMatched,
  eventRate,
  checkin,
  chat,
  blogComment,
  blogFollow,
  reward,
  paymentSuccess,
  paymentExpired,
  statusUpdate,
  unknown,
}

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
    return List.generate(
      count,
      (index) => createSkeleton(id: '$prefix$index'),
    );
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
  blogComment,
  statusUpdateDialog,
  birthdayDialog,
  eventCancelledDialog,
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

  String get blogId {
    return (targetReference['blogId'] ??
            targetReference['blog_id'] ??
            targetReference['postId'] ??
            targetReference['post_id'] ??
            targetReference['id'] ??
            '')
        .toString()
        .trim();
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
      ];
}
