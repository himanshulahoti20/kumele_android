import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/core/responsive/responsive.dart';
import 'package:kuemele/gen/assets.gen.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/widgets/kumele_asset_widget.dart';

class EventMatchedEventHeader extends StatelessWidget {
  const EventMatchedEventHeader({
    super.key,
    required this.heroImagePath,
    required this.categoryIconPath,
    required this.title,
  });

  final String heroImagePath;
  final String categoryIconPath;
  final String title;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final heroSize = responsive.pick(
      mobilePortrait: 140.0,
      tabletPortrait: 160.0,
      tabletLandscape: 170.0,
    );
    final categorySize = responsive.pick(
      mobilePortrait: 34.0,
      tabletPortrait: 36.0,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        KumeleAssetWidget(
          assetPath: heroImagePath,
          width: responsive.w(heroSize),
          height: responsive.w(heroSize),
          fit: BoxFit.contain,
        ),
        Gap(responsive.h(12)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: responsive.w(categorySize),
              height: responsive.w(categorySize),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ColorSet.revbg3Color,
                border: Border.all(
                  color: ColorSet.bg2Color,
                  width: responsive.w(2),
                ),
              ),
              child: ClipOval(
                child: _buildCategoryIcon(context, categorySize),
              ),
            ),
            Gap(responsive.w(10)),
            Flexible(
              child: Text(
                title,
                style: context.textTheme.titleLargeBold.copyWith(
                  color: ColorSet.bg2Color,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryIcon(BuildContext context, double size) {
    final responsive = context.responsive;
    final pixelSize = responsive.w(size);
    if (categoryIconPath.isEmpty) {
      return SizedBox(width: pixelSize, height: pixelSize);
    }

    final isEmoji =
        !categoryIconPath.contains('/') && !categoryIconPath.contains('.');
    if (isEmoji) {
      return Center(
        child: Text(
          categoryIconPath,
          style: context.textTheme.bodyMedium.copyWith(
            fontSize: pixelSize * 0.65,
            height: 1.0,
          ),
        ),
      );
    }

    return KumeleAssetWidget(
      assetPath: Assets.icons.spirituality.path,
      fit: BoxFit.cover,
      width: pixelSize,
      height: pixelSize,
    );
  }
}
