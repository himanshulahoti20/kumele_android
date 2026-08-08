import 'package:flutter/material.dart';
import 'package:kuemele/gen/assets.gen.dart';
import 'package:kuemele/features/explore/presentation/notification/notification_data.dart';
import 'package:kuemele/l10n/app_localizations_en.dart';
import 'package:kuemele/shared/widgets/dropdown_textfield/dropdown_textfield.dart';

class ExploreEventItem {
  const ExploreEventItem({
    required this.id,
    required this.title,
    required this.imagePath,
    this.category,
    required this.hostName,
    this.hostAvatar,
    this.status,
    required this.time,
    required this.price,
    required this.guests,
    required this.startTime,
    this.location = '--',
  });

  final String id;
  final String title;
  final String imagePath;
  final String? category;
  final String hostName;
  final String? hostAvatar;
  final String? status;
  final String time;
  final String price;
  final String guests;
  final String startTime;
  final String location;

  String? get tagLabel {
    final hobby = category?.trim();
    if (hobby != null && hobby.isNotEmpty) return hobby;

    final eventStatus = status?.trim();
    if (eventStatus != null && eventStatus.isNotEmpty) return eventStatus;

    return null;
  }

  String get startInLabel => startTime.replaceFirst('Start in ', '');
}

class ExploreNotificationItem {
  const ExploreNotificationItem({
    required this.imagePath,
    required this.title,
    required this.time,
    required this.category,
    required this.subText,
  });

  final String imagePath;
  final String title;
  final String time;
  final String category;
  final String subText;
}

class ExploreActionButtonItem {
  const ExploreActionButtonItem({
    required this.iconPath,
    required this.label,
  });

  final String iconPath;
  final String label;
}

class ExploreConfig {
  ExploreConfig._();

  static const double cardSpacing = 20;
  static const double tableRowGap = 15;
  static const double tableColumnGap = 15;

  // NOTE: `notificationItems` and `notifications` below are legacy mock
  // fixture data (unused/duplicated placeholder entries superseded by the
  // real API-backed NotificationListView + notification_data.dart). Their
  // per-item copy (fake names/titles/descriptions) is not localized —
  // treated as sample data, not static app copy.
  static final List<NotificationItem> notificationItems = [
    NotificationItem(
      id: 'event-join',
      title: 'Hot Yoga',
      timeLabel: '12:00 PM',
      description: 'You are following this event host. Be the first to join.',
      accentText: 'Alkesh kumar',
      leadingAssetPath: 'assets/icons/eventshare.png',
      tags: [
        NotificationTag(label: 'Spirituality'),
        NotificationTag(
          label: 'Join Now',
          hasIcon: false,
          backgroundColor: Color(0xFF004DFF),
          textColor: Colors.white,
        ),
      ],
      actionType: NotificationActionType.eventJoinPreview,
    ),
    NotificationItem(
      id: 'welcome',
      title: 'Welcome to Kuemele',
      timeLabel: '10:22 AM',
      description:
          'The host unfortunately cancelled the event. We apologize for the inconvenience.',
      leadingAssetPath: 'assets/logo/kumele_logo.png',
      leadingBackgroundColor: const Color(0xFF004DFF),
      actionType: NotificationActionType.welcomeDialog,
    ),
    NotificationItem(
      id: 'blog-comment',
      title: 'Blog Comment',
      timeLabel: '9:05 AM',
      description:
          'Singleton of Glen Ord 38... Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint.',
      leadingAssetPath: 'assets/icons/bookshelf2.png',
      leadingBorder: Border.all(color: Colors.grey, width: 2),
      actionType: NotificationActionType.blogComment,
    ),
    NotificationItem(
      id: 'status-update',
      title: 'John Doe',
      timeLabel: '8:40 AM',
      description:
          'Congratulation and enjoy your reward. Next status is silver.',
      accentText: null,
      leadingAssetPath: 'assets/testImage2.png',
      tags: [
        NotificationTag(label: 'Bronze'),
      ],
      actionType: NotificationActionType.statusUpdateDialog,
    ),
    NotificationItem(
      id: 'birthday',
      title: 'Hey Alkesh',
      timeLabel: 'Yesterday',
      description:
          'Enjoy 8% discount of one in-app purchase of choice. Offer for last 3 days.',
      leadingAssetPath: 'assets/testImage2.png',
      tags: [
        NotificationTag(label: 'Happy Birthday'),
      ],
      actionType: NotificationActionType.birthdayDialog,
    ),
    NotificationItem(
      id: 'cancelled',
      title: 'Event Cancelled',
      timeLabel: 'Yesterday',
      description:
          'The host unfortunately cancelled the event. We apologize for the inconvenience.',
      leadingAssetPath: 'assets/logo/kumele_logo.png',
      leadingBackgroundColor: const Color(0xFF004DFF),
      isRead: true,
      actionType: NotificationActionType.eventCancelledDialog,
    ),
  ];

  static final List<ExploreNotificationItem> notifications = [
    ExploreNotificationItem(
      imagePath: Assets.icons.eventshare.path,
      title: 'Hot Yoga',
      time: '12:33 PM',
      category: 'Sprirituality',
      subText: 'Akesh kumar You are following this event host.',
    ),
    ExploreNotificationItem(
      imagePath: Assets.icons.create4.path,
      title: 'Meditation',
      time: '2:00 PM',
      category: 'Mindfulness',
      subText: 'Be the first to join.',
    ),
    ExploreNotificationItem(
      imagePath: Assets.icons.eventshare.path,
      title: 'Hot Yoga',
      time: '12:33 PM',
      category: 'Sprirituality',
      subText: 'Akesh kumar You are following this event host.',
    ),
    ExploreNotificationItem(
      imagePath: Assets.icons.create4.path,
      title: 'Meditation',
      time: '2:00 PM',
      category: 'Mindfulness',
      subText: 'Be the first to join.',
    ),
    ExploreNotificationItem(
      imagePath: Assets.icons.eventshare.path,
      title: 'Hot Yoga',
      time: '12:33 PM',
      category: 'Sprirituality',
      subText: 'Akesh kumar You are following this event host.',
    ),
    ExploreNotificationItem(
      imagePath: Assets.icons.create4.path,
      title: 'Meditation',
      time: '2:00 PM',
      category: 'Mindfulness',
      subText: 'Be the first to join.',
    ),
  ];

  static final List<String> galleryImagePaths = [
    Assets.icons.create1.path,
    Assets.icons.create2.path,
    Assets.icons.create3.path,
    Assets.icons.create4.path,
    Assets.icons.create5.path,
    Assets.icons.create6.path,
    Assets.icons.create7.path,
    Assets.icons.create8.path,
  ];

  static List<ExploreActionButtonItem> get headerActionButtons => [
        ExploreActionButtonItem(
          iconPath: Assets.icons.van.path,
          label: AppLocalizationsEn().exploreCategoryVanLife,
        ),
        ExploreActionButtonItem(
          iconPath: Assets.icons.shiba.path,
          label: AppLocalizationsEn().exploreCategoryPetLove,
        ),
        ExploreActionButtonItem(
          iconPath: Assets.icons.yinYang.path,
          label: AppLocalizationsEn().exploreCategorySpirituality,
        ),
        ExploreActionButtonItem(
          iconPath: Assets.icons.knight.path,
          label: AppLocalizationsEn().exploreCategoryBoardGames,
        ),
      ];

  // NOTE: mock search suggestions (fake IDs baked into the label) — sample
  // data, not localized.
  static const List<DropDownValueModel> searchDropdownItems = [
    DropDownValueModel(name: 'Hot Yoga - ID 20243436B', value: 'Hot Yoga'),
    DropDownValueModel(name: 'Pet Love - ID 20243436B', value: 'Pet Love'),
    DropDownValueModel(
      name: 'Spirituality - ID 20243436B',
      value: 'Spirituality',
    ),
  ];

  // Unused elsewhere in the app (legacy mock data) — left hardcoded.
  static const String swipeCardHostMedalTierLabel = 'Gold';
  static const int swipeCardDefaultFollowers = 50;
  static const int swipeCardHostMedalBadgeCount = 22;
  static const double swipeCardDefaultHostRating = 4.5;

  static const double hostStatsAvatarReferenceSize = 74;
  static const double hostStatsBannerMarginLeft = 50;
  static const double hostStatsBannerContentPaddingLeft = 40;

  static double hostStatsBannerMargin(double avatarSize) {
    return avatarSize *
        (hostStatsBannerMarginLeft / hostStatsAvatarReferenceSize);
  }

  static double hostStatsBannerContentPadding(double avatarSize) {
    return avatarSize *
        (hostStatsBannerContentPaddingLeft / hostStatsAvatarReferenceSize);
  }
}
