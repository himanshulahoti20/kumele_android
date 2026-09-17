import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/features/explore/presentation/notification/notification_actions.dart';
import 'package:kuemele/features/explore/presentation/notification/notification_bloc.dart';
import 'package:kuemele/features/explore/presentation/notification/notification_data.dart';
import 'package:kuemele/features/explore/presentation/notification/notification_event.dart';
import 'package:kuemele/features/explore/presentation/notification/notification_state.dart';
import 'package:kuemele/features/explore/presentation/notification/widgets/notification_list_view.dart';
import 'package:kuemele/l10n/app_localizations.dart';
import 'package:kuemele/shared/base/base_page.dart';
import 'package:kuemele/shared/components/app_button.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/models/ads.dart';
import 'package:kuemele/shared/services/api_service/ads/ads_repo.dart';
import 'package:kuemele/shared/services/pagination/pagination_state.dart';
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
      final hobbyContext = await InjectionHelper.profileCubit.loadHobbyContext();
      final response = await AdsRepo.fetchAds(
        placement: 'NOTIFICATIONS',
        limit: 12,
        hobbyContext: hobbyContext,
      );
      if (!mounted) return;
      setState(() => _notificationAds = response?.ads ?? const []);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationBloc, NotificationState>(
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
                      onNotificationTap: (notification) async {
                        context
                            .read<NotificationBloc>()
                            .add(NotificationTapped(notification.id));
                        await handleNotificationAction(context, notification);
                      },
                      onNotificationAction: (notification) async {
                        context
                            .read<NotificationBloc>()
                            .add(NotificationTapped(notification.id));
                        await handleNotificationCta(context, notification);
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
  final ValueChanged<NotificationItem> onNotificationTap;
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
