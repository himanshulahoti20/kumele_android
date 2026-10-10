import 'package:kuemele/features/explore/domain/entities/explore_event.dart';
import 'package:kuemele/features/home/cubit/event_search_filters.dart';
import 'package:kuemele/features/profile/presentation/profileset/data/models/hobby_category_model.dart';
import 'package:kuemele/shared/models/ads.dart';

enum ExploreStatus { initial, loading, loaded, failure }

class ExploreState {
  const ExploreState({
    this.status = ExploreStatus.initial,
    this.events = const [],
    this.recommendedEvents = const [],
    this.createdEvents = const [],
    this.feedAd,
    this.feedAds = const [],
    this.feedAdsPlacement = 'HOME',
    this.errorMessage,
    this.cursor,
    this.hasNext = false,
    this.showAllMatchedEvents = false,
    this.showAllCreatedEvents = false,
    this.showCreatedEventSection = true,
    this.focusSearch = false,
    this.searchQuery = '',
    this.activeFilters,
    this.currentCardIndex = 0,
    this.hasSwipedAllCards = false,
    this.eventInLocationHeight = 200,
    this.secondSectionHeight = 700,
    this.categories = const [],
    this.selectedCategoryIndex = 0,
    this.isCategoriesLoading = false,
  });

  final ExploreStatus status;
  final List<ExploreEvent> events;
  final List<ExploreEvent> recommendedEvents;
  final List<ExploreEvent> createdEvents;
  final AdItem? feedAd;
  final List<AdItem> feedAds;

  /// Which placement [feedAds] actually came from — HOME, NOTIFICATIONS or
  /// FEED, per the waterfall in `ExploreCubit._loadHomePanelAds`. Passed
  /// through to ad-tracking calls so impressions/clicks attribute to the
  /// real placement, not a hardcoded one.
  final String feedAdsPlacement;
  final String? errorMessage;
  final String? cursor;
  final bool hasNext;
  final bool showAllMatchedEvents;
  final bool showAllCreatedEvents;
  final bool showCreatedEventSection;
  final bool focusSearch;
  final String searchQuery;
  final EventSearchFilters? activeFilters;
  final int currentCardIndex;
  final bool hasSwipedAllCards;
  final double eventInLocationHeight;
  final double secondSectionHeight;

  /// Hobby chips shown above the event sections — real API data, same
  /// source/shape as the blog category filter bar. Index 0 is always the
  /// synthetic "All" chip; [selectedCategoryIndex] 0 means unfiltered.
  final List<HobbyCategoryModel> categories;
  final int selectedCategoryIndex;
  final bool isCategoriesLoading;

  bool get isLoading => status == ExploreStatus.loading;
  bool get hasError => status == ExploreStatus.failure;
  bool get hasEvents => events.isNotEmpty;
  List<ExploreEvent> get visibleEvents {
    final filteredEvents = filtered(events);
    final query = searchQuery.trim().toLowerCase();
    if (query.isEmpty) return filteredEvents;
    return filteredEvents.where((event) {
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

  List<ExploreEvent> get visibleRecommendedEvents =>
      filtered(recommendedEvents);
  List<ExploreEvent> get visibleCreatedEvents => filtered(createdEvents);
  List<ExploreEvent> get searchResults {
    final query = searchQuery.trim().toLowerCase();
    if (query.isEmpty) return const [];
    final seen = <String>{};
    return [
      ...events,
      ...recommendedEvents,
      ...createdEvents,
    ]
        .where((event) {
          if (!seen.add(event.id)) return false;
          return [
            event.title,
            event.hobbyKey,
            event.hostName,
            event.displayLocation,
          ].whereType<String>().any((value) {
            return value.toLowerCase().contains(query);
          });
        })
        .take(20)
        .toList();
  }

  List<ExploreEvent> filtered(List<ExploreEvent> source) {
    final filters = activeFilters;
    if (filters == null) return source;
    return source.where((event) {
      if (filters.paidOnly == true && !event.isPaid) return false;
      final minAge = event.minAge;
      final maxAge = event.maxAge;
      if (minAge != null && minAge < filters.minimumAge) return false;
      if (maxAge != null && maxAge > filters.maximumAge) return false;
      return true;
    }).toList();
  }

  ExploreState copyWith({
    ExploreStatus? status,
    List<ExploreEvent>? events,
    List<ExploreEvent>? recommendedEvents,
    List<ExploreEvent>? createdEvents,
    AdItem? feedAd,
    List<AdItem>? feedAds,
    String? feedAdsPlacement,
    String? errorMessage,
    String? cursor,
    bool? hasNext,
    bool? showAllMatchedEvents,
    bool? showAllCreatedEvents,
    bool? showCreatedEventSection,
    bool? focusSearch,
    String? searchQuery,
    EventSearchFilters? activeFilters,
    int? currentCardIndex,
    bool? hasSwipedAllCards,
    double? eventInLocationHeight,
    double? secondSectionHeight,
    List<HobbyCategoryModel>? categories,
    int? selectedCategoryIndex,
    bool? isCategoriesLoading,
    bool clearError = false,
    bool clearActiveFilters = false,
  }) {
    return ExploreState(
      status: status ?? this.status,
      events: events ?? this.events,
      recommendedEvents: recommendedEvents ?? this.recommendedEvents,
      createdEvents: createdEvents ?? this.createdEvents,
      feedAd: feedAd ?? this.feedAd,
      feedAds: feedAds ?? this.feedAds,
      feedAdsPlacement: feedAdsPlacement ?? this.feedAdsPlacement,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      cursor: cursor ?? this.cursor,
      hasNext: hasNext ?? this.hasNext,
      showAllMatchedEvents: showAllMatchedEvents ?? this.showAllMatchedEvents,
      showAllCreatedEvents: showAllCreatedEvents ?? this.showAllCreatedEvents,
      showCreatedEventSection:
          showCreatedEventSection ?? this.showCreatedEventSection,
      focusSearch: focusSearch ?? this.focusSearch,
      searchQuery: searchQuery ?? this.searchQuery,
      activeFilters:
          clearActiveFilters ? null : (activeFilters ?? this.activeFilters),
      currentCardIndex: currentCardIndex ?? this.currentCardIndex,
      hasSwipedAllCards: hasSwipedAllCards ?? this.hasSwipedAllCards,
      eventInLocationHeight:
          eventInLocationHeight ?? this.eventInLocationHeight,
      secondSectionHeight: secondSectionHeight ?? this.secondSectionHeight,
      categories: categories ?? this.categories,
      selectedCategoryIndex:
          selectedCategoryIndex ?? this.selectedCategoryIndex,
      isCategoriesLoading: isCategoriesLoading ?? this.isCategoriesLoading,
    );
  }
}
