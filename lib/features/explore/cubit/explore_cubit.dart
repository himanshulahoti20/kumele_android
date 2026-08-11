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

  Future<void> loadEvents({
    double? latitude,
    double? longitude,
    double? radius,
    String? city,
    String? country,
    int limit = 10,
    EventSearchFilters? filters,
  }) async {
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
      );
      final recommendations = await _loadRecommendations(
        latitude: latitude,
        longitude: longitude,
        radius: radius,
        city: city,
        limit: limit,
      );
      final createdEvents = await _loadCreatedEvents(limit: limit);
      final feedAd = await _loadFeedAd(city: city, country: country);
      await _refreshUnreadChatBadge([
        ...page.events,
        ...recommendations.events,
        ...createdEvents.events,
      ]);

      if (requestId != _loadRequestId) return;
      safeEmit(
        state.copyWith(
          status: ExploreStatus.loaded,
          events: page.events,
          recommendedEvents: recommendations.events,
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

  Future<AdItem?> _loadFeedAd({String? city, String? country}) async {
    if (!ApiService.hasToken()) return null;
    try {
      final response = await AdsRepo.fetchAds(
        placement: 'FEED',
        locationKey: AdsRepo.locationKeyFrom(city: city, country: country),
      );
      return response?.ads.firstOrNull;
    } catch (_) {
      return null;
    }
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
