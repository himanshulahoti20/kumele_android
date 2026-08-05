import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/features/explore/domain/entities/explore_event_detail.dart';
import 'package:kuemele/gen/assets.gen.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/app_shadows.dart';
import 'package:kuemele/shared/utils/conversion_utils.dart';
import 'package:kuemele/shared/widgets/kumele_asset_widget.dart';

class MyEventQuickInfoGrid extends StatelessWidget {
  const MyEventQuickInfoGrid({
    super.key,
    required this.detail,
  });

  final ExploreEventDetail detail;

  @override
  Widget build(BuildContext context) {
    final timeRange =
        ConversionUtils.formatEventTimeRange(detail.startsAt, detail.endsAt);

    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: ColorSet.bg2Color,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        children: [
          _InfoTile(
            iconAsset: Assets.icons.clock.path,
            title: 'Date & Time',
            subtitle: '$timeRange (${detail.displayRelativeStart})',
          ),
          Divider(color: ColorSet.tileFillColor, height: 16.h),
          _InfoTile(
            iconAsset: Assets.icons.location.path,
            title: 'Location',
            subtitle: detail.displayLocation.isNotEmpty
                ? detail.displayLocation
                : '--',
          ),
          Divider(color: ColorSet.tileFillColor, height: 16.h),
          _InfoTile(
            iconAsset: Assets.icons.groupCard.path,
            title: 'Capacity & Availability',
            subtitle:
                '${detail.attendeeCount} / ${detail.capacity} Attendees (${detail.spotsRemaining} spots left)',
          ),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.iconAsset,
    required this.title,
    required this.subtitle,
  });

  final String iconAsset;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36.r,
          height: 36.r,
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: ColorSet.tileFillColor,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: KumeleAssetWidget(
            assetPath: iconAsset,
          ),
        ),
        Gap(12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: context.textTheme.bodySmall.copyWith(
                  color: ColorSet.subTextColor,
                  fontSize: 11.sp,
                ),
              ),
              Text(
                subtitle,
                style: context.textTheme.bodyMediumBold.copyWith(
                  color: ColorSet.textColor,
                  fontSize: 13.sp,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
