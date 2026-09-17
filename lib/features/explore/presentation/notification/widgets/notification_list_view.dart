import 'dart:async';
import 'dart:math' as math;

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/features/explore/presentation/notification/notification_data.dart';
import 'package:kuemele/features/explore/presentation/notification/widgets/ad_carousel_rail.dart';
import 'package:kuemele/features/explore/presentation/notification/widgets/notification_list_item.dart';
import 'package:kuemele/gen/assets.gen.dart';
import 'package:kuemele/l10n/app_localizations.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/modals/dialog/app_dialog.dart';
import 'package:kuemele/shared/models/ads.dart';
import 'package:kuemele/shared/widgets/app_divider.dart';
import 'package:kuemele/shared/widgets/app_empty_state.dart';
import 'package:kuemele/shared/widgets/app_refresh_indicator.dart';
import 'package:kuemele/shared/widgets/kumele_asset_widget.dart';
import 'package:kuemele/shared/widgets/pagination_scroll_listener.dart';
import 'package:kuemele/shared/widgets/skeleton_list_item.dart';
import 'package:skeletonizer/skeletonizer.dart';

class NotificationListView extends StatefulWidget {
  const NotificationListView({
    super.key,
    required this.notifications,
    required this.onNotificationTap,
    this.onNotificationAction,
    this.notificationAds = const [],
    this.isLoading = false,
    this.isRefreshing = false,
    this.isLoadingMore = false,
    this.onRefresh,
    this.onLoadMore,
    this.padding = EdgeInsets.zero,
  });

  final List<NotificationItem> notifications;
  final ValueChanged<NotificationItem> onNotificationTap;
  final ValueChanged<NotificationItem>? onNotificationAction;
  final List<AdItem> notificationAds;
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
    final entries = _entries(
      displayNotifications,
      shouldSkeletonize ? const [] : widget.notificationAds,
    );

    // Matches iOS's `isEmpty = notifications.isEmpty && ads.isEmpty` — the
    // bell/"no notifications" fallback should only win when there's
    // truly nothing to show, ads included. Checking notifications alone
    // hid available ad content whenever the user had zero real
    // notifications.
    final hasNothingToShow =
        displayNotifications.isEmpty && widget.notificationAds.isEmpty;
    if (!shouldSkeletonize && hasNothingToShow) {
      final emptyState = AppEmptyState(
        title: AppLocalizations.of(context)!.noNotificationsTitle,
        description: AppLocalizations.of(context)!.noNotificationsDescription,
        icon: KumeleAssetWidget(
          assetPath: Assets.icons.notifications.bell.path,
          width: 64,
          height: 64,
          color: ColorSet.subTextColor,
        ),
      );
      if (widget.onRefresh == null) return emptyState;

      return AppCleanRefresh(
        onRefresh: widget.onRefresh!,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverFillRemaining(hasScrollBody: false, child: emptyState),
          ],
        ),
      );
    }

    final listView = Skeletonizer(
      enabled: shouldSkeletonize,
      child: ListView.separated(
        padding: widget.padding,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: entries.length,
        separatorBuilder: (context, index) {
          if (index >= entries.length - 1) return const SizedBox.shrink();
          if (entries[index] is _HeaderEntry ||
              entries[index + 1] is _HeaderEntry) {
            return const Gap(10);
          }
          return const AppDivider.horizontal(height: 16);
        },
        itemBuilder: (context, index) {
          final entry = entries[index];
          if (entry is _HeaderEntry) {
            return _NotificationSectionHeader(section: entry.section);
          }
          if (entry is _AdsEntry) {
            // Matches iOS's NotificationView_iPhone / HomeView_iPad: the
            // backend's first-party ad carousel renders directly, no AdMob
            // native ad attempt in front of it.
            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: AppDialogSize.notificationModalWidthFor(context),
                ),
                child: AdCarouselRail(ads: entry.ads),
              ),
            );
          }

          final notification = (entry as _NotificationEntry).notification;
          final isSkeletonItem = widget.isLoadingMore &&
              notification.id.startsWith('skeleton-loadmore-');
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
                : () => widget.onNotificationTap(notification),
            onAction: shouldSkeletonize || widget.onNotificationAction == null
                ? null
                : () => widget.onNotificationAction!(notification),
          );
        },
      ),
    );

    if (widget.onRefresh == null) return listView;
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

  // Matches iOS's `makeSectionItems`: every section's header always shows
  // (never skipped for being empty — `ForEach(NotiType.allCases)` there
  // has no emptiness guard), an ad chunk inserts after the 2nd item of
  // any section that has real notifications, and any ad chunks left over
  // once every section's been considered — the case where the user has
  // zero real notifications anywhere — all land in the first non-empty
  // section, or "Other Notifications" if every section is empty.
  List<_ListEntry> _entries(
    List<NotificationItem> notifications,
    List<AdItem> ads,
  ) {
    final adChunks = chunkAdsForRails(ads);
    var chunkIndex = 0;
    final bySection = <NotificationSection, List<_ListEntry>>{};

    for (final section in NotificationSection.values) {
      final items = notifications
          .where((notification) => notification.section == section)
          .toList(growable: false);
      final sectionEntries = <_ListEntry>[
        for (final item in items) _NotificationEntry(item),
      ];

      if (chunkIndex < adChunks.length && sectionEntries.isNotEmpty) {
        sectionEntries.insert(
          math.min(2, sectionEntries.length),
          _AdsEntry(adChunks[chunkIndex]),
        );
        chunkIndex++;
      }
      bySection[section] = sectionEntries;
    }

    if (chunkIndex < adChunks.length) {
      final target = bySection.entries
              .firstWhereOrNull((e) => e.value.isNotEmpty)
              ?.key ??
          NotificationSection.other;
      bySection[target]!.addAll(
        adChunks.skip(chunkIndex).map(_AdsEntry.new),
      );
    }

    final entries = <_ListEntry>[];
    for (final section in NotificationSection.values) {
      entries.add(_HeaderEntry(section));
      entries.addAll(bySection[section]!);
    }
    return entries;
  }
}

sealed class _ListEntry {
  const _ListEntry();
}

class _HeaderEntry extends _ListEntry {
  const _HeaderEntry(this.section);

  final NotificationSection section;
}

class _NotificationEntry extends _ListEntry {
  const _NotificationEntry(this.notification);

  final NotificationItem notification;
}

class _AdsEntry extends _ListEntry {
  const _AdsEntry(this.ads);

  final List<AdItem> ads;
}

class _NotificationSectionHeader extends StatelessWidget {
  const _NotificationSectionHeader({required this.section});

  final NotificationSection section;

  @override
  Widget build(BuildContext context) {
    final title = switch (section) {
      NotificationSection.matched => 'Matched Hobby(ies)',
      NotificationSection.created => 'Created Hobby(ies)',
      NotificationSection.other => 'Other Notifications',
    };
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Text(
        title,
        style: context.textTheme.bodyMedium.copyWith(
          color: ColorSet.textColor,
          fontSize: 16,
        ),
      ),
    );
  }
}

