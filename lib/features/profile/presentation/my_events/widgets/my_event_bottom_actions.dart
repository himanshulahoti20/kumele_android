import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:kuemele/core/app_strings.dart';
import 'package:kuemele/features/explore/domain/entities/explore_event_detail.dart';
import 'package:kuemele/features/explore/presentation/swipe_card/widgets/share_event_bottom_sheet.dart';
import 'package:kuemele/gen/assets.gen.dart';
import 'package:kuemele/navigation/app_routes.dart';
import 'package:kuemele/shared/components/app_button.dart';
import 'package:kuemele/shared/components/app_colors.dart';

class MyEventBottomActions extends StatelessWidget {
  const MyEventBottomActions({
    super.key,
    required this.detail,
    required this.eventId,
  });

  final ExploreEventDetail detail;
  final String eventId;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
      decoration: BoxDecoration(
        color: ColorSet.bg2Color,
      ),
      child: Row(
        children: [
          Expanded(
            child: AppButton.outline(
              label: 'Share',
              iconAsset: Assets.icons.shareSvg.path,
              onPressed: () {
                ShareEventBottomSheet.show(context, detail.toItem());
              },
            ),
          ),
          Gap(12.w),
          Expanded(
            child: AppButton.primary(
              iconAsset: Assets.icons.qrSvg.path,
              label: AppStrings.guestScan,
              onPressed: () {
                context.push(AppRoutes.guestScan, extra: eventId);
              },
            ),
          ),
        ],
      ),
    );
  }
}
