import 'package:kuemele/gen/assets.gen.dart';
import 'package:kuemele/l10n/app_localizations_en.dart';

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
