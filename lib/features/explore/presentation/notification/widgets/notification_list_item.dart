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
  });

  final NotificationItem notification;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: ColorSet.bg3Color,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(12),
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
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(
                          color: ColorSet.specialYellowColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
              const Gap(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: context.textTheme.bodyMediumBold.copyWith(
                              fontSize: 14.19,
                              color: ColorSet.textColor,
                            ),
                          ),
                        ),
                        const Gap(10),
                        Text(
                          notification.timeLabel,
                          style: context.textTheme.bodyMedium.copyWith(
                            color: ColorSet.lightBlueColor,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    if (notification.tags.isNotEmpty) ...[
                      const Gap(5),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: notification.tags
                            .map((tag) => NotificationTagChip(tag: tag))
                            .toList(growable: false),
                      ),
                    ],
                    const Gap(8),
                    _NotificationBody(notification: notification),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NotificationLeading extends StatelessWidget {
  const _NotificationLeading({
    required this.notification,
  });

  final NotificationItem notification;

  @override
  Widget build(BuildContext context) {
    final svgPath =
        NotificationItemMapper.resolveIconSvgPath(notification.iconKey);
    final bgColor =
        notification.leadingBackgroundColor ?? ColorSet.notifIconDefault;
    final assetPath = svgPath ?? IconSet.logoImage;

    final bool applyWhiteTint = notification.type != NotificationType.welcome;

    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: bgColor,
        border: notification.leadingBorder,
      ),
      child: ClipOval(
        child: Padding(
          padding: applyWhiteTint ? const EdgeInsets.all(11) : EdgeInsets.zero,
          child: KumeleAssetWidget(
            assetPath: assetPath,
            fit: BoxFit.cover,
            color: applyWhiteTint ? Colors.white : null,
          ),
        ),
      ),
    );
  }
}

class _NotificationBody extends StatelessWidget {
  const _NotificationBody({
    required this.notification,
  });

  final NotificationItem notification;

  @override
  Widget build(BuildContext context) {
    final accentText = notification.accentText;
    final bodyTextStyle = context.textTheme.bodySmall.copyWith(
      color: ColorSet.textColor,
      fontSize: 13,
    );

    if (accentText == null || accentText.isEmpty) {
      return Text(
        notification.description,
        style: bodyTextStyle,
      );
    }

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '$accentText ',
            style: context.textTheme.bodySmall.copyWith(
              color: ColorSet.lightBlueColor,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          TextSpan(
            text: notification.description,
            style: bodyTextStyle,
          ),
        ],
      ),
    );
  }
}
