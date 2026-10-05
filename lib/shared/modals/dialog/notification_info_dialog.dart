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
    this.isBlog = false,
    this.onAction,
  });

  final String title;
  final String message;

  /// Blog notifications show `icBlogComment` and a "Go to Blog" CTA.
  final bool isBlog;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return NotificationAlertCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            isBlog ? IconSet.notificationBlogComment : IconSet.megaphone,
            width: 56,
            height: 56,
          ),
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
          if (isBlog && onAction != null) ...[
            const SizedBox(height: 14 + 6),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
                onAction!();
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 13),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: ColorSet.textColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Go to Blog',
                  style: context.textTheme.bodyLarge.copyWith(
                    color: ColorSet.bg2Color,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
