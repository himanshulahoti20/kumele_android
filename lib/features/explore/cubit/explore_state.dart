import 'package:kuemele/features/explore/domain/entities/explore_event.dart';

enum ExploreStatus { initial, loading, loaded, failure }

class ExploreState {
  const ExploreState({
    this.status = ExploreStatus.initial,
    this.events = const [],
    this.errorMessage,
    this.cursor,
    this.hasNext = false,
    this.showAllMatchedEvents = false,
    this.showAllCreatedEvents = false,
    this.showCreatedEventSection = true,
    this.focusSearch = false,
    this.searchQuery = '',
    this.currentCardIndex = 0,
    this.hasSwipedAllCards = false,
    this.eventInLocationHeight = 200,
    this.secondSectionHeight = 700,
  });

  final ExploreStatus status;
  final List<ExploreEvent> events;
  final String? errorMessage;
  final String? cursor;
  final bool hasNext;
  final bool showAllMatchedEvents;
  final bool showAllCreatedEvents;
  final bool showCreatedEventSection;
  final bool focusSearch;
  final String searchQuery;
  final int currentCardIndex;
  final bool hasSwipedAllCards;
  final double eventInLocationHeight;
  final double secondSectionHeight;

  bool get isLoading => status == ExploreStatus.loading;
  bool get hasError => status == ExploreStatus.failure;
  bool get hasEvents => events.isNotEmpty;
  List<ExploreEvent> get visibleEvents {
    final query = searchQuery.trim().toLowerCase();
    if (query.isEmpty) return events;
    return events.where((event) {
      return [
        event.title,
        event.hobbyKey,
        event.hostName,
        event.displayLocation,
      ].whereType<String>().any((value) {
        return value.toLowerCase().contains(query);
      });
    }).toList();
  }

  ExploreState copyWith({
    ExploreStatus? status,
    List<ExploreEvent>? events,
    String? errorMessage,
    String? cursor,
    bool? hasNext,
    bool? showAllMatchedEvents,
    bool? showAllCreatedEvents,
    bool? showCreatedEventSection,
    bool? focusSearch,
    String? searchQuery,
    int? currentCardIndex,
    bool? hasSwipedAllCards,
    double? eventInLocationHeight,
    double? secondSectionHeight,
    bool clearError = false,
  }) {
    return ExploreState(
      status: status ?? this.status,
      events: events ?? this.events,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      cursor: cursor ?? this.cursor,
      hasNext: hasNext ?? this.hasNext,
      showAllMatchedEvents: showAllMatchedEvents ?? this.showAllMatchedEvents,
      showAllCreatedEvents: showAllCreatedEvents ?? this.showAllCreatedEvents,
      showCreatedEventSection:
          showCreatedEventSection ?? this.showCreatedEventSection,
      focusSearch: focusSearch ?? this.focusSearch,
      searchQuery: searchQuery ?? this.searchQuery,
      currentCardIndex: currentCardIndex ?? this.currentCardIndex,
      hasSwipedAllCards: hasSwipedAllCards ?? this.hasSwipedAllCards,
      eventInLocationHeight:
          eventInLocationHeight ?? this.eventInLocationHeight,
      secondSectionHeight: secondSectionHeight ?? this.secondSectionHeight,
    );
  }
}
