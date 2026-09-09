import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/core/responsive/responsive.dart';
import 'package:kuemele/gen/assets.gen.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/event_card/widgets/category_tag.dart';
import 'package:kuemele/shared/components/rating.dart';

class SwipeCardRatingSection extends StatelessWidget {
  const SwipeCardRatingSection({
    super.key,
    required this.genreLabel,
    required this.categoryLabel,
    required this.ratingValue,
    required this.totalRatings,
  });

  final String genreLabel;
  final String categoryLabel;
  final double ratingValue;
  final int totalRatings;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (genreLabel.isNotEmpty)
          Row(
            children: [
              Text(
                genreLabel,
                style: context.textTheme.bodyLargeBold.copyWith(
                  fontSize: responsive.sp(16),
                  color: ColorSet.lightBlueColor,
                ),
              ),
              if (categoryLabel.isNotEmpty) ...[
                Gap(responsive.w(4)),
                CategoryTag(
                  label: categoryLabel,
                  iconPNG: Assets.icons.houseParty.path,
                ),
              ],
            ],
          ),
        Gap(responsive.h(4)),
        RatingBar(
          value: ratingValue,
          itemSize: responsive.w(30),
        ),
        Gap(responsive.h(8)),
        Text(
          '${ratingValue.toStringAsFixed(1)} out of 5',
          style: context.textTheme.labelMediumSemiBold.copyWith(
            fontSize: responsive.sp(13),
            color: ColorSet.subTextColor,
          ),
        ),
        Gap(responsive.h(6)),
        Text(
          '$totalRatings Guest ratings',
          style: context.textTheme.titleMediumSemiBold.copyWith(
            fontSize: responsive.sp(15),
            color: ColorSet.textColor,
          ),
        ),
      ],
    );
  }
}
