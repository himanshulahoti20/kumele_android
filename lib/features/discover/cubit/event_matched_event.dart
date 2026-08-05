import 'package:kuemele/features/discover/presentation/discover_config.dart';

sealed class EventMatchedEvent {
  const EventMatchedEvent();
}

final class EventMatchedStarted extends EventMatchedEvent {
  const EventMatchedStarted(this.eventData);

  final DiscoverMatchedEventData eventData;
}

final class EventMatchedGoToChatTapped extends EventMatchedEvent {
  const EventMatchedGoToChatTapped();
}

final class EventMatchedConfettiCompleted extends EventMatchedEvent {
  const EventMatchedConfettiCompleted();
}
