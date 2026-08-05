import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/widgets/kumele_asset_widget.dart';
import 'package:kuemele/gen/assets.gen.dart';

class AppTagLabel extends StatelessWidget {
  final String label;
  final String? iconPath;
  final double? fontSize;
  final double? iconSize;
  final Color? backgroundColor;
  final Color? textColor;

  const AppTagLabel({
    super.key,
    required this.label,
    this.iconPath,
    this.fontSize,
    this.iconSize,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedIconPath = iconPath ?? Assets.icons.spirituality.path;
    final resolvedIconSize = 20.w;
    final resolvedBgColor = backgroundColor ?? ColorSet.bg8Color;
    final resolvedTextColor = textColor ?? ColorSet.bg3Color;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 8.w,
        vertical: 5.h,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.w),
        color: resolvedBgColor,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          KumeleAssetWidget(
            assetPath: resolvedIconPath,
            height: resolvedIconSize,
            width: resolvedIconSize,
          ),
          Gap(8.w),
          Flexible(
            child: Text(
              label,
              style: context.textTheme.bodySmall.copyWith(
                fontSize: 13.sp,
                color: resolvedTextColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
