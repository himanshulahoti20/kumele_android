import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/core/app_strings.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/features/explore/domain/entities/event_guest_entity.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/app_shadows.dart';
import 'package:kuemele/shared/utils/conversion_utils.dart';
import 'package:kuemele/shared/widgets/app_avatar.dart';
import 'package:kuemele/shared/widgets/app_loading_indicator.dart';

class MyEventGuestsSection extends StatelessWidget {
  const MyEventGuestsSection({
    super.key,
    required this.guests,
    required this.isGuestsLoading,
  });

  final List<EventGuestEntity> guests;
  final bool isGuestsLoading;

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.guests,
                style: context.textTheme.titleMediumBold.copyWith(
                  color: ColorSet.textColor,
                  fontSize: 16.sp,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: ColorSet.specialBlueColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  '${guests.length} ${AppStrings.guests}',
                  style: context.textTheme.labelSmallBold.copyWith(
                    color: ColorSet.specialBlueColor,
                    fontSize: 11.sp,
                  ),
                ),
              ),
            ],
          ),
          Gap(12.h),
          if (isGuestsLoading)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h),
              child: const Center(
                child: AppLoadingIndicator.circle(
                  size: 24,
                ),
              ),
            )
          else if (guests.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: Center(
                child: Text(
                  AppStrings.noGuestsDescription,
                  style: context.textTheme.bodyMedium.copyWith(
                    color: ColorSet.subTextColor,
                    fontSize: 13.sp,
                  ),
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: guests.length,
              separatorBuilder: (context, index) => Divider(
                color: ColorSet.tileFillColor,
                height: 16.h,
              ),
              itemBuilder: (context, index) {
                final guest = guests[index];
                return _GuestTile(guest: guest);
              },
            ),
        ],
      ),
    );
  }
}

class _GuestTile extends StatelessWidget {
  const _GuestTile({required this.guest});

  final EventGuestEntity guest;

  @override
  Widget build(BuildContext context) {
    final user = guest.user;
    final joinedAtStr = guest.joinedAt != null
        ? ConversionUtils.formatDateTime(guest.joinedAt!, 'MMM dd, yyyy')
        : '';

    return Row(
      children: [
        AppAvatar(
          imageUrl: user.avatarUrl,
          name: user.name.isNotEmpty ? user.name : 'Guest User',
          size: 40,
          showShadow: false,
        ),
        Gap(12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.name.isNotEmpty ? user.name : 'Guest User',
                style: context.textTheme.bodyMediumBold.copyWith(
                  color: ColorSet.textColor,
                  fontSize: 14.sp,
                ),
              ),
              if (joinedAtStr.isNotEmpty)
                Text(
                  'Joined $joinedAtStr',
                  style: context.textTheme.bodySmall.copyWith(
                    color: ColorSet.subTextColor,
                    fontSize: 11.sp,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
