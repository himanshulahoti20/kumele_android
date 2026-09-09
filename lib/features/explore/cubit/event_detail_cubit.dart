import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kuemele/features/explore/cubit/event_detail_state.dart';
import 'package:kuemele/features/explore/domain/entities/explore_event.dart';
import 'package:kuemele/features/explore/domain/entities/explore_host_profile.dart';
import 'package:kuemele/features/explore/domain/repositories/explore_repository.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/shared/bloc/bloc_extension.dart';
import 'package:kuemele/shared/components/rating.dart';
import 'package:kuemele/shared/models/event_review.dart';
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
      var detail =
          hasDetail ? state.detail! : await _repository.getEventById(eventId);

      if (state.eventId != eventId) return;

      List<ExploreEvent> hostEvents = const [];
      var ratingBreakdown = const <RatingType, double>{};
      var reviews = const <EventReview>[];
      if (includeCompanions) {
        final ExploreHostProfile? fullHostProfile;
        (hostEvents, fullHostProfile, ratingBreakdown, reviews) =
            await _loadExpandedCompanions(eventId, detail.hostProfile.id);
        if (fullHostProfile != null) {
          detail = detail.copyWith(
            hostProfile: detail.hostProfile.mergedWith(fullHostProfile),
          );
        }
      }

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
          ratingBreakdown: ratingBreakdown,
          reviews: reviews,
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

  Future<
      (
        List<ExploreEvent>,
        ExploreHostProfile?,
        Map<RatingType, double>,
        List<EventReview>
      )> _loadExpandedCompanions(
    String eventId,
    String hostId,
  ) async {
    final hostProfileFuture =
        hostId.isNotEmpty ? _loadHostProfile(hostId) : null;
    final ratingsSummaryFuture = _loadRatingsSummary(eventId);
    final ratingsFuture = _loadRatings(eventId);
    await Future.wait([
      ratingsSummaryFuture,
      ratingsFuture,
      _loadTranslation(eventId),
      if (hostProfileFuture != null) hostProfileFuture,
    ]);
    final hostEvents = await _loadHostEvents(
      hostId: hostId,
      excludeEventId: eventId,
    );
    final fullHostProfile = await hostProfileFuture;
    return (
      hostEvents,
      fullHostProfile,
      await ratingsSummaryFuture,
      await ratingsFuture,
    );
  }

  Future<Map<RatingType, double>> _loadRatingsSummary(String eventId) async {
    try {
      final summary = await EventsRepo.getEventRatingsSummary(eventId);
      return parseRatingBreakdown(summary);
    } catch (_) {
      return const {};
    }
  }

  Future<List<EventReview>> _loadRatings(String eventId) async {
    try {
      final ratings = await EventsRepo.getEventRatings(eventId: eventId);
      return ratings.map(EventReview.fromJson).toList();
    } catch (_) {
      return const [];
    }
  }

  Future<ExploreHostProfile?> _loadHostProfile(String hostId) async {
    try {
      return await _repository.getHostProfile(hostId);
    } catch (_) {
      return null;
    }
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

  Future<void> joinEvent({
    bool useStoreCredit = false,
    String? discountCode,
  }) async {
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
        await _payForEventTicket(
          eventId,
          useStoreCredit: useStoreCredit,
          discountCode: discountCode,
        );
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
    String? discountCode,
  }) async {
    final context = InjectionHelper.navKey.currentContext;
    if (context == null) throw Exception('Payment was not completed.');
    final trimmedCode = discountCode?.trim();
    final effectiveCode =
        trimmedCode != null && trimmedCode.isNotEmpty ? trimmedCode : null;

    await CheckoutFlow.payStripeThenPayPal(
      context: context,
      createStripePayment: () => Web3Repo.createEventPayment(
        body: CreateEventPaymentRequest(
          eventId: eventId,
          useStoreCredit: useStoreCredit,
          discountCode: effectiveCode,
        ),
      ),
      createPayPalOrder: () => Web3Repo.createPayPalOrder(
        body: CreateEventPaymentRequest(
          eventId: eventId,
          useStoreCredit: useStoreCredit,
          discountCode: effectiveCode,
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
