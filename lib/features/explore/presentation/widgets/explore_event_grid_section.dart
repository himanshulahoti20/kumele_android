import 'package:flutter/material.dart';
import 'package:kuemele/core/responsive/responsive.dart';
import 'package:kuemele/features/explore/presentation/explore_config.dart';
import 'package:kuemele/features/explore/presentation/widgets/explore_event_card_builder.dart';
import 'package:kuemele/features/explore/presentation/widgets/explore_section_header.dart';
import 'package:kuemele/l10n/app_localizations.dart';
import 'package:kuemele/shared/components/app_colors.dart';

typedef ExploreEventCardFactory = Widget Function(
  ExploreEventItem event,
  int index,
);

class ExploreEventGridSection extends StatelessWidget {
  const ExploreEventGridSection({
    super.key,
    required this.title,
    required this.events,
    required this.itemCount,
    required this.showAll,
    required this.onToggleViewAll,
    required this.cardBuilder,
    this.emptyMessage,
  });

  final String title;
  final List<ExploreEventItem> events;
  final int itemCount;
  final bool showAll;
  final VoidCallback onToggleViewAll;
  final ExploreEventCardFactory cardBuilder;

  /// Shown instead of the grid when [events] is empty — matches
  /// HomeView_iPad's `HomeEmptySectionView`: the section header still
  /// renders, only the content underneath is replaced.
  final String? emptyMessage;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    // Always 3 per row on Home, regardless of orientation-driven grid
    // columns elsewhere — "show more" reveals additional rows of 3, not
    // more columns.
    const crossAxisCount = 3;
    final count = itemCount.clamp(0, events.length);

    return ExploreSectionContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ExploreSectionHeader(
            title: title,
            showAll: showAll,
            onToggleViewAll: onToggleViewAll,
          ),
          const ExploreSectionSpacer(),
          if (events.isEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
              child: Text(
                emptyMessage ?? '',
                style: TextStyle(color: ColorSet.subTextColor, fontSize: 14),
              ),
            )
          else
            GridView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.only(left: 20, right: 20),
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: responsive.gutter,
                mainAxisSpacing: responsive.gutter,
                childAspectRatio: 0.9,
              ),
              itemCount: count,
              itemBuilder: (context, index) =>
                  cardBuilder(events[index], index),
            ),
        ],
      ),
    );
  }
}

class ExploreMatchedEventsSection extends StatelessWidget {
  const ExploreMatchedEventsSection({
    super.key,
    required this.events,
    required this.showAll,
    required this.onToggleViewAll,
  });

  final List<ExploreEventItem> events;
  final bool showAll;
  final VoidCallback onToggleViewAll;

  @override
  Widget build(BuildContext context) {
    return ExploreEventGridSection(
      title: AppLocalizations.of(context)!.exploreMatchedEventLabel,
      events: events,
      showAll: showAll,
      onToggleViewAll: onToggleViewAll,
      itemCount: showAll ? events.length : 3,
      emptyMessage: 'No matched events yet.',
      cardBuilder: (event, index) => ExploreEventCardBuilder.fromItem(
        event,
        index,
        showBottomLeftContainer: index < 3,
        showDeleteIcon: index >= 3,
        cancelButton: showAll && index < 3,
      ),
    );
  }
}

class ExploreCreatedEventsSection extends StatelessWidget {
  const ExploreCreatedEventsSection({
    super.key,
    required this.events,
    required this.showAll,
    required this.onToggleViewAll,
  });

  final List<ExploreEventItem> events;
  final bool showAll;
  final VoidCallback onToggleViewAll;

  @override
  Widget build(BuildContext context) {
    return ExploreEventGridSection(
      title: AppLocalizations.of(context)!.exploreCreatedEventLabel,
      events: events,
      showAll: showAll,
      onToggleViewAll: onToggleViewAll,
      itemCount: showAll ? 6 : 3,
      emptyMessage: 'No created events yet.',
      cardBuilder: (event, index) => ExploreEventCardBuilder.fromItem(
        event,
        index,
        showBottomLeftContainer: index < 3,
        showDeleteIcon: index >= 3,
        cancelButton: index < 3,
      ),
    );
  }
}
