import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/core/app_strings.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/features/explore/presentation/explore_config.dart';
import 'package:kuemele/gen/assets.gen.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/modals/bottom_sheet/app_bottom_sheet.dart';
import 'package:kuemele/shared/widgets/app_rounded_icon_button.dart';
import 'package:kuemele/shared/widgets/kumele_asset_widget.dart';
import 'package:kuemele/shared/widgets/app_tag_label.dart';

class ShareEventBottomSheet extends StatelessWidget {
  const ShareEventBottomSheet({
    super.key,
    required this.event,
  });

  final ExploreEventItem event;

  static Future<void> show(BuildContext context, ExploreEventItem event) {
    return AppBottomSheet.show(
      context: context,
      title: AppStrings.limitedInvites,
      child: ShareEventBottomSheet(event: event),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tagLabel = event.tagLabel;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Gap(16.h),
        ClipRRect(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.w), topRight: Radius.circular(16.w)),
          child: SizedBox(
            height: 114.h,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                KumeleAssetWidget(
                  assetPath: event.imagePath,
                  width: double.infinity,
                  height: 114.h,
                  fit: BoxFit.cover,
                ),
                if (tagLabel != null)
                  Positioned(
                    top: 12.h,
                    right: 12.w,
                    child: AppTagLabel(label: tagLabel),
                  ),
              ],
            ),
          ),
        ),
        Gap(8.h),
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: ColorSet.tileFillColor,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                event.title,
                style: context.textTheme.headlineSmallBold.copyWith(
                  color: ColorSet.textColor,
                  fontSize: 18.sp,
                ),
              ),
              Gap(12.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildInfoItem(
                      context, Assets.icons.events.dollar.path, event.price),
                  _buildInfoItem(context, Assets.icons.clock.path, event.time),
                  _buildInfoItem(
                      context, Assets.icons.guests.path, event.guests),
                ],
              ),
              Gap(12.h),
              RichText(
                text: TextSpan(
                  style: context.textTheme.bodyMedium.copyWith(
                    color: ColorSet.textColor,
                  ),
                  children: [
                    const TextSpan(text: AppStrings.eventIdLabel),
                    TextSpan(
                      text: event.id,
                      style: TextStyle(
                        color: ColorSet.specialBlueColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Gap(8.h),
              RichText(
                text: TextSpan(
                  style: context.textTheme.bodyMedium.copyWith(
                    color: ColorSet.textColor,
                  ),
                  children: [
                    const TextSpan(text: AppStrings.locationLabel),
                    TextSpan(
                      text: event.location,
                      style: TextStyle(
                        color: ColorSet.specialBlueColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Gap(4.h),
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: ColorSet.tileFillColor,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.howItWorks,
                style: context.textTheme.titleMediumBold.copyWith(
                  color: ColorSet.textColor,
                  fontSize: 15.sp,
                ),
              ),
              Gap(8.h),
              RichText(
                text: TextSpan(
                  style: context.textTheme.bodyMedium.copyWith(
                    color: ColorSet.textColor,
                  ),
                  children: [
                    const TextSpan(text: '1. '),
                    TextSpan(
                      text: AppStrings.login,
                      style: TextStyle(
                        color: ColorSet.specialBlueColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const TextSpan(text: ' or '),
                    TextSpan(
                      text: AppStrings.signup,
                      style: TextStyle(
                        color: ColorSet.specialBlueColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const TextSpan(text: '.'),
                  ],
                ),
              ),
              Gap(4.h),
              Text(
                "2. Copy the event code.",
                style: context.textTheme.bodyMedium.copyWith(
                  color: ColorSet.textColor,
                  height: 1.4,
                ),
              ),
              Gap(4.h),
              Text(
                "3. Search the event and join. It's that easy.",
                style: context.textTheme.bodyMedium.copyWith(
                  color: ColorSet.textColor,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
        Gap(20.h),
        Text(
          AppStrings.inviteFriendsAndFamily,
          style: context.textTheme.titleMedium.copyWith(
            color: ColorSet.textColor,
          ),
        ),
        Gap(12.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 4.w),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppRoundedIconButton(
                    onTap: () {
                      InjectionHelper.clipboardService.copyEventCode(event);
                      InjectionHelper.snackBar
                          .showSuccess(AppStrings.eventCodeCopied);
                    },
                    assetPath: Assets.icons.events.copy.path,
                    iconSize: 16.w,
                  ),
                  Gap(8.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        AppStrings.copyTo,
                        style: context.textTheme.labelSmall.copyWith(
                          color: ColorSet.textColor,
                        ),
                      ),
                      Text(
                        AppStrings.clipboard,
                        style: context.textTheme.labelSmall.copyWith(
                          color: ColorSet.textColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            KumeleAssetWidget(
              assetPath: Assets.logo.kumeleLogo.path,
              width: 50.w,
              height: 50.w,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoItem(
    BuildContext context,
    String assetPath,
    String label,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        KumeleAssetWidget(
          assetPath: assetPath,
          width: 18.w,
          height: 18.w,
          color: ColorSet.textColor,
        ),
        Gap(4.w),
        Text(
          label,
          style: context.textTheme.bodyMedium.copyWith(
            color: ColorSet.textColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
