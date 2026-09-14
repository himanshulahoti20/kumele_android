import 'package:flutter/material.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/icons.dart';
import 'package:kuemele/shared/widgets/app_rounded_icon_button.dart';

/// Shared shell for the "compact alert" family of notification popups
/// (birthday, event cancelled, reward medal, generic message) — fixed
/// 24pt padding, 22pt radius, top-right close button. Content is supplied
/// by the caller; this only standardizes the chrome so it isn't
/// re-implemented per popup.
class NotificationAlertCard extends StatelessWidget {
  const NotificationAlertCard({super.key, required this.child, this.onClose});

  final Widget child;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: ColorSet.bg2Color,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: AppRoundedIconButton(
              assetPath: IconSet.closeIcon,
              iconSize: 24,
              padding: 0,
              onTap: onClose ?? () => Navigator.of(context).pop(),
            ),
          ),
          const SizedBox(height: 4),
          child,
        ],
      ),
    );
  }
}
