import 'package:flutter/material.dart';
import 'package:kuemele/core/responsive/responsive.dart';
import 'package:kuemele/features/explore/presentation/explore_config.dart';
import 'package:kuemele/features/explore/presentation/swipe_card/widgets/swipe_card_body_variants.dart';
import 'package:kuemele/features/discover/cubit/create_event_cubit.dart';

class SwipeCardBody extends StatelessWidget {
  const SwipeCardBody({
    super.key,
    required this.event,
    this.createEventState,
    required this.backgroundColor,
    required this.isExpanded,
    required this.showRating,
    this.showRelatedEvents = true,
    this.onChangeExpand,
    this.onShareTap,
    this.isPreview = false,
  });

  final ExploreEventItem event;
  final CreateEventState? createEventState;
  final Color backgroundColor;
  final bool isExpanded;
  final bool showRating;
  final bool showRelatedEvents;
  final VoidCallback? onChangeExpand;
  final VoidCallback? onShareTap;
  final bool isPreview;

  @override
  Widget build(BuildContext context) {
    final layout = context.responsive.layout;

    return switch (layout) {
      ResponsiveLayout.mobilePortrait ||
      ResponsiveLayout.tabletPortrait =>
        SwipeCardBodyPortrait(
          event: event,
          createEventState: createEventState,
          backgroundColor: backgroundColor,
          isExpanded: isExpanded,
          showRating: showRating,
          showRelatedEvents: showRelatedEvents,
          onChangeExpand: onChangeExpand,
          onShareTap: onShareTap,
          isPreview: isPreview,
        ),
      ResponsiveLayout.mobileLandscape ||
      ResponsiveLayout.tabletLandscape =>
        SwipeCardBodyLandscape(
          event: event,
          createEventState: createEventState,
          backgroundColor: backgroundColor,
          isExpanded: isExpanded,
          showRating: showRating,
          showRelatedEvents: showRelatedEvents,
          onChangeExpand: onChangeExpand,
          onShareTap: onShareTap,
          isPreview: isPreview,
        ),
    };
  }
}
