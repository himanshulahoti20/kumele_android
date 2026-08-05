import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/core/responsive/responsive.dart';
import 'package:kuemele/features/explore/domain/entities/explore_event_detail.dart';
import 'package:kuemele/features/explore/presentation/explore_config.dart';
import 'package:kuemele/features/explore/presentation/swipe_card/swipe_card_layout.dart';
import 'package:kuemele/features/explore/presentation/swipe_card/widgets/swipe_card_host_section.dart';
import 'package:kuemele/features/explore/presentation/swipe_card/widgets/swipe_card_rating_section.dart';
import 'package:kuemele/features/explore/presentation/swipe_card/widgets/swipe_card_related_events_list.dart';
import 'package:kuemele/shared/components/app_button.dart';
import 'package:kuemele/shared/components/app_colors.dart';

class SwipeCardExpandedLoadedContent extends StatelessWidget {
  const SwipeCardExpandedLoadedContent({
    super.key,
    required this.detail,
    required this.showRating,
    required this.onJoin,
    this.isJoining = false,
    this.hostEvents = const [],
    this.onHostEventTap,
  });

  final ExploreEventDetail detail;
  final bool showRating;
  final bool isJoining;
  final VoidCallback onJoin;
  final List<ExploreEventItem> hostEvents;
  final ValueChanged<ExploreEventItem>? onHostEventTap;

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
            style: context.textTheme.titleLargeBold.copyWith(
              fontSize: layout.sectionTitleFontSize,
              color: ColorSet.textColor,
            ),
          ),
        if (description.isNotEmpty) Gap(layout.expandedSectionGapSmall),
        SwipeCardHostSection(detail: detail),
        if (showRating && detail.hasRatings) ...[
          Gap(layout.expandedSectionGap),
          SwipeCardRatingSection(
            genreLabel: detail.primaryHobby,
            categoryLabel: detail.primaryHobby,
            ratingValue: detail.averageEventRating ?? 0,
            totalRatings: detail.totalRatings,
          ),
        ],
        if (hostEvents.isNotEmpty) ...[
          Gap(layout.expandedSectionGap),
          Text(
            'Other events from ${detail.hostName}',
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
        if (!responsive.isPhone) ...[
          Gap(layout.expandedSectionGap),
          AppButton.primary(
            label: 'Join',
            fullWidth: true,
            isLoading: isJoining,
            onPressed: onJoin,
          ),
        ],
      ],
    );
  }
}
