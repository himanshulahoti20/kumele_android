import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/core/responsive/responsive.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/widgets/kumele_asset_widget.dart';

class SwipeCardInfoChip extends StatelessWidget {
  const SwipeCardInfoChip({
    super.key,
    required this.assetPath,
    required this.label,
    this.tintColor,
    this.alignment = Alignment.centerLeft,
    this.compact = false,
  });

  final String assetPath;
  final String label;
  final Color? tintColor;
  final Alignment alignment;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          KumeleAssetWidget(
            assetPath: assetPath,
            width: 20.w,
            height: 20.w,
            color: tintColor ?? ColorSet.textColor,
          ),
          Gap(context.responsive.w(2)),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.textTheme.bodyLarge.copyWith(
                color: ColorSet.textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
