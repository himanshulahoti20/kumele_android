import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/core/responsive/responsive.dart';
import 'package:kuemele/gen/assets.gen.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/widgets/kumele_asset_widget.dart';

class CategoryTag extends StatelessWidget {
  const CategoryTag({
    super.key,
    required this.label,
    this.iconPath,
    this.iconPathDark,
    this.iconPNG,
    double? size,
    double? iconSize,
    this.fontSize,
  }) : iconSize = iconSize ?? size;

  final String label;
  final String? iconPath;

  /// Dark-mode variant of [iconPath]. This tag's background never changes
  /// with the app theme (always dark), so it always shows [iconPathDark]
  /// regardless of light/dark mode — unlike [CategoryIconWidget]'s chips,
  /// whose background actually does change by theme.
  final String? iconPathDark;
  final String? iconPNG;
  final double? iconSize;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final resolvedFontSize = fontSize ?? responsive.sp(13);
    final resolvedIcon = iconPathDark ?? iconPath;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: responsive.w(8),
        vertical: responsive.h(5),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(responsive.w(24)),
        color: ColorSet.bg8Color,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          KumeleAssetWidget(
            assetPath: resolvedIcon ?? Assets.icons.spirituality.path,
            height: 20.w,
            width: 20.w,
          ),
          Gap(responsive.w(8)),
          Flexible(
            child: Text(
              label,
              style: context.textTheme.bodySmall.copyWith(
                fontSize: resolvedFontSize,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
