import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/features/explore/presentation/notification/notification_actions.dart';
import 'package:kuemele/features/explore/presentation/notification/notification_bloc.dart';
import 'package:kuemele/features/explore/presentation/notification/notification_data.dart';
import 'package:kuemele/features/explore/presentation/notification/notification_event.dart';
import 'package:kuemele/features/explore/presentation/notification/notification_state.dart';
import 'package:kuemele/features/explore/presentation/notification/widgets/notification_list_item.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/services/pagination/pagination_state.dart';
import 'package:kuemele/l10n/app_localizations.dart';

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
              AppLocalizations.of(context)!.exploreNotificationsTitle,
              style: context.textTheme.headlineSmallBold.copyWith(
                color: ColorSet.textColor,
              ),
            ),
            const SizedBox(height: 14),
            Expanded(
              child: BlocBuilder<NotificationBloc, NotificationState>(
                bloc: InjectionHelper.notificationBloc,
                builder: (context, state) {
                  final isLoading = state.status == PaginationStatus.initial ||
                      state.isLoading;
                  final notifications = isLoading && state.notifications.isEmpty
                      ? NotificationItemFactory.createSkeletonPlaceholders(
                          count: 4,
                        )
                      : state.notifications.take(4).toList();

                  if (notifications.isEmpty) {
                    return Center(
                      child: Text(
                        AppLocalizations.of(context)!.noNotificationsTitle,
                        style: context.textTheme.bodyMedium.copyWith(
                          color: ColorSet.profileSubTextColor,
                        ),
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: EdgeInsets.zero,
                    itemCount: notifications.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 2),
                    itemBuilder: (context, index) {
                      final notification = notifications[index];
                      return NotificationListItem(
                        notification: notification,
                        onTap: isLoading
                            ? () {}
                            : () async {
                                InjectionHelper.notificationBloc.add(
                                  NotificationTapped(notification.id),
                                );
                                await handleNotificationAction(
                                  context,
                                  notification,
                                );
                              },
                        onAction: isLoading
                            ? null
                            : () async {
                                InjectionHelper.notificationBloc.add(
                                  NotificationTapped(notification.id),
                                );
                                await handleNotificationCta(
                                  context,
                                  notification,
                                );
                              },
                      );
                    },
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
