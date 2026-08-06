import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kuemele/features/explore/cubit/explore_state.dart';
import 'package:kuemele/features/explore/domain/repositories/explore_repository.dart';
import 'package:kuemele/shared/bloc/bloc_extension.dart';
import 'package:kuemele/shared/services/api_service/api_exception.dart';

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
    int limit = 10,
  }) async {
    final requestId = ++_loadRequestId;
    safeEmit(
      state.copyWith(
        status: ExploreStatus.loading,
        clearError: true,
      ),
    );

    try {
      final page = latitude == null || longitude == null
          ? await _repository.getEvents(limit: limit)
          : await _repository.getRecommendations(
              latitude: latitude,
              longitude: longitude,
              radius: radius,
              limit: limit,
            );

      if (requestId != _loadRequestId) return;
      safeEmit(
        state.copyWith(
          status: ExploreStatus.loaded,
          events: page.events,
          cursor: page.cursor,
          hasNext: page.hasNext,
          currentCardIndex: 0,
          hasSwipedAllCards: false,
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
