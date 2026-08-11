import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/features/explore/presentation/explorepreview.dart';
import 'package:kuemele/features/explore/presentation/notification/birthday_notification_dialog.dart';
import 'package:kuemele/features/explore/presentation/notification/notification_bloc.dart';
import 'package:kuemele/features/explore/presentation/notification/notification_data.dart';
import 'package:kuemele/features/explore/presentation/notification/notification_event.dart';
import 'package:kuemele/features/explore/presentation/notification/notification_state.dart';
import 'package:kuemele/features/explore/presentation/notification/widgets/notification_list_view.dart';
import 'package:kuemele/l10n/app_localizations.dart';
import 'package:kuemele/features/explore/presentation/notification/welcome_notification_dialog.dart';
import 'package:kuemele/navigation/app_routes.dart';
import 'package:kuemele/features/home/presentation/main_navigation_page.dart';
import 'package:kuemele/shared/base/base_page.dart';
import 'package:kuemele/shared/components/app_button.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/modals/dialog/app_dialog.dart';
import 'package:kuemele/shared/modals/dialog/congratulation_dialog.dart';
import 'package:kuemele/shared/modals/dialog/event_cancelled_dialog.dart';
import 'package:kuemele/shared/services/pagination/pagination_state.dart';
import 'package:kuemele/shared/utils/device_utils.dart';
import 'package:kuemele/shared/widgets/mobile_header.dart';

class NotificationPage extends StatefulWidget implements BasePage {
  const NotificationPage({super.key});

  @override
  String get screenName => 'NotificationPage';

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  void initState() {
    super.initState();
    InjectionHelper.notificationBloc.add(const NotificationsRequested());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotificationBloc, NotificationState>(
      listenWhen: (previous, current) =>
          previous.pendingAction != current.pendingAction &&
          current.pendingAction != null,
      listener: (context, state) async {
        final pendingAction = state.pendingAction;
        if (pendingAction == null) return;

        await _handleNotificationAction(
          context,
          pendingAction.notification,
        );

        if (!context.mounted) return;
        context.read<NotificationBloc>().add(const NotificationActionCleared());
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: ColorSet.bg3Color,
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MobileHeader(
                    label:
                        FormFactor.isTablet ? 'Notifications' : 'Notification',
                    actions: [
                      if (state.unreadCount > 0)
                        GestureDetector(
                          onTap: () => context
                              .read<NotificationBloc>()
                              .add(const NotificationsMarkAllReadRequested()),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              AppLocalizations.of(context)!.markAllAsRead,
                              style: context.textTheme.bodySmall.copyWith(
                                color: ColorSet.specialBlueColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  Gap(22.h),
                  Expanded(
                    child: _NotificationBody(
                      state: state,
                      onNotificationTap: (id) => context
                          .read<NotificationBloc>()
                          .add(NotificationTapped(id)),
                      onLoadMore: () => context
                          .read<NotificationBloc>()
                          .add(const NotificationsLoadMoreRequested()),
                      onRetry: () => context
                          .read<NotificationBloc>()
                          .add(const NotificationsRetryRequested()),
                      onRefresh: () => _refreshNotifications(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _refreshNotifications(BuildContext context) async {
    final bloc = context.read<NotificationBloc>();
    final refreshCompleted = bloc.stream.firstWhere(
      (state) => state.status != PaginationStatus.loading,
    );

    bloc.add(const NotificationsRequested(refresh: true));

    await refreshCompleted;
  }

  Future<void> _handleNotificationAction(
    BuildContext context,
    NotificationItem notification,
  ) async {
    switch (notification.actionType) {
      case NotificationActionType.none:
        return;
      case NotificationActionType.eventJoinPreview:
        final eventId = notification.id.trim();
        if (eventId.isEmpty) return;

        await AppDialog.show(
          context: context,
          width: AppDialogSize.widthFor(context),
          dialog: ExplorePreview(
            eventId: eventId,
            showCancel: false,
            primaryButtonLabel: 'Join Now',
          ),
        );
        return;
      case NotificationActionType.welcomeDialog:
        await AppDialog.show(
          context: context,
          width: AppDialogSize.widthFor(context),
          dialog: const WelcomeNotificationDialog(),
        );
        return;
      case NotificationActionType.blogComment:
        final blogId = notification.blogId;
        if (blogId.isEmpty) return;

        try {
          final blog =
              await InjectionHelper.blogRepository.getBlogDetails(blogId);
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
            extra: BlogDetailRouteArgs(blog: blog),
          );
        } catch (_) {
          InjectionHelper.snackBar.showError('Failed to load blog post.');
        }
        return;
      case NotificationActionType.statusUpdateDialog:
        await showDialog<void>(
          context: context,
          barrierColor: ColorSet.bcColor,
          builder: (context) => const CongratulationDialog(),
        );
        return;
      case NotificationActionType.birthdayDialog:
        await AppDialog.show(
          context: context,
          width: AppDialogSize.widthFor(context),
          dialog: const BirthdayNotificationDialog(),
        );
        return;
      case NotificationActionType.eventCancelledDialog:
        await AppDialog.show(
          context: context,
          width: AppDialogSize.widthFor(context),
          dialog: const EventCancelledDialog(),
        );
        return;
    }
  }
}

class _NotificationBody extends StatelessWidget {
  const _NotificationBody({
    required this.state,
    required this.onNotificationTap,
    required this.onLoadMore,
    required this.onRetry,
    required this.onRefresh,
  });

  final NotificationState state;
  final ValueChanged<String> onNotificationTap;
  final VoidCallback onLoadMore;
  final VoidCallback onRetry;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    if (state.status == PaginationStatus.failure &&
        state.notifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              state.errorMessage ?? 'Failed to load notifications.',
              textAlign: TextAlign.center,
              style: context.textTheme.bodyMedium.copyWith(
                color: ColorSet.textColor,
              ),
            ),
            Gap(16.h),
            AppButton.primary(
              label: AppLocalizations.of(context)!.retry,
              onPressed: onRetry,
            ),
          ],
        ),
      );
    }

    final bool isInitialLoading =
        state.status == PaginationStatus.initial || state.isLoading;
    final bool isRefreshing = state.isRefreshing;
    final bool isLoadingMore = state.isLoadingMore;

    final List<NotificationItem> displayNotifications;
    if (isInitialLoading) {
      displayNotifications = const [];
    } else if (isRefreshing && state.notifications.isEmpty) {
      displayNotifications =
          NotificationItemFactory.createSkeletonPlaceholders();
    } else if (isLoadingMore) {
      displayNotifications = [
        ...state.notifications,
        ...NotificationItemFactory.createLoadMoreSkeletons(),
      ];
    } else {
      displayNotifications = state.notifications;
    }

    return NotificationListView(
      notifications: displayNotifications,
      onNotificationTap: onNotificationTap,
      isLoading: isInitialLoading,
      isRefreshing: isRefreshing,
      isLoadingMore: isLoadingMore,
      onRefresh: onRefresh,
      onLoadMore: onLoadMore,
      padding: EdgeInsets.only(bottom: 16.h),
    );
  }
}
