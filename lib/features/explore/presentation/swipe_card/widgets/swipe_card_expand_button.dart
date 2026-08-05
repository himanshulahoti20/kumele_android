import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kuemele/core/responsive/responsive.dart';
import 'package:kuemele/features/explore/presentation/swipe_card/swipe_card_layout.dart';
import 'package:kuemele/gen/assets.gen.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/widgets/kumele_asset_widget.dart';

class SwipeCardExpandButton extends StatelessWidget {
  const SwipeCardExpandButton({
    super.key,
    required this.isExpanded,
    this.onTap,
  });

  final bool isExpanded;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final layout = SwipeCardLayout(context.responsive);

    return InkWell(
      onTap: onTap,
      child: Container(
        width: 40.w,
        height: 40.w,
        padding: EdgeInsets.all(context.responsive.w(8)),
        decoration: BoxDecoration(
          color: ColorSet.bgColor,
          shape: BoxShape.circle,
        ),
        child: AnimatedRotation(
          turns: isExpanded ? 0.75 : 0.25,
          duration: layout.animationDuration,
          child: KumeleAssetWidget(
            assetPath: Assets.svg.iconArrow.path,
            width: 24.w,
            height: 24.w,
            color: ColorSet.textColor,
          ),
        ),
      ),
    );
  }
}
