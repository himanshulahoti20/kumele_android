import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/features/chat/domain/repositories/chat_room_repository.dart';
import 'package:kuemele/features/explore/cubit/explore_state.dart';
import 'package:kuemele/features/explore/domain/entities/explore_event.dart';
import 'package:kuemele/features/explore/domain/entities/explore_events_page.dart';
import 'package:kuemele/features/explore/domain/repositories/explore_repository.dart';
import 'package:kuemele/features/home/cubit/home_page_cubit.dart';
import 'package:kuemele/features/home/cubit/event_search_filters.dart';
import 'package:kuemele/features/profile/cubit/profile_cubit.dart';
import 'package:kuemele/shared/bloc/bloc_extension.dart';
import 'package:kuemele/shared/models/ads.dart';
import 'package:kuemele/shared/services/api_service/api_exception.dart';
import 'package:kuemele/shared/services/api_service/api_service.dart';
import 'package:kuemele/shared/services/api_service/ads/ads_repo.dart';

class ExploreCubit extends Cubit<ExploreState> {
  ExploreCubit({required ExploreRepository repository})
      : _repository = repository,
        super(const ExploreState());

  final ExploreRepository _repository;
  int _loadRequestId = 0;

  // Cached from the last loadEvents() call so selectCategory() can re-fire
  // with the same location context plus the newly chosen hobby filter,
  // without every caller of loadEvents needing to know about categories.
  double? _lastLatitude;
  double? _lastLongitude;
  double? _lastRadius;
  String? _lastCity;
  String? _lastCountry;
  int _lastLimit = 10;
  bool _lastIsRealLocation = true;

  Future<void> loadEvents({
    double? latitude,
    double? longitude,
    double? radius,
    String? city,
    String? country,
    int limit = 10,
    EventSearchFilters? filters,
    String? hobby,
    // False when the coordinates are the hardcoded fallback — `/match/events`
    // is then skipped, since matches for the wrong place are worse than none.
    bool isRealLocation = true,
  }) async {
    _lastLatitude = latitude;
    _lastLongitude = longitude;
    _lastRadius = radius;
    _lastCity = city;
    _lastCountry = country;
    _lastLimit = limit;
    _lastIsRealLocation = isRealLocation;
    if (state.categories.isEmpty && !state.isCategoriesLoading) {
      unawaited(_loadCategories());
    }

    final requestId = ++_loadRequestId;
    safeEmit(
      state.copyWith(
        status: ExploreStatus.loading,
        clearError: true,
      ),
    );

    try {
      final page = await _repository.getEvents(
        limit: limit,
        latitude: latitude,
        longitude: longitude,
        radius: radius,
        city: city,
        hobby: hobby,
      );
      final recommendations = isRealLocation
          ? await _loadRecommendations(
              latitude: latitude,
              longitude: longitude,
              radius: radius,
              city: city,
              limit: limit,
            )
          : null;
      final createdEvents = await _loadCreatedEvents(limit: limit);
      final feedAd = await _loadInlineFeedAd(city: city, country: country);
      await _refreshUnreadChatBadge([
        ...page.events,
        ...?recommendations?.events,
        ...createdEvents.events,
      ]);

      if (requestId != _loadRequestId) return;
      safeEmit(
        state.copyWith(
          status: ExploreStatus.loaded,
          events: page.events,
          recommendedEvents:
              recommendations?.events ?? state.recommendedEvents,
          createdEvents: createdEvents.events,
          feedAd: feedAd,
          cursor: page.cursor,
          hasNext: page.hasNext,
          currentCardIndex: 0,
          hasSwipedAllCards: false,
          activeFilters: filters,
          clearActiveFilters: filters == null,
        ),
      );
    } on ApiException catch (e) {
      if (requestId != _loadRequestId) return;
      safeEmit(
        state.copyWith(
          status: ExploreStatus.failure,
          errorMessage: e.error ?? 'Failed to load events.',
        ),
      );
    } catch (e) {
      if (requestId != _loadRequestId) return;
      safeEmit(
        state.copyWith(
          status: ExploreStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<ExploreEventsPage> _loadRecommendations({
    double? latitude,
    double? longitude,
    double? radius,
    String? city,
    int limit = 10,
  }) async {
    try {
      return await _repository.getRecommendations(
        latitude: latitude,
        longitude: longitude,
        radius: radius,
        city: city,
        limit: limit,
      );
    } catch (_) {
      return ExploreEventsPage(events: const [], limit: limit);
    }
  }

  Future<ExploreEventsPage> _loadCreatedEvents({int limit = 10}) async {
    if (!getIt.isRegistered<ProfileCubit>()) {
      return ExploreEventsPage(events: const [], limit: limit);
    }
    final userId = InjectionHelper.profileCubit.userData?.id;
    if (userId == null || userId.isEmpty) {
      return ExploreEventsPage(events: const [], limit: limit);
    }
    try {
      return await _repository.getEventsByHostId(userId, limit: limit);
    } catch (_) {
      return ExploreEventsPage(events: const [], limit: limit);
    }
  }

  /// Single ad interleaved into the "hobby events" feed at the 3rd card —
  /// `GET /ads/fetch?placement=EVENT_DECISION&limit=1`, matching HomeView_iPad's
  /// `loadAllEvents`. Only ever reached after the event list itself loaded
  /// successfully, since a failed `getEvents()` above throws before this
  /// point runs.
  Future<AdItem?> _loadInlineFeedAd({String? city, String? country}) async {
    if (!ApiService.hasToken()) return null;
    try {
      final hobbyContext =
          await InjectionHelper.profileCubit.loadHobbyContext();
      final response = await AdsRepo.fetchAds(
        placement: 'EVENT_DECISION',
        locationKey: AdsRepo.locationKeyFrom(city: city, country: country),
        hobbyContext: hobbyContext,
        limit: 1,
      );
      return response?.ads.firstOrNull;
    } catch (_) {
      return null;
    }
  }

  /// Right-column ad rails (top + bottom) — matches HomeView_iPad's
  /// `loadHomePanelAds`: tries placements in order, stopping at the first
  /// one that returns any ad with a thumbnail (a renderable `mediaUrl`),
  /// not just the first placement that returns *something*.
  ///
  /// Deliberately NOT part of [loadEvents]: iOS runs this as its own
  /// cancellable task, triggered only on appear / location resolving /
  /// entitlement changes — not on every GPS tick or filter change, which
  /// is what chaining it into the event load turned into a flood of
  /// `/ads/fetch` calls (each placement can cost 1 + 24 top-up requests).
  static const _homePanelAdPlacements = ['EVENT_DECISION', 'NOTIFICATIONS'];
  int _panelAdsRequestId = 0;

  Future<void> loadHomePanelAds({String? city, String? country}) async {
    // Newer call wins, like iOS's `homePanelAdsTask?.cancel()`: a stale run
    // stops iterating placements and never emits.
    final requestId = ++_panelAdsRequestId;
    if (!ApiService.hasToken()) return;
    final hobbyContext = await InjectionHelper.profileCubit.loadHobbyContext();
    if (requestId != _panelAdsRequestId) return;
    final locationKey = AdsRepo.locationKeyFrom(city: city, country: country);

    for (final placement in _homePanelAdPlacements) {
      try {
        final response = await AdsRepo.fetchAds(
          placement: placement,
          locationKey: locationKey,
          hobbyContext: hobbyContext,
          limit: 12,
        );
        if (requestId != _panelAdsRequestId) return;
        final visibleAds = (response?.ads ?? const <AdItem>[])
            .where((ad) => ad.mediaUrl?.isNotEmpty == true)
            .toList();
        if (visibleAds.isEmpty) continue;
        safeEmit(state.copyWith(
          feedAds: visibleAds,
          feedAdsPlacement: placement,
        ));
        return;
      } catch (_) {
        if (requestId != _panelAdsRequestId) return;
      }
    }
  }

  Future<void> _loadCategories() async {
    safeEmit(state.copyWith(isCategoriesLoading: true));
    try {
      final categories = await InjectionHelper.hobbiesRepository.getHobbyCategories();
      safeEmit(
        state.copyWith(categories: categories, isCategoriesLoading: false),
      );
    } catch (_) {
      safeEmit(state.copyWith(isCategoriesLoading: false));
    }
  }

  /// [index] 0 is the synthetic "All" chip; 1..n map to `state.categories`
  /// — same indexing `BlogCategoryFilterBar` uses.
  void selectCategory(int index) {
    if (index == state.selectedCategoryIndex) return;
    String? hobby;
    if (index > 0 && index - 1 < state.categories.length) {
      final category = state.categories[index - 1];
      hobby = category.slug.isNotEmpty ? category.slug : category.name;
    }
    safeEmit(state.copyWith(selectedCategoryIndex: index));
    loadEvents(
      latitude: _lastLatitude,
      longitude: _lastLongitude,
      radius: _lastRadius,
      city: _lastCity,
      country: _lastCountry,
      limit: _lastLimit,
      hobby: hobby,
      isRealLocation: _lastIsRealLocation,
    );
  }

  Future<void> _refreshUnreadChatBadge(List<ExploreEvent> events) async {
    if (!getIt.isRegistered<HomePageCubit>()) return;
    if (!ApiService.hasToken()) {
      InjectionHelper.homePageCubit.setUnreadChats(0);
      return;
    }
    final ids = events
        .map((event) => event.id.toString())
        .where((id) => id.isNotEmpty)
        .toSet()
        .toList()
      ..sort();

    for (final eventId in ids) {
      try {
        final status = await getIt<ChatRoomRepository>().getChatStatus(eventId);
        if (status.messageCount > 0) {
          InjectionHelper.homePageCubit.setUnreadChats(1);
          return;
        }
      } catch (_) {}
    }
    InjectionHelper.homePageCubit.setUnreadChats(0);
  }

  void setFocusSearch(bool value) {
    safeEmit(state.copyWith(focusSearch: value));
  }

  void setSearchQuery(String value) {
    safeEmit(
      state.copyWith(
        searchQuery: value,
        currentCardIndex: 0,
        hasSwipedAllCards: false,
      ),
    );
  }

  void toggleMatchedEventsViewAll() {
    final showAll = !state.showAllMatchedEvents;
    safeEmit(
      state.copyWith(
        showAllMatchedEvents: showAll,
        showCreatedEventSection: !showAll,
      ),
    );
  }

  void toggleCreatedEventsViewAll() {
    safeEmit(state.copyWith(showAllCreatedEvents: !state.showAllCreatedEvents));
  }

  void onCardSwipe(int? index) {
    safeEmit(state.copyWith(currentCardIndex: index ?? 0));
  }

  void onAllCardsSwiped() {
    if (state.hasSwipedAllCards) return;
    safeEmit(state.copyWith(hasSwipedAllCards: true));
  }

  void updateEventInLocationHeight(double height) {
    if (state.eventInLocationHeight == height) return;
    safeEmit(state.copyWith(eventInLocationHeight: height));
  }

  void updateSecondSectionHeight(double height) {
    if (state.secondSectionHeight == height) return;
    safeEmit(state.copyWith(secondSectionHeight: height));
  }
}
