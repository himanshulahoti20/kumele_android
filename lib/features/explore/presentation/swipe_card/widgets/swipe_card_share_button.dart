import 'package:flutter/material.dart';
import 'package:kuemele/core/responsive/responsive.dart';
import 'package:kuemele/features/explore/presentation/swipe_card/swipe_card_layout.dart';
import 'package:kuemele/gen/assets.gen.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/widgets/kumele_asset_widget.dart';

class SwipeCardShareButton extends StatelessWidget {
  const SwipeCardShareButton({
    super.key,
    this.onShareTap,
  });

  final VoidCallback? onShareTap;

  @override
  Widget build(BuildContext context) {
    final layout = SwipeCardLayout(context.responsive);

    return GestureDetector(
      onTap: onShareTap,
      child: Container(
        width: layout.shareButtonSize,
        height: layout.shareButtonSize,
        padding: EdgeInsets.all(context.responsive.w(9)),
        decoration: BoxDecoration(
          color: ColorSet.revertBgColor,
          borderRadius: BorderRadius.circular(context.responsive.w(8)),
        ),
        // revertBgColor is bg3Color's exact inverse (near-black in light
        // mode, white in dark mode), so bg3Color is what always contrasts
        // against it — the icon was hardcoded white ("shareLight"), which
        // vanished once the chip flipped to a white background in dark mode.
        child: KumeleAssetWidget.square(
          assetPath: Assets.icons.shareLight.path,
          size: layout.shareIconSize,
          color: ColorSet.bg3Color,
        ),
      ),
    );
  }
}
