import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kuemele/features/explore/cubit/event_detail_state.dart';
import 'package:kuemele/features/explore/domain/entities/event_guest_entity.dart';
import 'package:kuemele/features/explore/domain/entities/explore_event.dart';
import 'package:kuemele/features/explore/domain/repositories/explore_repository.dart';
import 'package:kuemele/shared/bloc/bloc_extension.dart';
import 'package:kuemele/shared/services/api_service/api_exception.dart';

export 'event_detail_state.dart';

class EventDetailCubit extends Cubit<EventDetailState> {
  EventDetailCubit({required ExploreRepository repository})
      : _repository = repository,
        super(const EventDetailState());

  final ExploreRepository _repository;

  Future<void> loadEventDetail(String eventId,
      {bool forceRefresh = false}) async {
    if (!forceRefresh && state.eventId == eventId && state.isLoaded) return;

    safeEmit(
      state.copyWith(
        status: EventDetailStatus.loading,
        eventId: eventId,
        isGuestsLoading: true,
        clearDetail: true,
        clearHostEvents: true,
        clearGuests: true,
        clearError: true,
        clearGuestsError: true,
      ),
    );

    try {
      final detailFuture = _repository.getEventById(eventId);
      final guestsFuture = _loadGuestsSafely(eventId);

      final detail = await detailFuture;
      final guests = await guestsFuture;

      if (state.eventId != eventId) return;

      final hostEvents = await _loadHostEvents(
        hostId: detail.hostProfile.id,
        excludeEventId: eventId,
      );

      if (state.eventId != eventId) return;

      safeEmit(
        state.copyWith(
          status: EventDetailStatus.loaded,
          eventId: eventId,
          detail: detail,
          guests: guests,
          isGuestsLoading: false,
          hostEvents: hostEvents,
          clearError: true,
        ),
      );
    } on ApiException catch (error) {
      if (state.eventId != eventId) return;

      safeEmit(
        state.copyWith(
          status: EventDetailStatus.failure,
          eventId: eventId,
          isGuestsLoading: false,
          errorMessage: error.error ?? 'Failed to load event details.',
          clearDetail: true,
          clearHostEvents: true,
          clearGuests: true,
        ),
      );
    } catch (error) {
      if (state.eventId != eventId) return;

      safeEmit(
        state.copyWith(
          status: EventDetailStatus.failure,
          eventId: eventId,
          isGuestsLoading: false,
          errorMessage: error.toString(),
          clearDetail: true,
          clearHostEvents: true,
          clearGuests: true,
        ),
      );
    }
  }

  Future<List<EventGuestEntity>> _loadGuestsSafely(String eventId) async {
    try {
      return await _repository.getEventGuests(eventId);
    } catch (_) {
      return const [];
    }
  }

  Future<List<ExploreEvent>> _loadHostEvents({
    required String hostId,
    required String excludeEventId,
  }) async {
    if (hostId.isEmpty) return const [];

    try {
      final page = await _repository.getEventsByHostId(hostId);
      return page.events.where((event) => event.id != excludeEventId).toList();
    } catch (_) {
      return const [];
    }
  }

  void reset() {
    safeEmit(const EventDetailState());
  }

  Future<void> joinEventById(String eventId) async {
    if (eventId.isEmpty || state.isJoining) return;

    safeEmit(state.copyWith(eventId: eventId));
    await joinEvent();
  }

  Future<void> joinEvent() async {
    final eventId = state.eventId;
    if (eventId == null || eventId.isEmpty || state.isJoining) return;

    safeEmit(
      state.copyWith(
        isJoining: true,
        clearJoinError: true,
        clearJoinSucceeded: true,
      ),
    );

    try {
      await _repository.joinEvent(eventId);
      if (isClosed || state.eventId != eventId) return;

      safeEmit(
        state.copyWith(
          isJoining: false,
          joinSucceeded: true,
        ),
      );
    } on ApiException catch (error) {
      if (isClosed || state.eventId != eventId) return;

      safeEmit(
        state.copyWith(
          isJoining: false,
          joinErrorMessage: error.error ?? 'Failed to join event.',
        ),
      );
    } catch (error) {
      if (isClosed || state.eventId != eventId) return;

      safeEmit(
        state.copyWith(
          isJoining: false,
          joinErrorMessage: error.toString(),
        ),
      );
    }
  }

  void clearJoinSucceeded() {
    safeEmit(state.copyWith(clearJoinSucceeded: true));
  }

  void clearJoinError() {
    safeEmit(state.copyWith(clearJoinError: true));
  }
}
