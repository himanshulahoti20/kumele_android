import 'package:flutter/material.dart';
import 'package:kuemele/gen/assets.gen.dart';
import 'package:kuemele/l10n/app_localizations_en.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/theme/app_image.dart';
import 'package:kuemele/shared/widgets/kumele_asset_widget.dart';

enum ProfileSettingAction {
  myEvents,
  notifications,
  languages,
  cardPayments,
  security,
  contact,
  guidelines,
  referFriend,
  termsAndConditions,
  nightMode,
  deleteAccount,
  signOut,
}

class ProfileSettingItem {
  const ProfileSettingItem({
    required this.title,
    required this.iconPath,
    required this.action,
    this.showTrailingArrow = true,
  });

  final String title;
  final String iconPath;
  final ProfileSettingAction action;
  final bool showTrailingArrow;
}

class ProfileFollower {
  const ProfileFollower({
    required this.profileImage,
    required this.name,
  });

  final String profileImage;
  final String name;
}

class ProfileStatItem {
  const ProfileStatItem({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;
}

class InterestsModel {
  final String? id;
  final String svgCode;
  final String? iconAsset;
  final String title;
  bool isSelected;

  InterestsModel({
    this.id,
    this.svgCode = '',
    this.iconAsset,
    required this.title,
    required this.isSelected,
  });

  Widget buildIcon({double size = 24, Color? color}) {
    final path =
        (iconAsset != null && iconAsset!.isNotEmpty) ? iconAsset! : svgCode;

    if (path.isNotEmpty) {
      return KumeleAssetWidget(
        assetPath: path,
        width: size,
        height: size,
        color: color,
      );
    }

    return SizedBox(width: size, height: size);
  }

  Widget buildSvgFromString({double size = 24, Color? color}) {
    return buildIcon(size: size, color: color);
  }

  InterestsModel copyWith({
    String? id,
    String? svgCode,
    String? iconAsset,
    String? title,
    bool? isSelected,
  }) {
    return InterestsModel(
      id: id ?? this.id,
      svgCode: svgCode ?? this.svgCode,
      iconAsset: iconAsset ?? this.iconAsset,
      title: title ?? this.title,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}

class MedalsModel {
  final String imagePath;
  final String title;
  final String subtitle;

  const MedalsModel({
    required this.imagePath,
    required this.title,
    required this.subtitle,
  });
}

class ProfileConfig {
  ProfileConfig._();

  static const String mockGoldStatus = '0';

  static String _iconPath(AssetGenImage light, AssetGenImage dark) {
    return ColorSet.isDarkMode ? dark.path : light.path;
  }

  static String get myEventsIcon =>
      _iconPath(Assets.icons.eventsCalendar, Assets.icons.eventsCalendarDark);

  static String get soundIcon =>
      _iconPath(Assets.icons.sound, Assets.icons.soundDark);

  static String get atmIcon =>
      _iconPath(Assets.icons.atmCard, Assets.icons.atmCardDark);

  static String get lockIcon =>
      _iconPath(Assets.icons.lock, Assets.icons.lockDark);

  static String get headSetIcon =>
      _iconPath(Assets.icons.headset, Assets.icons.headsetDark);

  static String get guideLineIcon =>
      _iconPath(Assets.icons.guideline, Assets.icons.guidelineDark);

  static String get cardGroupIcon =>
      _iconPath(Assets.icons.groupCard, Assets.icons.groupCardDark);

  static String get iIcon => _iconPath(Assets.icons.i, Assets.icons.iDark);

  static String get nightModeIcon =>
      _iconPath(Assets.icons.nightMode, Assets.icons.nightModeDark);

  static String get warningIcon =>
      _iconPath(Assets.icons.warning, Assets.icons.warningDark);

  static String get signOutIcon =>
      _iconPath(Assets.icons.signoutPng, Assets.icons.signoutDark);

  static String get arrowRightIcon =>
      _iconPath(Assets.icons.arrowRight, Assets.icons.arrowRightDark);

  static String get editIcon => Assets.svg.iconEdit.path;

  static List<ProfileStatItem> profileStats({
    required int followingCount,
    required int followersCount,
    required String goldStatus,
  }) =>
      [
        ProfileStatItem(
          label: AppLocalizationsEn().following,
          value: followingCount.toString(),
        ),
        ProfileStatItem(
          label: AppLocalizationsEn().followers,
          value: followersCount.toString(),
        ),
        ProfileStatItem(
          label: AppLocalizationsEn().goldStatus,
          value: goldStatus,
        ),
      ];

  static String get languagesIcon => Assets.svg.iconCommunication.path;

  static List<ProfileSettingItem> primarySettings() => [
        ProfileSettingItem(
          title: AppLocalizationsEn().myEvents,
          iconPath: myEventsIcon,
          action: ProfileSettingAction.myEvents,
        ),
        ProfileSettingItem(
          title: AppLocalizationsEn().notifications,
          iconPath: soundIcon,
          action: ProfileSettingAction.notifications,
        ),
        ProfileSettingItem(
          title: AppLocalizationsEn().cardPaymentsSubscriptions,
          iconPath: atmIcon,
          action: ProfileSettingAction.cardPayments,
        ),
        ProfileSettingItem(
          title: AppLocalizationsEn().security,
          iconPath: lockIcon,
          action: ProfileSettingAction.security,
        ),
      ];

  static List<ProfileSettingItem> secondarySettings() => [
        ProfileSettingItem(
          title: AppLocalizationsEn().languages,
          iconPath: languagesIcon,
          action: ProfileSettingAction.languages,
        ),
        ProfileSettingItem(
          title: AppLocalizationsEn().contact,
          iconPath: headSetIcon,
          action: ProfileSettingAction.contact,
        ),
        ProfileSettingItem(
          title: AppLocalizationsEn().guidelines,
          iconPath: guideLineIcon,
          action: ProfileSettingAction.guidelines,
        ),
        ProfileSettingItem(
          title: AppLocalizationsEn().referAFriend,
          iconPath: cardGroupIcon,
          action: ProfileSettingAction.referFriend,
        ),
        ProfileSettingItem(
          title: AppLocalizationsEn().termsAndConditions,
          iconPath: iIcon,
          action: ProfileSettingAction.termsAndConditions,
        ),
        ProfileSettingItem(
          title: AppLocalizationsEn().nightMode,
          iconPath: nightModeIcon,
          action: ProfileSettingAction.nightMode,
          showTrailingArrow: false,
        ),
        ProfileSettingItem(
          title: AppLocalizationsEn().deleteAccount,
          iconPath: warningIcon,
          action: ProfileSettingAction.deleteAccount,
        ),
        ProfileSettingItem(
          title: AppLocalizationsEn().signOut,
          iconPath: signOutIcon,
          action: ProfileSettingAction.signOut,
        ),
      ];

  static List<ProfileFollower> demoFollowers() => [
        ProfileFollower(
          profileImage: Assets.testImage2.path,
          name: 'John Doe',
        ),
        ProfileFollower(
          profileImage: Assets.testImage3.path,
          name: 'Emma Smith',
        ),
        ProfileFollower(
          profileImage: Assets.testImage4.path,
          name: 'Chris Johnson',
        ),
        ProfileFollower(
          profileImage: Assets.testImage5.path,
          name: 'Alice Williams',
        ),
        ProfileFollower(
          profileImage: Assets.testImage2.path,
          name: 'Bob Anderson',
        ),
        ProfileFollower(
          profileImage: Assets.testImage3.path,
          name: 'Eva Brown',
        ),
        ProfileFollower(
          profileImage: Assets.testImage4.path,
          name: 'Daniel White',
        ),
        ProfileFollower(
          profileImage: Assets.testImage5.path,
          name: 'Grace Taylor',
        ),
        ProfileFollower(
          profileImage: Assets.testImage2.path,
          name: 'Michael Davis',
        ),
        ProfileFollower(
          profileImage: Assets.testImage3.path,
          name: 'Sophia Miller',
        ),
        ProfileFollower(
          profileImage: Assets.testImage4.path,
          name: 'David Wilson',
        ),
        ProfileFollower(
          profileImage: Assets.testImage5.path,
          name: 'Olivia Jackson',
        ),
        ProfileFollower(
          profileImage: Assets.testImage2.path,
          name: 'Liam Garcia',
        ),
        ProfileFollower(
          profileImage: Assets.testImage3.path,
          name: 'Ava Martinez',
        ),
        ProfileFollower(
          profileImage: Assets.testImage4.path,
          name: 'Noah Taylor',
        ),
        ProfileFollower(
          profileImage: Assets.testImage5.path,
          name: 'Isabella Harris',
        ),
        ProfileFollower(
          profileImage: Assets.testImage2.path,
          name: 'Ethan Moore',
        ),
        ProfileFollower(
          profileImage: Assets.testImage3.path,
          name: 'Mia Clark',
        ),
        ProfileFollower(
          profileImage: Assets.testImage4.path,
          name: 'James Lee',
        ),
        ProfileFollower(
          profileImage: Assets.testImage5.path,
          name: 'Sophie Allen',
        ),
        ProfileFollower(
          profileImage: Assets.testImage2.path,
          name: 'Lily Turner',
        ),
        ProfileFollower(
          profileImage: Assets.testImage3.path,
          name: 'Elijah Brown',
        ),
        ProfileFollower(
          profileImage: Assets.testImage4.path,
          name: 'Aria Moore',
        ),
      ];

  static List<ProfileFollower> demoFollowing() => [
        ProfileFollower(
          profileImage: Assets.testImage2.path,
          name: 'Bob Anderson',
        ),
        ProfileFollower(
          profileImage: Assets.testImage4.path,
          name: 'Daniel White',
        ),
        ProfileFollower(
          profileImage: Assets.testImage5.path,
          name: 'Grace Taylor',
        ),
        ProfileFollower(
          profileImage: Assets.testImage2.path,
          name: 'Michael Davis',
        ),
        ProfileFollower(
          profileImage: Assets.testImage4.path,
          name: 'David Wilson',
        ),
        ProfileFollower(
          profileImage: Assets.testImage5.path,
          name: 'Isab ella Harris',
        ),
        ProfileFollower(
          profileImage: Assets.testImage3.path,
          name: 'Mia Clark',
        ),
        ProfileFollower(
          profileImage: Assets.testImage4.path,
          name: 'James Lee',
        ),
      ];

  static List<InterestsModel> placeholderInterests() => [
        InterestsModel(
          iconAsset: SVGAsset.icon_van,
          title: AppLocalizationsEn().exploreCategoryVanLife,
          isSelected: false,
        ),
        InterestsModel(
          iconAsset: SVGAsset.icon_yinyang,
          title: AppLocalizationsEn().spirituality,
          isSelected: false,
        ),
        InterestsModel(
          iconAsset: SVGAsset.icon_knight,
          title: AppLocalizationsEn().exploreCategoryBoardGames,
          isSelected: false,
        ),
        InterestsModel(
          iconAsset: SVGAsset.icon_movie,
          title: AppLocalizationsEn().interestMovies,
          isSelected: false,
        ),
        InterestsModel(
          iconAsset: SVGAsset.icon_sport,
          title: AppLocalizationsEn().blogCategorySports,
          isSelected: false,
        ),
        InterestsModel(
          iconAsset: SVGAsset.icon_pub,
          title: AppLocalizationsEn().interestPubsAndBars,
          isSelected: false,
        ),
        InterestsModel(
          iconAsset: SVGAsset.icon_live_show,
          title: AppLocalizationsEn().interestLiveShow,
          isSelected: false,
        ),
        InterestsModel(
          iconAsset: SVGAsset.icon_clubbing,
          title: AppLocalizationsEn().interestClubbing,
          isSelected: false,
        ),
        InterestsModel(
          iconAsset: SVGAsset.icon_festival,
          title: AppLocalizationsEn().interestFestival,
          isSelected: false,
        ),
        InterestsModel(
          iconAsset: SVGAsset.icon_outdoor,
          title: AppLocalizationsEn().interestOutdoors,
          isSelected: false,
        ),
        InterestsModel(
          iconAsset: SVGAsset.icon_volunteer,
          title: AppLocalizationsEn().interestVolunteer,
          isSelected: false,
        ),
        InterestsModel(
          iconAsset: SVGAsset.icon_diy,
          title: AppLocalizationsEn().interestDiy,
          isSelected: false,
        ),
        InterestsModel(
          iconAsset: SVGAsset.icon_activism,
          title: AppLocalizationsEn().interestActivism,
          isSelected: false,
        ),
        InterestsModel(
          iconAsset: SVGAsset.icon_pet,
          title: AppLocalizationsEn().interestPetLove,
          isSelected: false,
        ),
        InterestsModel(
          iconAsset: SVGAsset.icon_video_game,
          title: AppLocalizationsEn().interestVideoGames,
          isSelected: false,
        ),
        InterestsModel(
          iconAsset: SVGAsset.icon_family,
          title: AppLocalizationsEn().interestFamilyActivities,
          isSelected: false,
        ),
        InterestsModel(
          iconAsset: SVGAsset.icon_tech,
          title: AppLocalizationsEn().interestTech,
          isSelected: false,
        ),
        InterestsModel(
          iconAsset: SVGAsset.icon_costume,
          title: AppLocalizationsEn().interestCostume,
          isSelected: false,
        ),
        InterestsModel(
          iconAsset: SVGAsset.icon_foodie,
          title: AppLocalizationsEn().interestFoodie,
          isSelected: false,
        ),
        InterestsModel(
          iconAsset: SVGAsset.icon_party,
          title: AppLocalizationsEn().discoverMockPartyTypeLabel,
          isSelected: false,
        ),
        InterestsModel(
          iconAsset: SVGAsset.icon_camping,
          title: AppLocalizationsEn().interestCamping,
          isSelected: false,
        ),
      ];

  static final List<MedalsModel> medals = [
    MedalsModel(
      imagePath: Assets.icons.medalPng.path,
      title: AppLocalizationsEn().medalBronzeTitle,
      subtitle: AppLocalizationsEn().medalBronzeSubtitle,
    ),
    MedalsModel(
      imagePath: Assets.icons.medalPng.path,
      title: AppLocalizationsEn().medalSilverTitle,
      subtitle: AppLocalizationsEn().medalSilverSubtitle,
    ),
    MedalsModel(
      imagePath: Assets.icons.medalPng.path,
      title: AppLocalizationsEn().medalGoldTitle,
      subtitle: AppLocalizationsEn().medalGoldSubtitle,
    ),
  ];
}

typedef Follower = ProfileFollower;

final List<Follower> demoFollowers = ProfileConfig.demoFollowers();
final List<Follower> demoFollowing = ProfileConfig.demoFollowing();
