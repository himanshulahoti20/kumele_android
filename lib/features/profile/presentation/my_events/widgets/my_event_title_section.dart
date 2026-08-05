import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/features/explore/domain/entities/explore_event_detail.dart';
import 'package:kuemele/shared/components/app_colors.dart';

class MyEventTitleSection extends StatelessWidget {
  const MyEventTitleSection({
    super.key,
    required this.detail,
  });

  final ExploreEventDetail detail;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                detail.title,
                style: context.textTheme.headlineSmallBold.copyWith(
                  color: ColorSet.textColor,
                  fontSize: 22.sp,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: ColorSet.specialBlueColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                detail.status.toUpperCase(),
                style: context.textTheme.labelSmallBold.copyWith(
                  color: ColorSet.specialBlueColor,
                  fontSize: 10.sp,
                ),
              ),
            ),
          ],
        ),
        if (detail.hobbyNames.length > 1) ...[
          Gap(8.h),
          Wrap(
            spacing: 6.w,
            runSpacing: 4.h,
            children: detail.hobbyNames.skip(1).map((hobby) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: ColorSet.tileFillColor,
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  hobby,
                  style: context.textTheme.bodySmall.copyWith(
                    color: ColorSet.subTextColor,
                    fontSize: 11.sp,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}
