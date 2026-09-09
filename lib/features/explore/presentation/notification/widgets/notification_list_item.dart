import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/features/explore/data/mappers/notification_item_mapper.dart';
import 'package:kuemele/features/explore/presentation/notification/notification_data.dart';
import 'package:kuemele/features/explore/presentation/notification/widgets/notification_tag_chip.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/icons.dart';
import 'package:kuemele/shared/widgets/kumele_asset_widget.dart';

class NotificationListItem extends StatelessWidget {
  const NotificationListItem({
    super.key,
    required this.notification,
    required this.onTap,
    this.onAction,
  });

  final NotificationItem notification;
  final VoidCallback onTap;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  _NotificationLeading(notification: notification),
                  if (!notification.isRead)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          color: ColorSet.specialYellowColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: ColorSet.bg3Color),
                        ),
                      ),
                    ),
                ],
              ),
              const Gap(14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: context.textTheme.bodyMediumBold.copyWith(
                              color: ColorSet.textColor,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const Gap(8),
                        Text(
                          notification.timeLabel,
                          style: context.textTheme.bodySmall.copyWith(
                            color: ColorSet.specialBlueColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    if (notification.tags.isNotEmpty ||
                        _actionLabel != null) ...[
                      const Gap(4),
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: [
                          ...notification.tags.map(
                            (tag) => NotificationTagChip(tag: tag),
                          ),
                          if (_actionLabel != null)
                            _NotificationActionChip(
                              label: _actionLabel!,
                              isMuted: _isActionMuted,
                              onTap: _isActionMuted ? null : onAction,
                            ),
                        ],
                      ),
                    ],
                    if (notification.description.isNotEmpty) ...[
                      const Gap(6),
                      _NotificationBody(notification: notification),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? get _actionLabel {
    return switch (notification.type) {
      NotificationType.eventJoin => 'Join now',
      NotificationType.eventMatched =>
        notification.isEventJoined ? 'Matched' : 'Join now',
      // Only the event's own creation notification offers Cancel, and
      // only while the event is still upcoming and active (canCancel) —
      // once it isn't (started, already cancelled, ...) it reads the
      // same as an already-cancelled event.
      NotificationType.eventCreated =>
        notification.canCancel ? 'Cancel' : 'Cancelled',
      NotificationType.eventConfirmed => 'Matched',
      NotificationType.eventCancelled => 'Cancelled',
      _ => null,
    };
  }

  bool get _isActionMuted {
    return notification.type == NotificationType.eventCancelled ||
        notification.type == NotificationType.eventConfirmed ||
        (notification.type == NotificationType.eventCreated &&
            !notification.canCancel) ||
        (notification.type == NotificationType.eventMatched &&
            notification.isEventJoined);
  }
}

class _NotificationLeading extends StatelessWidget {
  const _NotificationLeading({required this.notification});

  final NotificationItem notification;

  @override
  Widget build(BuildContext context) {
    final svgPath =
        NotificationItemMapper.resolveIconSvgPath(notification.iconKey);
    final imagePath = notification.leadingAssetPath;
    final hasImage = imagePath?.isNotEmpty == true;
    final assetPath = hasImage ? imagePath! : (svgPath ?? IconSet.logoImage);

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: notification.leadingBackgroundColor ?? ColorSet.notifIconDefault,
        border: notification.leadingBorder,
      ),
      child: ClipOval(
        child: Padding(
          padding: hasImage || notification.type == NotificationType.welcome
              ? EdgeInsets.zero
              : const EdgeInsets.all(11),
          child: KumeleAssetWidget(
            assetPath: assetPath,
            fit: BoxFit.cover,
            color: hasImage || notification.type == NotificationType.welcome
                ? null
                : Colors.white,
          ),
        ),
      ),
    );
  }
}

class _NotificationBody extends StatelessWidget {
  const _NotificationBody({required this.notification});

  final NotificationItem notification;

  @override
  Widget build(BuildContext context) {
    final bodyTextStyle = context.textTheme.bodySmall.copyWith(
      color: ColorSet.subTextColor,
      fontSize: 12,
      height: 1.35,
    );
    final accentText = notification.accentText;
    if (accentText == null || accentText.isEmpty) {
      return Text(notification.description, style: bodyTextStyle);
    }

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '$accentText ',
            style: bodyTextStyle.copyWith(
              color: ColorSet.specialBlueColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          TextSpan(text: notification.description, style: bodyTextStyle),
        ],
      ),
    );
  }
}

class _NotificationActionChip extends StatelessWidget {
  const _NotificationActionChip({
    required this.label,
    required this.isMuted,
    required this.onTap,
  });

  final String label;
  final bool isMuted;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isMuted ? ColorSet.lightBlueColor : ColorSet.specialBlueColor,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          label,
          style: context.textTheme.labelSmall.copyWith(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
