import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kuemele/features/explore/cubit/event_detail_state.dart';
import 'package:kuemele/features/explore/domain/entities/explore_event.dart';
import 'package:kuemele/features/explore/domain/repositories/explore_repository.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/shared/bloc/bloc_extension.dart';
import 'package:kuemele/shared/models/web3_models.dart';
import 'package:kuemele/shared/services/api_service/api_exception.dart';
import 'package:kuemele/shared/services/api_service/aiml/aiml_repo.dart';
import 'package:kuemele/shared/services/api_service/events/events_repo.dart';
import 'package:kuemele/shared/services/api_service/web3/web3_repo.dart';
import 'package:kuemele/shared/services/payment/checkout_flow.dart';

export 'event_detail_state.dart';

class EventDetailCubit extends Cubit<EventDetailState> {
  EventDetailCubit({required ExploreRepository repository})
      : _repository = repository,
        super(const EventDetailState());

  final ExploreRepository _repository;

  Future<void> loadEventDetail(
    String eventId, {
    bool forceRefresh = false,
    bool includeCompanions = true,
  }) async {
    final hasDetail =
        !forceRefresh && state.eventId == eventId && state.detail != null;
    if (hasDetail && (!includeCompanions || state.companionsLoaded)) return;

    safeEmit(
      state.copyWith(
        status: EventDetailStatus.loading,
        eventId: eventId,
        isGuestsLoading: false,
        clearDetail: !hasDetail,
        clearHostEvents: !hasDetail,
        clearGuests: true,
        clearError: true,
        clearGuestsError: true,
        companionsLoaded: false,
      ),
    );

    try {
      final detail =
          hasDetail ? state.detail! : await _repository.getEventById(eventId);

      if (state.eventId != eventId) return;

      final hostEvents = includeCompanions
          ? await _loadExpandedCompanions(eventId, detail.hostProfile.id)
          : const <ExploreEvent>[];

      if (state.eventId != eventId) return;

      final storeCreditBalance =
          detail.isPaid ? await _loadStoreCreditBalance() : null;

      if (state.eventId != eventId) return;

      safeEmit(
        state.copyWith(
          status: EventDetailStatus.loaded,
          eventId: eventId,
          detail: detail,
          isGuestsLoading: false,
          hostEvents: hostEvents,
          companionsLoaded: includeCompanions,
          clearError: true,
          storeCreditBalance: storeCreditBalance,
          clearStoreCreditBalance: storeCreditBalance == null,
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

  Future<List<ExploreEvent>> _loadExpandedCompanions(
    String eventId,
    String hostId,
  ) async {
    await Future.wait([
      _loadRatingsSummary(eventId),
      _loadRatings(eventId),
      if (hostId.isNotEmpty) _loadHostProfile(hostId),
      _loadTranslation(eventId),
    ]);
    return _loadHostEvents(hostId: hostId, excludeEventId: eventId);
  }

  Future<void> _loadRatingsSummary(String eventId) async {
    try {
      await EventsRepo.getEventRatingsSummary(eventId);
    } catch (_) {}
  }

  Future<void> _loadRatings(String eventId) async {
    try {
      await EventsRepo.getEventRatings(eventId: eventId);
    } catch (_) {}
  }

  Future<void> _loadHostProfile(String hostId) async {
    try {
      await _repository.getHostProfile(hostId);
    } catch (_) {}
  }

  Future<void> _loadTranslation(String eventId) async {
    final language = InjectionHelper.profileCubit.userData?.language;
    if (language == null || language.isEmpty) return;
    try {
      await AimlRepo.getEventTranslation(
        eventId: eventId,
        language: language,
      );
    } catch (_) {}
  }

  Future<StoreCreditBalance?> _loadStoreCreditBalance() async {
    try {
      return await Web3Repo.getStoreCreditBalance();
    } catch (_) {
      return null;
    }
  }

  Future<List<ExploreEvent>> _loadHostEvents({
    required String hostId,
    required String excludeEventId,
  }) async {
    if (hostId.isEmpty) return const [];

    try {
      final page = await _repository.getEventsByHostId(hostId, limit: 10);
      return page.events.where((event) => event.id != excludeEventId).toList();
    } catch (_) {
      return const [];
    }
  }

  void reset() {
    safeEmit(const EventDetailState());
  }

  Future<void> joinEvent({bool useStoreCredit = false}) async {
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
      if (state.detail?.isPaid ?? false) {
        await _payForEventTicket(eventId, useStoreCredit: useStoreCredit);
      }
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

  /// Completes steps 2-4 of the guest ticket purchase sequence documented on
  /// `POST /payments/event`: create the payment intent, present Stripe (or
  /// fall back to PayPal), then confirm it — which flips the just-created
  /// RESERVED join to CONFIRMED, opens the escrow hold and issues the ticket.
  Future<void> _payForEventTicket(
    String eventId, {
    required bool useStoreCredit,
  }) async {
    final context = InjectionHelper.navKey.currentContext;
    if (context == null) throw Exception('Payment was not completed.');

    await CheckoutFlow.payStripeThenPayPal(
      context: context,
      createStripePayment: () => Web3Repo.createEventPayment(
        body: CreateEventPaymentRequest(
          eventId: eventId,
          useStoreCredit: useStoreCredit,
        ),
      ),
      createPayPalOrder: () => Web3Repo.createPayPalOrder(
        body: CreateEventPaymentRequest(
          eventId: eventId,
          useStoreCredit: useStoreCredit,
        ),
      ),
    );
  }

  void clearJoinSucceeded() {
    safeEmit(state.copyWith(clearJoinSucceeded: true));
  }

  void clearJoinError() {
    safeEmit(state.copyWith(clearJoinError: true));
  }
}
