import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kuemele/core/responsive/responsive.dart';
import 'package:kuemele/features/explore/presentation/explore_config.dart';
import 'package:kuemele/features/explore/presentation/swipe_card/swipe_card_layout.dart';
import 'package:kuemele/features/explore/presentation/swipe_card/widgets/swipe_card_body.dart';
import 'package:kuemele/features/discover/cubit/create_event_cubit.dart';
import 'package:kuemele/features/explore/presentation/swipe_card/widgets/swipe_card_delete_overlay.dart';
import 'package:kuemele/features/explore/presentation/swipe_card/widgets/swipe_card_hero_image.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/event_card/widgets/category_tag.dart';

class SwipeCard extends StatelessWidget {
  const SwipeCard({
    super.key,
    required this.event,
    this.createEventState,
    this.showBottomLeftContainer = false,
    this.showDeleteIcon = false,
    this.bgColor,
    this.onChangeExpand,
    this.onShareTap,
    this.isExpanded = false,
    this.showRating = false,
    this.showRelatedEvents = true,
  }) : isPreview = false;

  const SwipeCard.preview({
    super.key,
    required this.event,
    this.createEventState,
    this.showBottomLeftContainer = false,
    this.showDeleteIcon = false,
    this.bgColor,
    this.onChangeExpand,
    this.onShareTap,
    this.isExpanded = false,
    this.showRating = false,
    this.showRelatedEvents = true,
  }) : isPreview = true;

  final ExploreEventItem event;
  final CreateEventState? createEventState;
  final bool showBottomLeftContainer;
  final bool showDeleteIcon;
  final Color? bgColor;
  final VoidCallback? onChangeExpand;
  final VoidCallback? onShareTap;
  final bool isExpanded;
  final bool showRating;
  final bool showRelatedEvents;
  final bool isPreview;

  Color get _backgroundColor => bgColor ?? ColorSet.bg2Color;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final layout = SwipeCardLayout(responsive);

    final content = switch (responsive.layout) {
      ResponsiveLayout.mobilePortrait ||
      ResponsiveLayout.tabletPortrait =>
        _SwipeCardPortraitContent(
          layout: layout,
          event: event,
          createEventState: createEventState,
          showBottomLeftContainer: showBottomLeftContainer,
          showDeleteIcon: showDeleteIcon,
          backgroundColor: _backgroundColor,
          isExpanded: isExpanded,
          showRating: showRating,
          showRelatedEvents: showRelatedEvents,
          onChangeExpand: onChangeExpand,
          onShareTap: onShareTap,
          isPreview: isPreview,
        ),
      ResponsiveLayout.mobileLandscape ||
      ResponsiveLayout.tabletLandscape =>
        _SwipeCardLandscapeContent(
          layout: layout,
          event: event,
          createEventState: createEventState,
          showBottomLeftContainer: showBottomLeftContainer,
          showDeleteIcon: showDeleteIcon,
          backgroundColor: _backgroundColor,
          isExpanded: isExpanded,
          showRating: showRating,
          showRelatedEvents: showRelatedEvents,
          onChangeExpand: onChangeExpand,
          onShareTap: onShareTap,
          isPreview: isPreview,
        ),
    };

    final card = ClipRRect(
      borderRadius: BorderRadius.circular(layout.borderRadius),
      child: Container(
        color: _backgroundColor,
        child: isExpanded
            ? SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: content,
              )
            : Padding(
                padding: EdgeInsets.only(bottom: layout.stackBottomInset),
                child: content,
              ),
      ),
    );

    if (isExpanded) return card;

    return Align(
      alignment: Alignment.topCenter,
      child: card,
    );
  }
}

class _SwipeCardPortraitContent extends StatelessWidget {
  const _SwipeCardPortraitContent({
    required this.layout,
    required this.event,
    this.createEventState,
    required this.showBottomLeftContainer,
    required this.showDeleteIcon,
    required this.backgroundColor,
    required this.isExpanded,
    required this.showRating,
    required this.showRelatedEvents,
    required this.isPreview,
    this.onChangeExpand,
    this.onShareTap,
  });

  final SwipeCardLayout layout;
  final ExploreEventItem event;
  final CreateEventState? createEventState;
  final bool showBottomLeftContainer;
  final bool showDeleteIcon;
  final Color backgroundColor;
  final bool isExpanded;
  final bool showRating;
  final bool showRelatedEvents;
  final bool isPreview;
  final VoidCallback? onChangeExpand;
  final VoidCallback? onShareTap;

  @override
  Widget build(BuildContext context) {
    final tagLabel = event.tagLabel;

    return Stack(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwipeCardHeroImage(
              imagePath: event.imagePath,
              showBottomLeftContainer: showBottomLeftContainer,
            ),
            AnimatedSize(
              duration: layout.animationDuration,
              alignment: Alignment.topCenter,
              child: SwipeCardBody(
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
            ),
          ],
        ),
        if (showDeleteIcon) const SwipeCardDeleteOverlay(),
        if (tagLabel != null)
          Positioned(
            top: layout.categoryTagTop,
            right: layout.categoryTagRight,
            child: CategoryTag(
              label: tagLabel,
              size: 23.sp,
            ),
          ),
      ],
    );
  }
}

class _SwipeCardLandscapeContent extends StatelessWidget {
  const _SwipeCardLandscapeContent({
    required this.layout,
    required this.event,
    this.createEventState,
    required this.showBottomLeftContainer,
    required this.showDeleteIcon,
    required this.backgroundColor,
    required this.isExpanded,
    required this.showRating,
    required this.showRelatedEvents,
    required this.isPreview,
    this.onChangeExpand,
    this.onShareTap,
  });

  final SwipeCardLayout layout;
  final ExploreEventItem event;
  final CreateEventState? createEventState;
  final bool showBottomLeftContainer;
  final bool showDeleteIcon;
  final Color backgroundColor;
  final bool isExpanded;
  final bool showRating;
  final bool showRelatedEvents;
  final bool isPreview;
  final VoidCallback? onChangeExpand;
  final VoidCallback? onShareTap;

  @override
  Widget build(BuildContext context) {
    final imageHeight = isExpanded
        ? layout.landscapeImageHeight * 1.4
        : layout.landscapeImageHeight;
    final tagLabel = event.tagLabel;

    return Stack(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwipeCardHeroImage(
              imagePath: event.imagePath,
              showBottomLeftContainer: showBottomLeftContainer,
              width: layout.landscapeImageWidth,
              height: imageHeight,
            ),
            Expanded(
              child: AnimatedSize(
                duration: layout.animationDuration,
                alignment: Alignment.topCenter,
                child: SwipeCardBody(
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
              ),
            ),
          ],
        ),
        if (showDeleteIcon) const SwipeCardDeleteOverlay(),
        if (tagLabel != null)
          Positioned(
            top: layout.categoryTagTop,
            left: layout.landscapeImageWidth - context.responsive.w(30),
            child: CategoryTag(
              label: tagLabel,
              size: context.responsive.w(18),
              fontSize: context.responsive.sp(14),
            ),
          ),
      ],
    );
  }
}
