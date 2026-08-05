import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/features/explore/domain/entities/explore_event_detail.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/app_shadows.dart';

class MyEventDescriptionSection extends StatelessWidget {
  const MyEventDescriptionSection({
    super.key,
    required this.detail,
  });

  final ExploreEventDetail detail;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: ColorSet.bg2Color,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About Event',
            style: context.textTheme.titleMediumBold.copyWith(
              color: ColorSet.textColor,
              fontSize: 16.sp,
            ),
          ),
          Gap(8.h),
          Text(
            detail.description.isNotEmpty
                ? detail.description
                : 'No description provided.',
            style: context.textTheme.bodyMedium.copyWith(
              color: ColorSet.subTextColor,
              fontSize: 13.sp,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
