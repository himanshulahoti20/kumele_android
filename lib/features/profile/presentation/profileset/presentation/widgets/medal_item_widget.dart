import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/features/profile/presentation/profile_config.dart';
import 'package:kuemele/shared/widgets/kumele_asset_widget.dart';

class MedalItemWidget extends StatelessWidget {
  final MedalsModel medal;

  const MedalItemWidget({
    super.key,
    required this.medal,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 24.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          KumeleAssetWidget(
            assetPath: medal.imagePath,
            width: 28.w,
            height: 28.w,
          ),
          Gap(16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  medal.title,
                  style: context.textTheme.titleMediumBold.copyWith(
                    color: ColorSet.textColor,
                  ),
                ),
                Gap(6.h),
                Text(
                  medal.subtitle,
                  style: context.textTheme.bodyMedium.copyWith(
                    color: ColorSet.subTextColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
