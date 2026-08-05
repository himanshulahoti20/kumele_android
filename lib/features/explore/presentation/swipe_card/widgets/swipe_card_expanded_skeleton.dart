import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/core/responsive/responsive.dart';
import 'package:kuemele/features/explore/presentation/swipe_card/swipe_card_layout.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SwipeCardExpandedSkeleton extends StatelessWidget {
  const SwipeCardExpandedSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final layout = SwipeCardLayout(responsive);

    return Skeletonizer(
      enabled: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Loading event description placeholder text',
            style: context.textTheme.titleLargeBold.copyWith(
              fontSize: layout.sectionTitleFontSize,
              color: ColorSet.textColor,
            ),
          ),
          Gap(layout.expandedSectionGapSmall),
          Container(
            height: responsive.h(180),
            decoration: BoxDecoration(
              color: ColorSet.hostTileColor,
              borderRadius: BorderRadius.circular(responsive.w(10)),
            ),
          ),
          Gap(layout.expandedSectionGap),
          Container(
            height: responsive.h(120),
            decoration: BoxDecoration(
              color: ColorSet.hostTileColor,
              borderRadius: BorderRadius.circular(responsive.w(10)),
            ),
          ),
        ],
      ),
    );
  }
}
