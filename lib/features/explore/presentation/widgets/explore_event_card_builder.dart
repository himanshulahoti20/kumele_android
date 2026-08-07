import 'package:kuemele/features/explore/presentation/explore_config.dart';
import 'package:flutter/widgets.dart';
import 'package:kuemele/shared/components/event_card/event_card.dart';

class ExploreEventCardBuilder {
  ExploreEventCardBuilder._();

  static Widget fromItem(
    ExploreEventItem event,
    int index, {
    bool showBottomLeftContainer = false,
    bool showDeleteIcon = false,
    bool cancelButton = false,
  }) {
    return EventCard(
      eventId: event.id,
      title: event.title,
      imagePath: event.imagePath,
      category: event.category ?? '',
      time: event.time,
      price: event.price,
      guests: event.guests,
      startTime: event.startTime,
      index: index,
      showBottomLeftContainer: showBottomLeftContainer,
      showDeleteIcon: showDeleteIcon,
      cancelButton: cancelButton,
    );
  }
}
