import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/features/profile/presentation/profile_config.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/widgets/kumele_asset_widget.dart';

class ProfileSettingTile extends StatelessWidget {
  const ProfileSettingTile({
    super.key,
    required this.title,
    required this.iconPath,
    this.onTap,
    this.trailing,
    this.showTrailingArrow = true,
  });

  final String title;
  final String iconPath;
  final VoidCallback? onTap;
  final Widget? trailing;
  final bool showTrailingArrow;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(16.r),
          child: Row(
            children: [
              KumeleAssetWidget.square(
                assetPath: iconPath,
                size: 24.r,
              ),
              Gap(8.w),
              Expanded(
                child: Text(
                  title,
                  style: context.textTheme.bodyLarge.copyWith(
                    color: ColorSet.profileSubTextColor,
                    fontSize: 16.sp,
                  ),
                ),
              ),
              if (trailing != null)
                trailing!
              else if (showTrailingArrow)
                KumeleAssetWidget.square(
                  assetPath: ProfileConfig.arrowRightIcon,
                  size: 20.r,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
