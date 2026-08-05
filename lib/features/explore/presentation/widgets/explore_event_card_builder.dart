import 'package:kuemele/features/explore/presentation/explore_config.dart';
import 'package:kuemele/shared/components/event_card/event_card.dart';

class ExploreEventCardBuilder {
  ExploreEventCardBuilder._();

  static EventCard fromItem(
    ExploreEventItem event,
    int index, {
    bool showSummary = false,
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
      showSummary: showSummary,
      showBottomLeftContainer: showBottomLeftContainer,
      showDeleteIcon: showDeleteIcon,
      cancelButton: cancelButton,
    );
  }
}
