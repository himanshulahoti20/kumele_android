import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/core/responsive/responsive.dart';
import 'package:kuemele/features/explore/presentation/explore_config.dart';
import 'package:kuemele/features/explore/presentation/swipe_card/swipe_card_layout.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/event_card/event_card2.dart';

class SwipeCardRelatedEventsList extends StatelessWidget {
  const SwipeCardRelatedEventsList({
    super.key,
    required this.events,
    this.onEventTap,
  });

  final List<ExploreEventItem> events;
  final ValueChanged<ExploreEventItem>? onEventTap;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final layout = SwipeCardLayout(responsive);

    return SizedBox(
      height: layout.relatedEventsListHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: events.length,
        separatorBuilder: (_, __) => Gap(responsive.w(10)),
        itemBuilder: (context, index) {
          final event = events[index];
          return GestureDetector(
            onTap: onEventTap != null ? () => onEventTap!(event) : null,
            child: EventCard2(
              title: event.title,
              imagePath: event.imagePath,
              category: event.category ?? '',
              time: event.time,
              price: event.price,
              guests: event.guests,
              startTime: event.startTime,
              bgColor: ColorSet.hostTileColor,
            ),
          );
        },
      ),
    );
  }
}
