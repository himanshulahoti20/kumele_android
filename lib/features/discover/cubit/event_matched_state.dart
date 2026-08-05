import 'package:kuemele/features/discover/presentation/discover_config.dart';

enum EventMatchedStatus {
  initial,
  ready,
  joiningChat,
  joinChatFailed,
  navigating,
}

class EventMatchedState {
  const EventMatchedState({
    this.status = EventMatchedStatus.initial,
    required this.eventData,
    this.showConfetti = true,
    this.errorMessage,
  });

  final EventMatchedStatus status;
  final DiscoverMatchedEventData eventData;
  final bool showConfetti;
  final String? errorMessage;

  EventMatchedState copyWith({
    EventMatchedStatus? status,
    DiscoverMatchedEventData? eventData,
    bool? showConfetti,
    String? errorMessage,
    bool clearError = false,
  }) {
    return EventMatchedState(
      status: status ?? this.status,
      eventData: eventData ?? this.eventData,
      showConfetti: showConfetti ?? this.showConfetti,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
