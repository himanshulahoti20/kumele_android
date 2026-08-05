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

  Future<void> loadEvents({
    double? latitude,
    double? longitude,
    int limit = 10,
  }) async {
    safeEmit(
      state.copyWith(
        status: ExploreStatus.loading,
        clearError: true,
      ),
    );

    try {
      final page = await _repository.getEvents(limit: limit);
      // Real endpoint: recommendations (/api/v1/events/recommendations)
      // final page = await _repository.getRecommendations(
      //   latitude: latitude,
      //   longitude: longitude,
      //   limit: limit,
      // );

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
      safeEmit(
        state.copyWith(
          status: ExploreStatus.failure,
          errorMessage: e.error ?? 'Failed to load events.',
        ),
      );
    } catch (e) {
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
