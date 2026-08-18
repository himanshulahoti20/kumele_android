import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/features/chat/presentation/chat_event_actions_page.dart';
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
import 'package:kuemele/shared/models/ads.dart';
import 'package:kuemele/shared/services/api_service/ads/ads_repo.dart';
import 'package:kuemele/shared/services/api_service/events/events_repo.dart';
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
  List<AdItem> _notificationAds = const [];

  @override
  void initState() {
    super.initState();
    InjectionHelper.notificationBloc.add(const NotificationsRequested());
    _loadNotificationAd();
  }

  Future<void> _loadNotificationAd() async {
    try {
      final response = await AdsRepo.fetchAds(
        placement: 'NOTIFICATIONS',
        limit: 4,
      );
      if (!mounted) return;
      setState(() => _notificationAds = response?.ads ?? const []);
    } catch (_) {}
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

        await _handleNotificationAction(context, pendingAction.notification);

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
                    label: 'Notifications',
                    actions: [
                      if (state.unreadCount > 0)
                        GestureDetector(
                          onTap: () => context.read<NotificationBloc>().add(
                                const NotificationsMarkAllReadRequested(),
                              ),
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
                      notificationAds: _notificationAds,
                      onNotificationTap: (id) => context
                          .read<NotificationBloc>()
                          .add(NotificationTapped(id)),
                      onNotificationAction: (notification) async {
                        context.read<NotificationBloc>().add(
                              NotificationTapped(
                                notification.id,
                                openAction: false,
                              ),
                            );
                        await _handleNotificationCta(context, notification);
                      },
                      onLoadMore: () => context.read<NotificationBloc>().add(
                            const NotificationsLoadMoreRequested(),
                          ),
                      onRetry: () => context.read<NotificationBloc>().add(
                            const NotificationsRetryRequested(),
                          ),
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
          ),
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
          width: 320,
          dialog: EventCancelledDialog(message: notification.description),
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

  Future<void> _handleNotificationCta(
    BuildContext context,
    NotificationItem notification,
  ) async {
    if (notification.type != NotificationType.eventCreated) {
      await _handleNotificationAction(context, notification);
      return;
    }

    final eventId = notification.eventId;
    if (eventId.isEmpty) return;

    await AppDialog.confirm(
      context: context,
      width: 320,
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

  void _openHomeTab(BuildContext context, HomeTabType tab) {
    if (!FormFactor.isTablet && context.canPop()) {
      context.pop();
    }
    InjectionHelper.homePageCubit.onTapTab(context, tab);
  }
}

class _NotificationBody extends StatelessWidget {
  const _NotificationBody({
    required this.state,
    required this.notificationAds,
    required this.onNotificationTap,
    required this.onNotificationAction,
    required this.onLoadMore,
    required this.onRetry,
    required this.onRefresh,
  });

  final NotificationState state;
  final List<AdItem> notificationAds;
  final ValueChanged<String> onNotificationTap;
  final ValueChanged<NotificationItem> onNotificationAction;
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
      notificationAds: notificationAds,
      onNotificationTap: onNotificationTap,
      onNotificationAction: onNotificationAction,
      isLoading: isInitialLoading,
      isRefreshing: isRefreshing,
      isLoadingMore: isLoadingMore,
      onRefresh: onRefresh,
      onLoadMore: onLoadMore,
      padding: EdgeInsets.only(bottom: 16.h),
    );
  }
}
