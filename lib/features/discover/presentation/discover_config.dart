import 'package:flutter/material.dart';
import 'package:kuemele/gen/assets.gen.dart';
import 'package:kuemele/shared/components/app_colors.dart';

class DiscoverMatchedAttendee {
  const DiscoverMatchedAttendee({
    required this.name,
    required this.avatarPath,
    required this.borderColor,
  });

  final String name;
  final String avatarPath;
  final Color borderColor;
}

class DiscoverMatchedEventData {
  const DiscoverMatchedEventData({
    this.eventId = '',
    required this.title,
    required this.categoryIconPath,
    required this.guestCount,
    required this.attendees,
    required this.backgroundImagePath,
    required this.heroImagePath,
    required this.confettiAnimationPath,
  });

  final String eventId;
  final String title;
  final String categoryIconPath;
  final int guestCount;
  final List<DiscoverMatchedAttendee> attendees;
  final String backgroundImagePath;
  final String heroImagePath;
  final String confettiAnimationPath;

  DiscoverMatchedEventData copyWith({
    String? eventId,
    String? title,
    String? categoryIconPath,
    int? guestCount,
    List<DiscoverMatchedAttendee>? attendees,
    String? backgroundImagePath,
    String? heroImagePath,
    String? confettiAnimationPath,
  }) {
    return DiscoverMatchedEventData(
      eventId: eventId ?? this.eventId,
      title: title ?? this.title,
      categoryIconPath: categoryIconPath ?? this.categoryIconPath,
      guestCount: guestCount ?? this.guestCount,
      attendees: attendees ?? this.attendees,
      backgroundImagePath: backgroundImagePath ?? this.backgroundImagePath,
      heroImagePath: heroImagePath ?? this.heroImagePath,
      confettiAnimationPath:
          confettiAnimationPath ?? this.confettiAnimationPath,
    );
  }
}

class DiscoverConfig {
  DiscoverConfig._();

  static const String goToChatLabel = 'Go to chat';
  static const String guestsLabelSuffix = 'guests';

  static const double dialogWidthPercentPhone = 0.88;
  static const double dialogHeightPercentPhone = 0.58;
  static const double dialogWidthPercentTablet = 0.55;
  static const double dialogHeightPercentTablet = 0.62;

  static final List<DiscoverMatchedAttendee> matchedAttendees = [
    DiscoverMatchedAttendee(
      name: 'Ankit',
      avatarPath: Assets.blogImage1.path,
      borderColor: ColorSet.specialYellowColor,
    ),
    DiscoverMatchedAttendee(
      name: 'Alkesh',
      avatarPath: Assets.blogImage2.path,
      borderColor: ColorSet.specialBlueColor,
    ),
  ];

  static DiscoverMatchedEventData matchedEvent({
    String? eventId,
    int? guestCount,
    String? title,
    String? eventImagePath,
    String? categoryIconPath,
    List<DiscoverMatchedAttendee>? attendees,
  }) {
    final resolvedEventImage = eventImagePath?.trim();
    return DiscoverMatchedEventData(
      eventId: eventId ?? '',
      title: title ?? 'Group meditation',
      categoryIconPath: categoryIconPath ?? Assets.icons.yinYang.path,
      guestCount: guestCount ?? 12,
      attendees: attendees ?? matchedAttendees,
      backgroundImagePath:
          resolvedEventImage != null && resolvedEventImage.isNotEmpty
              ? resolvedEventImage
              : Assets.icons.create2.path,
      heroImagePath: Assets.icons.itsgo.path,
      confettiAnimationPath: Assets.iconsJson.confetti.path,
    );
  }
}
