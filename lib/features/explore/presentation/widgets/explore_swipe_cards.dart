import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:kuemele/core/responsive/responsive.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/features/discover/presentation/discover_config.dart';
import 'package:kuemele/features/discover/presentation/event_matched_flow.dart';
import 'package:kuemele/features/explore/cubit/event_detail_cubit.dart';
import 'package:kuemele/features/explore/cubit/explore_cubit.dart';
import 'package:kuemele/features/explore/cubit/explore_state.dart';
import 'package:kuemele/features/explore/presentation/explore_config.dart';
import 'package:kuemele/features/explore/presentation/swipe_card/cubit/swipe_card_bloc.dart';
import 'package:kuemele/features/explore/presentation/swipe_card/swipe_card_layout.dart';
import 'package:kuemele/features/explore/presentation/swipe_card/widgets/swipe_card.dart';
import 'package:kuemele/features/explore/presentation/swipe_card/widgets/share_event_bottom_sheet.dart';
import 'package:kuemele/features/explore/presentation/widgets/explore_swipe_empty_state.dart';
import 'package:kuemele/features/explore/presentation/widgets/ad_swipe_card.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/models/ads.dart';
import 'package:kuemele/shared/services/api_service/ads/ads_repo.dart';

class ExploreSwipeCards extends StatefulWidget {
  const ExploreSwipeCards({
    super.key,
    required this.state,
    required this.responsive,
    required this.events,
    this.ad,
  });

  final ExploreState state;
  final ResponsiveData responsive;
  final List<ExploreEventItem> events;

  /// Advert interleaved into the deck after every third event (as on iOS).
  final AdItem? ad;

  @override
  State<ExploreSwipeCards> createState() => _ExploreSwipeCardsState();
}

class _ExploreSwipeCardsState extends State<ExploreSwipeCards> {
  final ExploreCubit _cubit = InjectionHelper.exploreCubit;
  final SwipeCardBloc _swipeCardBloc = InjectionHelper.swipeCardBloc;
  final EventDetailCubit _eventDetailCubit = InjectionHelper.eventDetailCubit;
  String? _prefetchedEventId;

  /// Events with the ad inserted after every 3rd one; each entry is an
  /// [ExploreEventItem] or the [AdItem]. Mirrors iOS `mergedHomeFeed`.
  List<Object> get _deck {
    final ad = widget.ad;
    if (ad == null || widget.events.isEmpty) return widget.events;
    final deck = <Object>[];
    var adPlaced = false;
    for (var i = 0; i < widget.events.length; i++) {
      deck.add(widget.events[i]);
      if ((i + 1) % 3 == 0 && !adPlaced) {
        deck.add(ad);
        adPlaced = true;
      }
    }
    return deck;
  }

  @override
  void initState() {
    super.initState();
    _prefetchCurrentCard();
  }

  @override
  void didUpdateWidget(covariant ExploreSwipeCards oldWidget) {
    super.didUpdateWidget(oldWidget);
    _prefetchCurrentCard();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.state.hasSwipedAllCards) {
      return const ExploreSwipeEmptyState();
    }

    final layout = SwipeCardLayout(widget.responsive);

    return BlocListener<EventDetailCubit, EventDetailState>(
      bloc: _eventDetailCubit,
      listenWhen: (previous, current) =>
          previous.joinSucceeded != current.joinSucceeded ||
          previous.joinErrorMessage != current.joinErrorMessage,
      listener: _onJoinStateChanged,
      child: BlocBuilder<SwipeCardBloc, SwipeCardState>(
        bloc: _swipeCardBloc,
        builder: (context, swipeCardState) {
          return CardSwiper(
            maxAngle: 10,
            threshold: 20,
            isLoop: false,
            allowedSwipeDirection: swipeCardState.isExpanded
                ? const AllowedSwipeDirection.none()
                : const AllowedSwipeDirection.symmetric(horizontal: true),
            padding: EdgeInsets.fromLTRB(
              0,
              layout.swiperTopPadding,
              0,
              swipeCardState.isExpanded
                  ? layout.swiperExpandedBottomPadding
                  : layout.swiperBottomPaddingCollapsed,
            ),
            backCardOffset: Offset(0, layout.stackBottomInset),
            cardsCount: _deck.length,
            onEnd: _cubit.onAllCardsSwiped,
            onSwipe: _onSwipe,
            cardBuilder: (context, index, horizontalOffset, verticalOffset) {
              return _buildCard(index, swipeCardState);
            },
            numberOfCardsDisplayed: _deck.length < 3 ? _deck.length : 3,
          );
        },
      ),
    );
  }

  Widget _buildCard(int index, SwipeCardState swipeCardState) {
    final deck = _deck;
    final item = deck[index];
    final isCurrent = widget.state.currentCardIndex == index;
    final isNext = index == widget.state.currentCardIndex + 1 ||
        (widget.state.currentCardIndex == deck.length - 1 && index == 0);
    final isExpanded = swipeCardState.isExpanded && isCurrent;
    if (item is AdItem) {
      return AdSwipeCard(
        ad: item,
        isExpanded: isExpanded,
        onToggleExpand: () => _swipeCardBloc.add(const SwipeCardExpandToggled()),
        bgColor: isCurrent
            ? null
            : isNext
                ? ColorSet.swipeCardNext
                : ColorSet.swipeCard,
      );
    }
    final event = item as ExploreEventItem;

    return SwipeCard(
      event: event,
      onShareTap: () => ShareEventBottomSheet.show(context, event),
      onChangeExpand: () {
        final willExpand = !swipeCardState.isExpanded;
        _swipeCardBloc.add(const SwipeCardExpandToggled());
        if (willExpand) {
          _eventDetailCubit.loadEventDetail(event.id);
        } else {
          _eventDetailCubit.reset();
        }
      },
      isExpanded: isExpanded,
      bgColor: isCurrent
          ? null
          : isNext
              ? ColorSet.swipeCardNext
              : ColorSet.swipeCard,
    );
  }

  Future<bool> _onSwipe(
    int previousIndex,
    int? currentIndex,
    CardSwiperDirection direction,
  ) async {
    _swipeCardBloc.add(const SwipeCardCollapsed());
    _eventDetailCubit.reset();

    // Swipe response on an ad card: right = positive, left = negative
    // (demo ads are never tracked). Best-effort, never blocks the swipe.
    final deck = _deck;
    if (previousIndex >= 0 && previousIndex < deck.length) {
      final swiped = deck[previousIndex];
      if (swiped is AdItem && !swiped.isDemo) {
        AdsRepo.trackAd(TrackAdRequest(
          adId: swiped.id,
          campaignId: swiped.campaignId,
          impressionId: swiped.impressionId,
          eventType: direction == CardSwiperDirection.right
              ? 'positive'
              : 'negative',
          placement: 'HOME',
        )).catchError((_) => false);
      }
    }

    _cubit.onCardSwipe(currentIndex);
    if (currentIndex == null) {
      _cubit.onAllCardsSwiped();
    }
    return true;
  }

  void _onJoinStateChanged(BuildContext context, EventDetailState state) {
    if (state.joinSucceeded) {
      final detail = state.detail;

      if (detail != null) {
        EventMatchedFlow.show(
          context,
          eventData: DiscoverConfig.matchedEvent(
            eventId: detail.id,
            guestCount: detail.spotsRemaining,
            title: detail.title,
            eventImagePath: detail.primaryImageUrl,
            categoryIconPath: detail.categoryIcon,
            attendees: DiscoverConfig.attendeesFor(
              detail: detail,
              guests: state.guests,
              currentUserName:
                  InjectionHelper.profileCubit.userData?.fullname ?? '',
              currentUserAvatar:
                  InjectionHelper.profileCubit.userData?.profilePicture ?? '',
            ),
          ),
        );
      }

      _eventDetailCubit.clearJoinSucceeded();
      return;
    }

    final joinError = state.joinErrorMessage;
    if (joinError != null) {
      InjectionHelper.snackBar.showError(joinError);
      _eventDetailCubit.clearJoinError();
    }
  }

  void _prefetchCurrentCard() {
    final deck = _deck;
    if (deck.isEmpty || widget.state.currentCardIndex >= deck.length) return;
    final current = deck[widget.state.currentCardIndex];
    if (current is! ExploreEventItem) return;
    final eventId = current.id;
    if (eventId.isEmpty || eventId == _prefetchedEventId) return;
    _prefetchedEventId = eventId;
    _eventDetailCubit.loadEventDetail(eventId, includeCompanions: false);
  }
}
