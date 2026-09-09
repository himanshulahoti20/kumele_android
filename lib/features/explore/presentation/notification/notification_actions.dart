import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/features/chat/presentation/chat_event_actions_page.dart';
import 'package:kuemele/features/explore/presentation/explorepreview.dart';
import 'package:kuemele/features/explore/presentation/notification/birthday_notification_dialog.dart';
import 'package:kuemele/features/explore/presentation/notification/notification_bloc.dart';
import 'package:kuemele/features/explore/presentation/notification/notification_data.dart';
import 'package:kuemele/features/explore/presentation/notification/notification_event.dart';
import 'package:kuemele/features/explore/presentation/notification/welcome_notification_dialog.dart';
import 'package:kuemele/l10n/app_localizations.dart';
import 'package:kuemele/navigation/app_routes.dart';
import 'package:kuemele/features/home/presentation/main_navigation_page.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/modals/dialog/app_dialog.dart';
import 'package:kuemele/shared/modals/dialog/congratulation_dialog.dart';
import 'package:kuemele/shared/modals/dialog/event_cancelled_dialog.dart';
import 'package:kuemele/shared/modals/dialog/notification_info_dialog.dart';
import 'package:kuemele/shared/services/api_service/events/events_repo.dart';
import 'package:kuemele/shared/utils/device_utils.dart';

/// Shared notification tap-through behaviour (navigate/open dialog/join
/// event/etc.) — used by both the full [NotificationPage] and the
/// Explore home screen's [ExploreNotificationsPanel] "Join now" action, so
/// they stay in sync instead of drifting into two implementations.
Future<void> handleNotificationCta(
  BuildContext context,
  NotificationItem notification,
) async {
  if (notification.type != NotificationType.eventCreated) {
    await handleNotificationAction(context, notification);
    return;
  }

  final eventId = notification.eventId;
  if (eventId.isEmpty) return;

  await AppDialog.confirm(
    context: context,
    width: AppDialogSize.notificationModalWidthFor(context),
    title: AppLocalizations.of(context)!.cancelEventTitle,
    cancelText: 'Keep event',
    confirmText: AppLocalizations.of(context)!.cancel,
    content: Text(
      'This event will be cancelled for all guests.',
      textAlign: TextAlign.center,
      style: context.textTheme.bodyMedium.copyWith(
        color: ColorSet.subTextColor,
      ),
    ),
    onConfirmAsync: () async {
      try {
        await EventsRepo.cancelEvent(
          eventId: eventId,
          reason: 'Cancelled from notification',
        );
        if (!context.mounted) return;
        InjectionHelper.snackBar.showSuccess('Event cancelled.');
        context.read<NotificationBloc>().add(
              const NotificationsRequested(refresh: true),
            );
      } catch (_) {
        if (context.mounted) {
          InjectionHelper.snackBar.showError('Unable to cancel event.');
        }
      }
    },
  );
}

Future<void> handleNotificationAction(
  BuildContext context,
  NotificationItem notification,
) async {
  switch (notification.actionType) {
    case NotificationActionType.none:
      return;
    case NotificationActionType.eventJoinPreview:
      final eventId = notification.eventId.isNotEmpty
          ? notification.eventId
          : notification.id;
      if (eventId.isEmpty) return;

      if (notification.type == NotificationType.eventCreated) {
        context.push(AppRoutes.myEventDetail, extra: eventId);
        return;
      }

      await AppDialog.show(
        context: context,
        width: AppDialogSize.eventDetailWidthFor(context),
        dialog: ExplorePreview(
          eventId: eventId,
          isJoinFlow: true,
        ),
      );
      return;
    case NotificationActionType.welcomeDialog:
      await AppDialog.show(
        context: context,
        width: AppDialogSize.notificationModalWidthFor(context),
        dialog: const WelcomeNotificationDialog(),
      );
      return;
    case NotificationActionType.blog:
      final blogId = notification.blogId;
      if (blogId.isEmpty) {
        _openHomeTab(context, HomeTabType.blog);
        return;
      }

      try {
        final blog = await InjectionHelper.blogRepository.getBlogDetails(
          blogId,
        );
        if (!context.mounted) return;

        if (!FormFactor.isTablet) {
          if (context.canPop()) {
            context.pop();
          } else {
            InjectionHelper.homePageCubit.onTapTab(context, HomeTabType.home);
          }
        }
        context.push(
          AppRoutes.blogDetail,
          extra: BlogDetailRouteArgs(
            blog: blog,
            openComments: notification.type == NotificationType.blogComment,
          ),
        );
      } catch (_) {
        InjectionHelper.snackBar.showError(
          AppLocalizations.of(context)!.loadBlogPostFailedError,
        );
      }
      return;
    case NotificationActionType.eventRate:
      final eventId = notification.eventId;
      if (eventId.isEmpty) return;
      context.push(
        AppRoutes.rating,
        extra: ChatEventActionsRouteArgs(eventId: eventId),
      );
      return;
    case NotificationActionType.chat:
      context.push(AppRoutes.chatList);
      return;
    case NotificationActionType.reward:
      context.push(AppRoutes.earnMedals);
      return;
    case NotificationActionType.payment:
      _openHomeTab(context, HomeTabType.cart);
      return;
    case NotificationActionType.statusUpdateDialog:
      await AppDialog.show(
        context: context,
        width: 320,
        dialog: CongratulationDialog(
          status: notification.title,
          discountCode: _value(notification, const [
            'discountCode',
            'discount_code',
            'code',
          ]),
          description: notification.description,
          medalType: _resolveMedalType(notification),
        ),
      );
      return;
    case NotificationActionType.birthdayDialog:
      await AppDialog.show(
        context: context,
        width: 320,
        dialog: const BirthdayNotificationDialog(),
      );
      return;
    case NotificationActionType.eventCancelledDialog:
      await AppDialog.show(
        context: context,
        width: 320,
        dialog: EventCancelledDialog(message: notification.description),
      );
      return;
    case NotificationActionType.infoDialog:
      await AppDialog.show(
        context: context,
        width: 320,
        dialog: NotificationInfoDialog(
          title: notification.title,
          message: notification.description,
        ),
      );
      return;
  }
}

String? _value(NotificationItem notification, List<String> keys) {
  for (final key in keys) {
    final value = notification.targetReference[key]?.toString().trim() ?? '';
    if (value.isNotEmpty) return value;
  }
  return null;
}

const _medalTypes = ['gold', 'silver', 'bronze'];

String? _resolveMedalType(NotificationItem notification) {
  final fromRef = _value(notification, const ['tier', 'badge', 'medalType']);
  if (fromRef != null) {
    final lower = fromRef.toLowerCase();
    for (final medal in _medalTypes) {
      if (lower.contains(medal)) return medal;
    }
  }
  final title = notification.title.toLowerCase();
  for (final medal in _medalTypes) {
    if (title.contains(medal)) return medal;
  }
  return null;
}

void _openHomeTab(BuildContext context, HomeTabType tab) {
  if (!FormFactor.isTablet && context.canPop()) {
    context.pop();
  }
  InjectionHelper.homePageCubit.onTapTab(context, tab);
}
