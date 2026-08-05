import 'package:flutter/material.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/features/explore/presentation/notification/notification_data.dart';

class NotificationTagChip extends StatelessWidget {
  const NotificationTagChip({
    super.key,
    required this.tag,
  });

  final NotificationTag tag;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: tag.backgroundColor,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (tag.hasIcon) ...[
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Image.asset(
                tag.iconPath,
                color: tag.iconColor,
                width: 15.44,
                height: 15.44,
              ),
            ),
          ],
          Text(
            tag.label,
            style: context.textTheme.labelSmall.copyWith(
              fontSize: 11.08,
              fontWeight: FontWeight.w500,
              color: tag.textColor,
            ),
          ),
        ],
      ),
    );
  }
}
