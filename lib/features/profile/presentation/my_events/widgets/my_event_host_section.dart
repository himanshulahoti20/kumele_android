import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/features/explore/domain/entities/explore_event_detail.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/app_shadows.dart';
import 'package:kuemele/shared/widgets/app_avatar.dart';

class MyEventHostSection extends StatelessWidget {
  const MyEventHostSection({
    super.key,
    required this.detail,
  });

  final ExploreEventDetail detail;

  @override
  Widget build(BuildContext context) {
    final host = detail.hostProfile;

    return Container(
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
            'Organized by',
            style: context.textTheme.labelMediumBold.copyWith(
              color: ColorSet.subTextColor,
              fontSize: 12.sp,
            ),
          ),
          Gap(10.h),
          Row(
            children: [
              AppAvatar(
                imageUrl: host.avatarUrl,
                name: detail.hostName,
                size: 48,
                showShadow: false,
              ),
              Gap(12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      detail.hostName,
                      style: context.textTheme.bodyMediumBold.copyWith(
                        color: ColorSet.textColor,
                        fontSize: 15.sp,
                      ),
                    ),
                    if (host.displayName.isNotEmpty)
                      Text(
                        '@${host.displayName}',
                        style: context.textTheme.bodySmall.copyWith(
                          color: ColorSet.subTextColor,
                          fontSize: 12.sp,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          if (host.bio != null && host.bio!.trim().isNotEmpty) ...[
            Gap(10.h),
            Text(
              host.bio!.trim(),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: context.textTheme.bodySmall.copyWith(
                color: ColorSet.textColor,
                fontSize: 12.sp,
                height: 1.4,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
