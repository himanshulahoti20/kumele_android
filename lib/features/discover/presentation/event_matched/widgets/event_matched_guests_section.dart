import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/core/responsive/responsive.dart';
import 'package:kuemele/features/discover/presentation/discover_config.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/widgets/app_avatar.dart';

class EventMatchedGuestsSection extends StatelessWidget {
  const EventMatchedGuestsSection({
    super.key,
    required this.guestCount,
    required this.attendees,
  });

  final int guestCount;
  final List<DiscoverMatchedAttendee> attendees;

  @override
  Widget build(BuildContext context) {
    if (attendees.isEmpty) {
      return const SizedBox.shrink();
    }

    final responsive = context.responsive;
    final avatarSize = responsive.w(
      responsive.pick(
        mobilePortrait: 56.0,
        tabletPortrait: 64.0,
      ),
    );
    final guestLabel = '$guestCount ${DiscoverConfig.guestsLabelSuffix}';
    final visibleAttendees = attendees.take(2).toList();

    return Padding(
      padding: EdgeInsets.only(top: responsive.h(16)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < visibleAttendees.length; i++) ...[
                if (i > 0) Gap(responsive.w(28)),
                _AttendeeColumn(
                  attendee: visibleAttendees[i],
                  avatarSize: avatarSize,
                ),
              ],
            ],
          ),
          Gap(responsive.h(14)),
          _GuestCountPill(label: guestLabel),
        ],
      ),
    );
  }
}

class _AttendeeColumn extends StatelessWidget {
  const _AttendeeColumn({
    required this.attendee,
    required this.avatarSize,
  });

  final DiscoverMatchedAttendee attendee;
  final double avatarSize;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final ringBorderWidth = avatarSize * 0.055;
    final ringPadding = 1.0;
    final innerAvatarSize =
        avatarSize - (ringBorderWidth * 2) - (ringPadding * 2);

    return SizedBox(
      width: responsive.w(88),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: avatarSize,
            height: avatarSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: attendee.borderColor,
                width: ringBorderWidth,
              ),
            ),
            padding: EdgeInsets.all(ringPadding),
            child: _buildAvatarImage(context, innerAvatarSize),
          ),
          Gap(responsive.h(8)),
          Text(
            attendee.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: context.textTheme.bodyLargeLight.copyWith(
              color: ColorSet.bg2Color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarImage(BuildContext context, double size) {
    final path = attendee.avatarPath.trim();
    final isNetwork = path.startsWith('http://') || path.startsWith('https://');

    if (isNetwork) {
      return AppAvatar(
        size: size,
        imageUrl: path,
        name: attendee.name,
        showShadow: false,
        border: null,
      );
    } else if (path.startsWith('assets/') || path.isNotEmpty) {
      return ClipOval(
        child: SizedBox(
          width: size,
          height: size,
          child: Image.asset(
            path,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => AppAvatar(
              size: size,
              imageUrl: null,
              name: attendee.name,
              showShadow: false,
              border: null,
            ),
          ),
        ),
      );
    } else {
      return AppAvatar(
        size: size,
        imageUrl: null,
        name: attendee.name,
        showShadow: false,
        border: null,
      );
    }
  }
}

class _GuestCountPill extends StatelessWidget {
  const _GuestCountPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: responsive.w(14),
        vertical: responsive.h(6),
      ),
      decoration: BoxDecoration(
        color: ColorSet.bg2Color,
        borderRadius: BorderRadius.circular(responsive.w(20)),
      ),
      child: Text(
        label,
        style: context.textTheme.bodySmallSemiBold.copyWith(
          color: ColorSet.textColor,
        ),
      ),
    );
  }
}
