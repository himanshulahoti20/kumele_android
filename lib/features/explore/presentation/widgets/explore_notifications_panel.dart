import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/features/explore/presentation/notification/notification_bloc.dart';
import 'package:kuemele/features/explore/presentation/notification/notification_event.dart';
import 'package:kuemele/features/explore/presentation/notification/notification_state.dart';
import 'package:kuemele/features/explore/presentation/notification/widgets/notification_list_view.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/services/pagination/pagination_state.dart';

class ExploreNotificationsPanel extends StatefulWidget {
  const ExploreNotificationsPanel({super.key});

  @override
  State<ExploreNotificationsPanel> createState() =>
      _ExploreNotificationsPanelState();
}

class _ExploreNotificationsPanelState extends State<ExploreNotificationsPanel> {
  @override
  void initState() {
    super.initState();
    if (InjectionHelper.notificationBloc.state.status ==
        PaginationStatus.initial) {
      InjectionHelper.notificationBloc.add(const NotificationsRequested());
    }
  }

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
            Expanded(
              child: BlocBuilder<NotificationBloc, NotificationState>(
                bloc: InjectionHelper.notificationBloc,
                builder: (context, state) {
                  return NotificationListView(
                    notifications: state.notifications.take(5).toList(),
                    isLoading: state.status == PaginationStatus.initial ||
                        state.isLoading,
                    onNotificationTap: (id) =>
                        InjectionHelper.notificationBloc.add(
                      NotificationTapped(id),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
