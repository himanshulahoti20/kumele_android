import 'package:kuemele/features/explore/domain/entities/explore_event.dart';

enum MyEventsTab { created, joined }

enum MyEventsStatus { initial, loading, loaded, failure }

class MyEventsState {
  const MyEventsState({
    this.status = MyEventsStatus.initial,
    this.activeTab = MyEventsTab.created,
    this.createdEvents = const [],
    this.errorMessage,
  });

  final MyEventsStatus status;
  final MyEventsTab activeTab;
  final List<ExploreEvent> createdEvents;
  final String? errorMessage;

  bool get isLoading =>
      status == MyEventsStatus.loading || status == MyEventsStatus.initial;
  bool get hasError => status == MyEventsStatus.failure;
  bool get hasCreatedEvents => createdEvents.isNotEmpty;

  MyEventsState copyWith({
    MyEventsStatus? status,
    MyEventsTab? activeTab,
    List<ExploreEvent>? createdEvents,
    String? errorMessage,
    bool clearError = false,
  }) {
    return MyEventsState(
      status: status ?? this.status,
      activeTab: activeTab ?? this.activeTab,
      createdEvents: createdEvents ?? this.createdEvents,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}
