import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/features/explore/presentation/notification/notification_data.dart';
import 'package:kuemele/features/explore/presentation/notification/widgets/notification_list_item.dart';
import 'package:kuemele/gen/assets.gen.dart';
import 'package:kuemele/l10n/app_localizations.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/models/ads.dart';
import 'package:kuemele/shared/services/ads/ad_units.dart';
import 'package:kuemele/shared/services/ads/kumele_native_ad_widget.dart';
import 'package:kuemele/shared/services/api_service/ads/ads_repo.dart';
import 'package:kuemele/shared/widgets/app_divider.dart';
import 'package:kuemele/shared/widgets/app_empty_state.dart';
import 'package:kuemele/shared/widgets/app_refresh_indicator.dart';
import 'package:kuemele/shared/widgets/kumele_asset_widget.dart';
import 'package:kuemele/shared/widgets/pagination_scroll_listener.dart';
import 'package:kuemele/shared/widgets/skeleton_list_item.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:url_launcher/url_launcher.dart';

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
  final ValueChanged<String> onNotificationTap;
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

    if (!shouldSkeletonize && displayNotifications.isEmpty) {
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
            return KumeleNativeAdWidget(
              adUnitId: KumeleAdUnits.notifications,
              factoryId: KumeleAdUnits.notificationsAdFactoryId,
              height: 320,
              fallback: _NotificationAdsListItem(ads: entry.ads),
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
                : () => widget.onNotificationTap(notification.id),
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

  List<_ListEntry> _entries(
    List<NotificationItem> notifications,
    List<AdItem> ads,
  ) {
    final entries = <_ListEntry>[];
    var insertedAds = false;
    for (final section in NotificationSection.values) {
      final items = notifications
          .where((notification) => notification.section == section)
          .toList(growable: false);
      if (items.isEmpty) continue;

      entries.add(_HeaderEntry(section));
      entries.addAll(items.map(_NotificationEntry.new));
      if (!insertedAds && ads.isNotEmpty) {
        entries.add(_AdsEntry(ads));
        insertedAds = true;
      }
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

class _NotificationAdsListItem extends StatefulWidget {
  const _NotificationAdsListItem({required this.ads});

  final List<AdItem> ads;

  @override
  State<_NotificationAdsListItem> createState() =>
      _NotificationAdsListItemState();
}

class _NotificationAdsListItemState extends State<_NotificationAdsListItem> {
  final Set<String> _viewedImpressionIds = {};

  @override
  void initState() {
    super.initState();
    _trackViews();
  }

  @override
  void didUpdateWidget(covariant _NotificationAdsListItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    _trackViews();
  }

  Future<void> _trackViews() async {
    for (final ad in widget.ads) {
      if (!_viewedImpressionIds.add(ad.impressionId)) continue;
      try {
        await AdsRepo.trackAd(
          TrackAdRequest(
            adId: ad.id,
            campaignId: ad.campaignId,
            impressionId: ad.impressionId,
            eventType: 'view',
            placement: 'NOTIFICATIONS',
          ),
        );
      } catch (_) {}
    }
  }

  Future<void> _openAd(AdItem ad) async {
    try {
      await AdsRepo.trackAd(
        TrackAdRequest(
          adId: ad.id,
          campaignId: ad.campaignId,
          impressionId: ad.impressionId,
          eventType: 'click',
          placement: 'NOTIFICATIONS',
        ),
      );
    } catch (_) {}

    final uri =
        ad.destinationUrl == null ? null : Uri.tryParse(ad.destinationUrl!);
    if (uri != null) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ads = widget.ads.take(4).toList(growable: false);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ColorSet.tileFillColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: ads.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1.1,
        ),
        itemBuilder: (context, index) {
          final ad = ads[index];
          return Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(4),
              onTap: () => _openAd(ad),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: ad.mediaUrl?.isNotEmpty == true
                    ? KumeleAssetWidget(
                        assetPath: ad.mediaUrl!,
                        fit: BoxFit.cover,
                      )
                    : ColoredBox(
                        color: ColorSet.bg3Color,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              ad.title,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: context.textTheme.bodySmallBold.copyWith(
                                color: ColorSet.textColor,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
              ),
            ),
          );
        },
      ),
    );
  }
}
