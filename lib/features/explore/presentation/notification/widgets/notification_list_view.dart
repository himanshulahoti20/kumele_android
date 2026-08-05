import 'package:flutter/material.dart';
import 'package:kuemele/features/explore/presentation/notification/notification_data.dart';
import 'package:kuemele/features/explore/presentation/notification/widgets/notification_list_item.dart';
import 'package:kuemele/shared/widgets/app_divider.dart';
import 'package:kuemele/shared/widgets/app_refresh_indicator.dart';
import 'package:kuemele/shared/widgets/pagination_scroll_listener.dart';
import 'package:kuemele/shared/widgets/skeleton_list_item.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/widgets/app_empty_state.dart';
import 'package:kuemele/shared/widgets/kumele_asset_widget.dart';
import 'package:kuemele/gen/assets.gen.dart';
import 'package:skeletonizer/skeletonizer.dart';

class NotificationListView extends StatefulWidget {
  const NotificationListView({
    super.key,
    required this.notifications,
    required this.onNotificationTap,
    this.isLoading = false,
    this.isRefreshing = false,
    this.isLoadingMore = false,
    this.onRefresh,
    this.onLoadMore,
    this.padding = EdgeInsets.zero,
  });

  final List<NotificationItem> notifications;
  final ValueChanged<String> onNotificationTap;
  final bool isLoading;
  final bool isRefreshing;
  final bool isLoadingMore;
  final Future<void> Function()? onRefresh;
  final VoidCallback? onLoadMore;
  final EdgeInsets padding;

  @override
  State<NotificationListView> createState() => _NotificationListViewState();
}

class _NotificationListViewState extends State<NotificationListView> {
  static const int _placeholderCount = 6;

  @override
  Widget build(BuildContext context) {
    final displayNotifications =
        widget.isLoading ? _placeholderNotifications() : widget.notifications;
    final shouldSkeletonize = widget.isLoading || widget.isRefreshing;
    final isLoadingMore = widget.isLoadingMore;

    if (!shouldSkeletonize && displayNotifications.isEmpty) {
      final emptyState = AppEmptyState(
        title: 'No Notifications',
        description:
            'You have no new notifications right now. Check back later.',
        icon: KumeleAssetWidget(
          assetPath: Assets.icons.notifications.bell.path,
          width: 64,
          height: 64,
          color: ColorSet.subTextColor,
        ),
      );

      if (widget.onRefresh == null) {
        return emptyState;
      }

      return AppCleanRefresh(
        onRefresh: widget.onRefresh!,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: emptyState,
            ),
          ],
        ),
      );
    }

    final listView = Skeletonizer(
      enabled: shouldSkeletonize,
      child: ListView.separated(
        padding: widget.padding,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: displayNotifications.length,
        separatorBuilder: (context, index) {
          if (index >= displayNotifications.length - 1) {
            return const SizedBox.shrink();
          }
          return const AppDivider.horizontal(height: 16);
        },
        itemBuilder: (context, index) {
          final notification = displayNotifications[index];
          final isSkeletonItem =
              isLoadingMore && notification.id.startsWith('skeleton-loadmore-');

          if (isSkeletonItem) {
            return SkeletonListItem(
              child: NotificationListItem(
                notification: notification,
                onTap: () {},
              ),
            );
          }

          return NotificationListItem(
            notification: notification,
            onTap: shouldSkeletonize
                ? () {}
                : () => widget.onNotificationTap(notification.id),
          );
        },
      ),
    );

    if (widget.onRefresh == null) {
      return listView;
    }

    return AppCleanRefresh(
      onRefresh: widget.onRefresh!,
      child: PaginationScrollListener(
        isLoadingMore: widget.isLoadingMore,
        onLoadMore: widget.onLoadMore,
        child: listView,
      ),
    );
  }

  List<NotificationItem> _placeholderNotifications() {
    return NotificationItemFactory.createSkeletonPlaceholders(
      count: _placeholderCount,
      prefix: 'placeholder-notification-',
    );
  }
}
