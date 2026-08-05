import 'package:kuemele/features/explore/domain/entities/event_guest_entity.dart';
import 'package:kuemele/features/explore/domain/entities/explore_event.dart';
import 'package:kuemele/features/explore/domain/entities/explore_event_detail.dart';

enum EventDetailStatus { initial, loading, loaded, failure }

class EventDetailState {
  const EventDetailState({
    this.status = EventDetailStatus.initial,
    this.eventId,
    this.detail,
    this.hostEvents = const [],
    this.guests = const [],
    this.isGuestsLoading = false,
    this.guestsErrorMessage,
    this.errorMessage,
    this.isJoining = false,
    this.joinSucceeded = false,
    this.joinErrorMessage,
  });

  final EventDetailStatus status;
  final String? eventId;
  final ExploreEventDetail? detail;
  final List<ExploreEvent> hostEvents;
  final List<EventGuestEntity> guests;
  final bool isGuestsLoading;
  final String? guestsErrorMessage;
  final String? errorMessage;
  final bool isJoining;
  final bool joinSucceeded;
  final String? joinErrorMessage;

  bool get isLoading => status == EventDetailStatus.loading;
  bool get isLoaded => status == EventDetailStatus.loaded;
  bool get hasError => status == EventDetailStatus.failure;

  EventDetailState copyWith({
    EventDetailStatus? status,
    String? eventId,
    ExploreEventDetail? detail,
    List<ExploreEvent>? hostEvents,
    List<EventGuestEntity>? guests,
    bool? isGuestsLoading,
    String? guestsErrorMessage,
    String? errorMessage,
    bool? isJoining,
    bool? joinSucceeded,
    String? joinErrorMessage,
    bool clearDetail = false,
    bool clearHostEvents = false,
    bool clearGuests = false,
    bool clearError = false,
    bool clearGuestsError = false,
    bool clearJoinError = false,
    bool clearJoinSucceeded = false,
  }) {
    return EventDetailState(
      status: status ?? this.status,
      eventId: eventId ?? this.eventId,
      detail: clearDetail ? null : detail ?? this.detail,
      hostEvents: clearHostEvents ? const [] : hostEvents ?? this.hostEvents,
      guests: clearGuests ? const [] : guests ?? this.guests,
      isGuestsLoading: isGuestsLoading ?? this.isGuestsLoading,
      guestsErrorMessage: clearGuestsError
          ? null
          : guestsErrorMessage ?? this.guestsErrorMessage,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      isJoining: isJoining ?? this.isJoining,
      joinSucceeded:
          clearJoinSucceeded ? false : joinSucceeded ?? this.joinSucceeded,
      joinErrorMessage:
          clearJoinError ? null : joinErrorMessage ?? this.joinErrorMessage,
    );
  }
}
