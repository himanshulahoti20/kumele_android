import 'package:flutter/material.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/features/explore/domain/entities/event_guest_entity.dart';
import 'package:kuemele/l10n/app_localizations.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/widgets/app_avatar.dart';

class ChatGuestAvatarStack extends StatelessWidget {
  const ChatGuestAvatarStack({
    super.key,
    required this.guests,
    required this.guestCount,
    this.avatarSize = 50,
    this.maxVisible = 4,
  });

  final List<EventGuestEntity> guests;
  final int guestCount;
  final double avatarSize;
  final int maxVisible;

  @override
  Widget build(BuildContext context) {
    final visible = guests.take(maxVisible).toList();
    final label = guestCount == 1
        ? '1 ${AppLocalizations.of(context)!.guest}'
        : '$guestCount ${AppLocalizations.of(context)!.guests}';

    if (visible.isEmpty) {
      return _GuestCountPill(label: label);
    }

    final overlap = avatarSize * 0.55;
    final avatarsWidth = avatarSize + (visible.length - 1) * overlap;
    final badgeLeft = avatarsWidth - (avatarSize * 0.15);

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.centerLeft,
      children: [
        Container(
          height: avatarSize,
          padding: EdgeInsets.only(left: badgeLeft),
          alignment: Alignment.centerLeft,
          child: _GuestCountPill(label: label),
        ),
        for (var i = 0; i < visible.length; i++)
          Positioned(
            left: i * overlap,
            child: AppAvatar(
              size: avatarSize,
              imageUrl: visible[i].user.avatarUrl,
              name: visible[i].user.name,
              showShadow: false,
              border: Border.all(
                color: ColorSet.specialBlueColor,
                width: 2.5,
              ),
            ),
          ),
      ],
    );
  }
}

class _GuestCountPill extends StatelessWidget {
  const _GuestCountPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: ColorSet.revbg3Color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: context.textTheme.bodySmall.copyWith(
          color: ColorSet.bg2Color,
          fontWeight: FontWeight.w500,
          fontSize: 10,
        ),
      ),
    );
  }
}
