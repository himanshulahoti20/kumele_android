import 'package:flutter/material.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/icons.dart';
import 'package:kuemele/shared/modals/dialog/notification_alert_card.dart';

/// Generic title+message popup for notification types that don't need
/// bespoke content (e.g. SYSTEM, CONTENT_APPROVED/REJECTED/TAKEN_DOWN).
class NotificationInfoDialog extends StatelessWidget {
  const NotificationInfoDialog({
    super.key,
    required this.title,
    required this.message,
  });

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return NotificationAlertCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(IconSet.megaphone, width: 56, height: 56),
          const SizedBox(height: 14),
          Text(
            title,
            textAlign: TextAlign.center,
            style: context.textTheme.heading3.copyWith(
              color: ColorSet.textColor,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            message,
            textAlign: TextAlign.center,
            style: context.textTheme.bodyLarge.copyWith(
              color: ColorSet.textColor,
              fontSize: 15,
              height: 1.25,
            ),
          ),
        ],
      ),
    );
  }
}
