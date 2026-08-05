import 'package:flutter/material.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/features/explore/presentation/widgets/explore_notification_list_view.dart';
import 'package:kuemele/shared/components/app_colors.dart';

class ExploreNotificationsPanel extends StatelessWidget {
  const ExploreNotificationsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.fromLTRB(18, 15, 18, 0),
        decoration: BoxDecoration(
          color: ColorSet.bg3Color,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Notifications',
              style: context.textTheme.headlineSmallBold.copyWith(
                color: ColorSet.textColor,
              ),
            ),
            const ExploreNotificationListView(),
          ],
        ),
      ),
    );
  }
}
