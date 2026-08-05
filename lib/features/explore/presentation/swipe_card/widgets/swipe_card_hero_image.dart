import 'package:flutter/material.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/core/responsive/responsive.dart';
import 'package:kuemele/features/explore/presentation/explore_config.dart';
import 'package:kuemele/features/explore/presentation/swipe_card/swipe_card_layout.dart';
import 'package:kuemele/gen/assets.gen.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/widgets/kumele_asset_widget.dart';

class SwipeCardHeroImage extends StatelessWidget {
  const SwipeCardHeroImage({
    super.key,
    required this.imagePath,
    required this.showBottomLeftContainer,
    this.width,
    this.height,
  });

  final String imagePath;
  final bool showBottomLeftContainer;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final layout = SwipeCardLayout(responsive);
    final imageWidth = width ?? double.infinity;
    final imageHeight = height ?? layout.imageHeight;

    return SizedBox(
      width: imageWidth,
      height: imageHeight,
      child: Stack(
        fit: StackFit.expand,
        children: [
          KumeleAssetWidget(
            assetPath: imagePath,
            width: imageWidth,
            height: imageHeight,
            fit: BoxFit.cover,
          ),
          if (showBottomLeftContainer)
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: EdgeInsets.only(bottom: responsive.h(4)),
                child: SizedBox(
                  height: responsive.h(24),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      KumeleAssetWidget(
                        assetPath: Assets.svg.rectangle.path,
                        fit: BoxFit.fill,
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          responsive.w(6),
                          responsive.h(3),
                          responsive.w(16),
                          responsive.h(3),
                        ),
                        child: Text(
                          ExploreConfig.swipeCardTodayLabel,
                          style: context.textTheme.labelMediumBold.copyWith(
                            fontSize: responsive.sp(13),
                            color: ColorSet.textColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
