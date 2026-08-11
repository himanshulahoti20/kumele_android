import 'package:flutter/material.dart';
import 'package:kuemele/features/explore/domain/entities/event_guest_entity.dart';
import 'package:kuemele/features/explore/domain/entities/explore_event_detail.dart';
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

  static const double dialogWidthPercentPhone = 0.88;
  static const double dialogHeightPercentPhone = 0.58;
  static const double dialogWidthPercentTablet = 0.55;
  static const double dialogHeightPercentTablet = 0.62;

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
      title: title ?? '',
      categoryIconPath: categoryIconPath ?? '',
      guestCount: guestCount ?? 0,
      attendees: attendees ?? const [],
      backgroundImagePath:
          resolvedEventImage != null && resolvedEventImage.isNotEmpty
              ? resolvedEventImage
              : '',
      heroImagePath: Assets.icons.itsgo.path,
      confettiAnimationPath: Assets.iconsJson.confetti.path,
    );
  }

  static List<DiscoverMatchedAttendee> attendeesFor({
    required ExploreEventDetail detail,
    required List<EventGuestEntity> guests,
    required String currentUserName,
    required String currentUserAvatar,
  }) {
    final attendees = guests
        .where(
            (guest) => guest.isConfirmed && guest.user.name.trim().isNotEmpty)
        .map(
          (guest) => DiscoverMatchedAttendee(
            name: guest.user.name,
            avatarPath: guest.user.avatarUrl ?? '',
            borderColor: ColorSet.specialYellowColor,
          ),
        )
        .toList();

    if (attendees.isEmpty && detail.hostName.trim().isNotEmpty) {
      attendees.add(
        DiscoverMatchedAttendee(
          name: detail.hostName,
          avatarPath: detail.hostProfile.avatarUrl ?? '',
          borderColor: ColorSet.specialYellowColor,
        ),
      );
    }

    if (currentUserName.trim().isNotEmpty) {
      attendees.add(
        DiscoverMatchedAttendee(
          name: currentUserName,
          avatarPath: currentUserAvatar,
          borderColor: ColorSet.specialBlueColor,
        ),
      );
    }

    return attendees.take(2).toList(growable: false);
  }
}
