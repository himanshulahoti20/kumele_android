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
import 'package:kuemele/shared/modals/dialog/rate_app_dialog.dart';
import 'package:kuemele/shared/modals/dialog/rate_last_event_dialog.dart';
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
    confirmText: AppLocalizations.of(context)!.cancelEventTitle,
    // Matches ConfirmActionPopupView.swift's tablet scrim (phone routes
    // through AppBottomSheet instead, which keeps its own default).
    barrierColor: ColorSet.scrimFlat,
    content: Text(
      'This will cancel the event for all guests.',
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
        // Matches iOS: a host's own event notification opens the "Cancel
        // event?" confirm dialog directly on tap while it's still
        // cancelable (NotificationView_iPhone's rowAction == .cancel case)
        // — there's no intermediate detail screen for that case in iOS.
        // Once it's no longer cancelable (past/already cancelled), iOS
        // falls back to a plain detail view; myEventDetail is Android's
        // equivalent full-detail screen for that case.
        if (notification.canCancel) {
          await handleNotificationCta(context, notification);
        } else {
          context.push(AppRoutes.myEventDetail, extra: eventId);
        }
        return;
      }

      // Matches iOS's rowAction split for the EVENT_MATCHED section:
      // only the literal EVENT_MATCHED type gets the "Join now" flow
      // (rowAction == .joinNow, EventJoinView); every other already-
      // related type (joined/confirmed/reminder/checked-in) opens the
      // plain preview instead (rowAction == .matched, EventDetailView) —
      // showing a Join button there again would let someone try to
      // re-join an event they're already in.
      await AppDialog.show(
        context: context,
        width: AppDialogSize.eventDetailWidthFor(context),
        // Matches EventJoinView/EventDetailView's flat scrim.
        barrierColor: ColorSet.scrimFlat,
        dialog: ExplorePreview(
          eventId: eventId,
          isJoinFlow: notification.type == NotificationType.eventMatched,
        ),
      );
      return;
    case NotificationActionType.welcomeDialog:
      await AppDialog.show(
        context: context,
        width: AppDialogSize.notificationModalWidthFor(context),
        // Matches PopUpWelcomeView's flat scrim.
        barrierColor: ColorSet.scrimFlat,
        dialog: const WelcomeNotificationDialog(),
      );
      // Tablet-only: matches iOS's chain off this same .welcome notification
      // action — PopUpWelcomeView's onClose triggers isShowRateLastEvent,
      // whose own completion triggers isShowRateApp.
      if (!context.mounted || !FormFactor.isTablet) return;
      await AppDialog.show(
        context: context,
        width: AppDialogSize.notificationModalWidthFor(context),
        dialog: RateLastEventDialog(
          onDone: () {
            if (!context.mounted) return;
            AppDialog.show(
              context: context,
              width: AppDialogSize.widthFor(context),
              dialog: const RateAppDialog(),
            );
          },
        ),
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
        width: _fixedCompactAlertWidth,
        // Matches EventNotificationMedalsView's layered scrim (no idiom
        // split in iOS — same on phone and tablet).
        barrierColor: ColorSet.scrimLayered,
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
        width: _compactAlertWidth(context),
        // Birthday is the one Family A popup whose scrim actually differs
        // by idiom — NotificationBirthdayView_iPhone uses the layered
        // black scrim, but _iPad switches to the flat one along with its
        // wider Family D card.
        barrierColor:
            FormFactor.isTablet ? ColorSet.scrimFlat : ColorSet.scrimLayered,
        dialog: const BirthdayNotificationDialog(),
      );
      return;
    case NotificationActionType.eventCancelledDialog:
      await AppDialog.show(
        context: context,
        width: _fixedCompactAlertWidth,
        // Matches EventCanceledView's layered scrim (no idiom split).
        barrierColor: ColorSet.scrimLayered,
        dialog: EventCancelledDialog(message: notification.description),
      );
      return;
    case NotificationActionType.infoDialog:
      await AppDialog.show(
        context: context,
        width: _fixedCompactAlertWidth,
        // Matches NotificationMessagePopupView's layered scrim (no idiom
        // split).
        barrierColor: ColorSet.scrimLayered,
        dialog: NotificationInfoDialog(
          title: notification.title,
          message: notification.description,
        ),
      );
      return;
  }
}

/// Event cancelled / reward medal / generic info popups
/// (EventCanceledView.swift, EventNotificationMedalsView.swift,
/// NotificationMessagePopupView.swift) have no `_iPad` variant in iOS at
/// all — they stay capped at 320pt on every device, unlike Birthday which
/// is the only "compact alert" popup with a distinct, much wider iPad
/// layout (see [_compactAlertWidth]).
const double _fixedCompactAlertWidth = 320;

/// 320 matches iPhone's NotificationBirthdayView_iPhone cap exactly; tablet
/// gets the wider iPad cap (NotificationBirthdayView_iPad's 620) instead of
/// this whole "compact alert" popup family staying phone-sized.
double _compactAlertWidth(BuildContext context) {
  return FormFactor.isTablet
      ? AppDialogSize.compactAlertWidthFor(context)
      : 320;
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
