import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/core/responsive/responsive.dart';
import 'package:kuemele/features/explore/domain/entities/explore_event_detail.dart';
import 'package:kuemele/features/explore/presentation/explore_config.dart';
import 'package:kuemele/features/explore/presentation/swipe_card/swipe_card_layout.dart';
import 'package:kuemele/features/explore/presentation/swipe_card/widgets/swipe_card_attendance_rating_section.dart';
import 'package:kuemele/features/explore/presentation/swipe_card/widgets/swipe_card_host_section.dart';
import 'package:kuemele/features/explore/presentation/swipe_card/widgets/swipe_card_rating_section.dart';
import 'package:kuemele/features/explore/presentation/swipe_card/widgets/swipe_card_related_events_list.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/rating.dart';
import 'package:kuemele/shared/models/event_review.dart';
import 'package:kuemele/l10n/app_localizations.dart';

class SwipeCardExpandedLoadedContent extends StatelessWidget {
  const SwipeCardExpandedLoadedContent({
    super.key,
    required this.detail,
    required this.showRating,
    required this.onJoin,
    this.isJoining = false,
    this.hostEvents = const [],
    this.onHostEventTap,
    this.ratingBreakdown = const {},
    this.reviews = const [],
    this.bannerVerticalPaddingFactor = HostStatsBanner.defaultVerticalPadding,
  });

  final ExploreEventDetail detail;
  final bool showRating;
  final bool isJoining;
  final VoidCallback onJoin;
  final List<ExploreEventItem> hostEvents;
  final ValueChanged<ExploreEventItem>? onHostEventTap;
  final Map<RatingType, double> ratingBreakdown;
  final List<EventReview> reviews;

  /// Passed to [SwipeCardHostSection] — the create-event preview uses a
  /// shorter yellow banner than the Explore card.
  final double bannerVerticalPaddingFactor;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final layout = SwipeCardLayout(responsive);
    final description = detail.description.trim();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (description.isNotEmpty)
          Text(
            description,
            // Matches iOS EventDetailView/EventJoinView: this line is the
            // event description in regular weight (plusJakartaRegular
            // 17/15), not a bold section heading — it previously borrowed
            // the bold title style used by "Other events from X"/"Rate
            // event" below it.
            style: context.textTheme.bodyLarge.copyWith(
              fontSize: layout.bodyFontSize,
              color: ColorSet.textColor,
              height: 1.2,
            ),
          ),
        if (description.isNotEmpty) Gap(layout.expandedSectionGapSmall),
        SwipeCardHostSection(
          detail: detail,
          bannerVerticalPaddingFactor: bannerVerticalPaddingFactor,
        ),
        if (showRating && detail.hasRatings) ...[
          Gap(layout.expandedSectionGap),
          SwipeCardRatingSection(
            genreLabel: detail.primaryHobby,
            categoryLabel: detail.primaryHobby,
            ratingValue: detail.averageEventRating ?? 0,
            totalRatings: detail.totalRatings,
          ),
          if (ratingBreakdown.isNotEmpty || reviews.isNotEmpty) ...[
            Gap(layout.expandedSectionGap),
            SwipeCardAttendanceRatingSection(
              ratingBreakdown: ratingBreakdown,
              reviews: reviews,
            ),
          ],
        ],
        if (hostEvents.isNotEmpty) ...[
          Gap(layout.expandedSectionGap),
          Text(
            AppLocalizations.of(context)!
                .otherEventsFromHostLabel(detail.hostName),
            style: context.textTheme.titleLargeBold.copyWith(
              fontSize: layout.sectionTitleFontSize,
              color: ColorSet.textColor,
            ),
          ),
          Gap(layout.expandedSectionGapSmall),
          SwipeCardRelatedEventsList(
            events: hostEvents,
            onEventTap: onHostEventTap,
          ),
        ],
      ],
    );
  }
}
