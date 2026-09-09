import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kuemele/features/explore/data/models/notification_model.dart';
import 'package:kuemele/features/explore/presentation/notification/notification_data.dart';
import 'package:kuemele/gen/assets.gen.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/utils/conversion_utils.dart';

class NotificationItemMapper {
  NotificationItemMapper._();

  static NotificationItem fromModel(NotificationModel model) {
    final eventTitle = ConversionUtils.toNullableString(
      model.targetReference['eventTitle'] ??
          model.targetReference['event_title'],
    );

    return NotificationItem(
      id: model.notificationId,
      title: _resolveTitle(model, eventTitle),
      timeLabel: _formatTimeLabel(model.createdAt),
      description: model.message,
      type: _resolveNotificationType(model.type),
      accentText: _resolveAccentText(model.targetReference),
      iconKey: model.icon,
      leadingAssetPath: _resolveLeadingAssetPath(model.targetReference),
      leadingBackgroundColor: _resolveLeadingBackgroundColor(model.icon),
      tags: _resolveTags(model),
      isRead: model.readStatus,
      actionType: _resolveActionType(model.type),
      targetReference: model.targetReference,
      category: model.category,
    );
  }

  static List<NotificationItem> fromModels(List<NotificationModel> models) {
    return models.map(fromModel).toList(growable: false);
  }

  static String _resolveTitle(NotificationModel model, String? eventTitle) {
    if (model.title.isNotEmpty) return model.title;
    return eventTitle ?? 'Notification';
  }

  static String _formatTimeLabel(DateTime? createdAt) {
    if (createdAt == null) return '';
    return DateFormat('h:mm a').format(createdAt.toLocal());
  }

  static String? resolveIconSvgPath(String? iconKey) {
    final n = Assets.icons.notifications;
    return switch (iconKey) {
      'icon_welcome' => 'assets/kumele_welcome.png',
      'icon_birthday' => n.birthdayCake.path,
      'icon_event_matched' => n.handshake.path,
      'icon_event_reminder' => n.bell.path,
      'icon_event_confirmed' => n.tickets.path,
      'icon_event_created' => n.tickets.path,
      'icon_event_join' => n.handshake.path,
      'icon_event_cancelled' => n.cancel.path,
      'icon_chat' => n.chat.path,
      'icon_event_rate' => n.rating.path,
      'icon_checkin' => n.location.path,
      'icon_blog_comment' => n.comment.path,
      'icon_blog_follow' => n.blog.path,
      'icon_blog_new' => n.blog.path,
      'icon_reward' => n.trophy.path,
      'icon_payment_success' => n.wallet.path,
      'icon_payment_expired' => n.wallet.path,
      _ => null,
    };
  }

  static Color _resolveLeadingBackgroundColor(String iconKey) {
    return switch (iconKey) {
      'icon_welcome' => ColorSet.notifIconWelcome,
      'icon_birthday' => ColorSet.notifIconBirthday,
      'icon_event_matched' => ColorSet.notifIconGreen,
      'icon_event_reminder' => ColorSet.notifIconBlue,
      'icon_event_confirmed' => ColorSet.notifIconGreen,
      'icon_event_created' => ColorSet.notifIconGreen,
      'icon_event_join' => ColorSet.notifIconGreen,
      'icon_event_cancelled' => ColorSet.notifIconCancelled,
      'icon_chat' => ColorSet.notifIconBlue,
      'icon_event_rate' => ColorSet.notifIconAmber,
      'icon_checkin' => ColorSet.notifIconGreen,
      'icon_blog_comment' => ColorSet.notifIconWelcome,
      'icon_blog_follow' => ColorSet.notifIconWelcome,
      'icon_reward' => ColorSet.notifIconAmber,
      'icon_payment_success' => ColorSet.notifIconGreen,
      'icon_payment_expired' => ColorSet.notifIconPaymentExpired,
      _ => ColorSet.notifIconDefault,
    };
  }

  static String? _resolveLeadingAssetPath(Map<String, dynamic> reference) {
    String? imageFrom(Map<dynamic, dynamic> values) {
      for (final key in const [
        'avatar',
        'profilePicture',
        'profile_picture',
        'eventImage',
        'event_image',
        'imageUrl',
        'image_url',
        'coverImage',
        'cover_image',
      ]) {
        final value = values[key]?.toString().trim() ?? '';
        if (value.isNotEmpty) return value;
      }
      return null;
    }

    return imageFrom(reference) ??
        ['event', 'user', 'actor', 'host']
            .map((key) => reference[key])
            .whereType<Map>()
            .map(imageFrom)
            .firstWhere((value) => value != null, orElse: () => null);
  }

  static List<NotificationTag> _resolveTags(NotificationModel model) {
    final reference = model.targetReference;
    final nestedCategory = reference['hobbyCategory'] ??
        reference['hobby_category'] ??
        reference['eventCategory'] ??
        reference['event_category'];
    final category = nestedCategory is Map
        ? nestedCategory['name'] ?? nestedCategory['title']
        : nestedCategory;
    final label = ConversionUtils.toStringValue(category).trim();
    if (label.isEmpty) return const [];

    return [
      NotificationTag(
        label: ConversionUtils.formatHyphenatedLabel(label),
      ),
    ];
  }

  static String? _resolveAccentText(Map<String, dynamic> reference) {
    for (final key in const [
      'actorName',
      'actor_name',
      'userName',
      'user_name',
      'hostName',
      'host_name',
      'displayName',
      'display_name',
    ]) {
      final value = reference[key]?.toString().trim() ?? '';
      if (value.isNotEmpty) return value;
    }
    return null;
  }

  static String _normaliseType(String type) {
    return type.trim().toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]+'), '_');
  }

  static NotificationActionType _resolveActionType(String type) {
    return switch (_normaliseType(type)) {
      'EVENT_JOIN' ||
      'JOIN_EVENT' ||
      'EVENT_JOINED' ||
      'EVENT_MATCHED' ||
      'MATCHED_EVENT' ||
      'EVENT_REMINDER' ||
      'HOBBY_EVENT_REMINDER' ||
      'EVENT_CONFIRMED' ||
      'EVENT_JOIN_CONFIRMED' ||
      'EVENT_CREATED' ||
      'CREATED_EVENT' ||
      'CHECKIN' ||
      'CHECKIN_CONFIRMED' =>
        NotificationActionType.eventJoinPreview,
      'EVENT_RATE' ||
      'RATE_EVENT' ||
      'EVENT_RATE_REMINDER' =>
        NotificationActionType.eventRate,
      'BLOG_COMMENT' ||
      'BLOG_COMMENTED' ||
      'BLOG_FOLLOW' ||
      'BLOG_NEW_POST_FOLLOWED_AUTHOR' ||
      'NEW_BLOG' ||
      'BLOG_NEW' ||
      'BLOG_ADDED' ||
      'BLOG_NEW_POST_HOBBY_CATEGORY' =>
        NotificationActionType.blog,
      'WELCOME' => NotificationActionType.welcomeDialog,
      'STATUS_UPDATE' => NotificationActionType.statusUpdateDialog,
      'BIRTHDAY' => NotificationActionType.birthdayDialog,
      'EVENT_CANCELLED' || 'EVENT_CANCELED' =>
        NotificationActionType.eventCancelledDialog,
      'CHAT' || 'EVENT_CHAT_OPENED' || 'CHAT_MESSAGE' =>
        NotificationActionType.chat,
      'REWARD' ||
      'MEDAL' ||
      'MEDAL_NOTIFICATION' ||
      'BADGE_EARNED' ||
      'REWARD_TIER_UPDATED' =>
        NotificationActionType.statusUpdateDialog,
      'PAYMENT_SUCCESS' ||
      'PAYMENT_COMPLETE' ||
      'PAYMENT_COMPLETED' ||
      'PAYMENT_EXPIRED' ||
      'PAYMENT_FAILED' =>
        NotificationActionType.payment,
      'SYSTEM' ||
      'CONTENT_APPROVED' ||
      'CONTENT_REJECTED' ||
      'CONTENT_TAKEN_DOWN' =>
        NotificationActionType.infoDialog,
      _ => NotificationActionType.none,
    };
  }

  static NotificationType _resolveNotificationType(String type) {
    return switch (_normaliseType(type)) {
      'WELCOME' => NotificationType.welcome,
      'BIRTHDAY' => NotificationType.birthday,
      'EVENT_JOIN' || 'JOIN_EVENT' || 'EVENT_JOINED' => NotificationType.eventJoin,
      'EVENT_REMINDER' ||
      'HOBBY_EVENT_REMINDER' ||
      'EVENT_RATE_REMINDER' =>
        NotificationType.eventReminder,
      'EVENT_CONFIRMED' || 'EVENT_JOIN_CONFIRMED' => NotificationType.eventConfirmed,
      'EVENT_CANCELLED' || 'EVENT_CANCELED' => NotificationType.eventCancelled,
      'EVENT_CREATED' || 'CREATED_EVENT' => NotificationType.eventCreated,
      'EVENT_MATCHED' ||
      'MATCHED_EVENT' ||
      'MATCHED' =>
        NotificationType.eventMatched,
      'EVENT_RATE' || 'RATE_EVENT' => NotificationType.eventRate,
      'CHECKIN' || 'CHECKIN_CONFIRMED' => NotificationType.checkin,
      'CHAT' || 'EVENT_CHAT_OPENED' || 'CHAT_MESSAGE' => NotificationType.chat,
      'BLOG_COMMENT' || 'BLOG_COMMENTED' => NotificationType.blogComment,
      'BLOG_FOLLOW' || 'BLOG_NEW_POST_FOLLOWED_AUTHOR' => NotificationType.blogFollow,
      'NEW_BLOG' ||
      'BLOG_NEW' ||
      'BLOG_ADDED' ||
      'BLOG_NEW_POST_HOBBY_CATEGORY' =>
        NotificationType.blogNew,
      'REWARD' ||
      'MEDAL' ||
      'MEDAL_NOTIFICATION' ||
      'BADGE_EARNED' ||
      'REWARD_TIER_UPDATED' =>
        NotificationType.reward,
      'PAYMENT_SUCCESS' ||
      'PAYMENT_COMPLETE' ||
      'PAYMENT_COMPLETED' =>
        NotificationType.paymentSuccess,
      'PAYMENT_EXPIRED' || 'PAYMENT_FAILED' => NotificationType.paymentExpired,
      'STATUS_UPDATE' => NotificationType.statusUpdate,
      _ => NotificationType.unknown,
    };
  }
}
