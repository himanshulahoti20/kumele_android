import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/core/responsive/responsive.dart';
import 'package:kuemele/l10n/app_localizations.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/rating.dart';
import 'package:kuemele/shared/models/event_review.dart';
import 'package:kuemele/shared/widgets/app_avatar.dart';

/// "Rate Event" / "Attendance Rating" breakdown + written guest reviews —
/// the read-only view of the same 5 categories `rating_page.dart` collects
/// when a user submits a rating.
class SwipeCardAttendanceRatingSection extends StatelessWidget {
  const SwipeCardAttendanceRatingSection({
    super.key,
    required this.ratingBreakdown,
    required this.reviews,
  });

  final Map<RatingType, double> ratingBreakdown;
  final List<EventReview> reviews;

  @override
  Widget build(BuildContext context) {
    if (ratingBreakdown.isEmpty && reviews.isEmpty) {
      return const SizedBox.shrink();
    }
    final responsive = context.responsive;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.rateEventTitle,
          style: context.textTheme.titleLargeBold.copyWith(
            fontSize: responsive.sp(18),
            color: ColorSet.textColor,
          ),
        ),
        Gap(responsive.h(10)),
        if (ratingBreakdown.isNotEmpty) ...[
          Text(
            'Attendance Rating',
            style: context.textTheme.bodySmallSemiBold.copyWith(
              fontSize: responsive.sp(14),
              color: ColorSet.textColor,
            ),
          ),
          Gap(responsive.h(15)),
          RARatingSummary(
            ratingSummaryData: ratingBreakdown,
            showValue: false,
          ),
        ],
        if (reviews.isNotEmpty) ...[
          Gap(responsive.h(20)),
          for (final review in reviews) ...[
            _ReviewTile(review: review),
            if (review != reviews.last) Gap(responsive.h(16)),
          ],
        ],
      ],
    );
  }
}

class _ReviewTile extends StatelessWidget {
  const _ReviewTile({required this.review});

  final EventReview review;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppAvatar(
          imageUrl: review.reviewerAvatar,
          name: review.reviewerName,
          size: responsive.w(36),
        ),
        Gap(responsive.w(10)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    review.reviewerName,
                    style: context.textTheme.bodyMediumBold.copyWith(
                      fontSize: responsive.sp(13),
                      color: ColorSet.textColor,
                    ),
                  ),
                  if (review.dateLabel != null) ...[
                    Text(
                      ' • ',
                      style: context.textTheme.bodySmall.copyWith(
                        color: ColorSet.subTextColor,
                      ),
                    ),
                    Text(
                      review.dateLabel!,
                      style: context.textTheme.bodySmall.copyWith(
                        fontSize: responsive.sp(12),
                        color: ColorSet.subTextColor,
                      ),
                    ),
                  ],
                ],
              ),
              if (review.comment.isNotEmpty) ...[
                Gap(responsive.h(4)),
                Text(
                  review.comment,
                  style: context.textTheme.bodySmall.copyWith(
                    fontSize: responsive.sp(13),
                    color: ColorSet.textColor,
                    height: 1.4,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
