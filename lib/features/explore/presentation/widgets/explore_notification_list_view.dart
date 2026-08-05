import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/core/responsive/responsive.dart';
import 'package:kuemele/gen/assets.gen.dart';
import 'package:kuemele/features/explore/presentation/explore_config.dart';
import 'package:kuemele/shared/widgets/kumele_asset_widget.dart';

class ExploreNotificationListView extends StatelessWidget {
  const ExploreNotificationListView({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Expanded(
      child: ListView.builder(
        itemCount: ExploreConfig.notifications.length,
        itemBuilder: (context, index) {
          final notification = ExploreConfig.notifications[index];

          return Container(
            margin: EdgeInsets.symmetric(
              horizontal: responsive.w(10),
              vertical: responsive.w(5),
            ),
            decoration: BoxDecoration(
              color: ColorSet.bg3Color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListTile(
              leading: Stack(
                children: [
                  KumeleAssetWidget.circular(
                    assetPath: notification.imagePath,
                    size: responsive.w(45),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: responsive.w(13),
                      height: responsive.w(13),
                      decoration: BoxDecoration(
                        color: ColorSet.specialYellowColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: ColorSet.bg3Color, width: 2),
                      ),
                    ),
                  ),
                ],
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    notification.title,
                    style: context.textTheme.bodyMediumBold.copyWith(
                      color: ColorSet.textColor,
                    ),
                  ),
                  Text(
                    notification.time,
                    style: context.textTheme.bodySmall.copyWith(
                      color: ColorSet.specialBlueColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _NotificationCategoryPill(
                        category: notification.category,
                        responsive: responsive,
                      ),
                      Gap(responsive.w(8)),
                      _JoinNowPill(responsive: responsive),
                    ],
                  ),
                  Text(
                    notification.subText,
                    style: context.textTheme.bodySmall.copyWith(
                      color: ColorSet.subTextColor,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _NotificationCategoryPill extends StatelessWidget {
  const _NotificationCategoryPill({
    required this.category,
    required this.responsive,
  });

  final String category;
  final ResponsiveData responsive;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: responsive.w(16),
      padding: EdgeInsets.symmetric(horizontal: responsive.w(2)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(responsive.w(24)),
        color: ColorSet.bg8Color,
      ),
      child: Row(
        children: [
          KumeleAssetWidget.square(
            assetPath: Assets.icons.yinYang.path,
            size: responsive.w(15),
            color: ColorSet.revbg3Color,
            fit: BoxFit.contain,
          ),
          Gap(responsive.w(2)),
          Expanded(
            child: Text(
              category,
              style: context.textTheme.labelSmall.copyWith(
                color: ColorSet.revbg3Color,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _JoinNowPill extends StatelessWidget {
  const _JoinNowPill({required this.responsive});

  final ResponsiveData responsive;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: responsive.w(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(responsive.w(24)),
        color: ColorSet.specialBlueColor,
      ),
      child: Center(
        child: Text(
          'Join Now',
          style: context.textTheme.labelSmall.copyWith(
            color: ColorSet.snackBarInfoText,
          ),
        ),
      ),
    );
  }
}
