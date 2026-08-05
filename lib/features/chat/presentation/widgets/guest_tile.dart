import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:kuemele/core/app_strings.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/features/explore/domain/entities/event_guest_entity.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/event_card/widgets/category_tag.dart';
import 'package:kuemele/shared/widgets/app_avatar.dart';

class GuestTile extends StatelessWidget {
  final EventGuestEntity guest;
  final int index;

  const GuestTile({
    super.key,
    required this.guest,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showGuestDetailsDialog(context, guest),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 26.w),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  AppAvatar(
                    imageUrl: guest.user.avatarUrl,
                    name: guest.user.name,
                    size: 40.w,
                    showShadow: false,
                  ),
                  Gap(16.w),
                  Expanded(
                    child: Text(
                      guest.user.firstName ?? guest.user.name,
                      style: context.textTheme.bodyLarge,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Gap(8.w),
            Text(
              guest.checkedIn
                  ? AppStrings.checkedInLabel
                  : AppStrings.notCheckedInLabel,
              style: context.textTheme.bodyMedium.copyWith(
                color: guest.checkedIn ? Colors.green : Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showGuestDetailsDialog(BuildContext context, EventGuestEntity guest) {
    showDialog(
      context: context,
      barrierColor: ColorSet.bcColor,
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Container(
            width: 330.w,
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              color: ColorSet.bg2Color,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Gap(20.h),
                AppAvatar(
                  imageUrl: guest.user.avatarUrl,
                  name: guest.user.name,
                  size: 60.w,
                  showShadow: false,
                ),
                Gap(10.h),
                Text(
                  "${AppStrings.guest} ${guest.user.name}",
                  style: TextStyle(fontSize: 16.sp),
                  textAlign: TextAlign.center,
                ),
                Gap(10.h),
                Text(
                  "Group Meditation",
                  style: context.textTheme.titleLargeBold
                      .copyWith(fontWeight: FontWeight.w700),
                  textAlign: TextAlign.center,
                ),
                Gap(7.h),
                CategoryTag(label: AppStrings.spirituality),
                Gap(7.h),
                const Text(
                  "Hosted By Anki Maheshwari",
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                Gap(5.h),
                const Text(
                  "Bahawalpur, Punjab PK",
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                Gap(30.h),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      dialogContext.pop();
                    },
                    child: Container(
                      width: 110.w,
                      height: 40.h,
                      decoration: BoxDecoration(
                        color: ColorSet.revbg3Color,
                        borderRadius: BorderRadius.circular(5.r),
                      ),
                      child: Center(
                        child: Text(
                          AppStrings.confirm,
                          style: context.textTheme.bodyMedium
                              .copyWith(color: ColorSet.bg2Color),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
