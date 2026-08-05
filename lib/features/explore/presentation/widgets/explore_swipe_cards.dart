import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:kuemele/core/responsive/responsive.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/features/discover/presentation/discover_config.dart';
import 'package:kuemele/features/discover/presentation/event_matched_flow.dart';
import 'package:kuemele/features/explore/cubit/event_detail_cubit.dart';
import 'package:kuemele/features/explore/cubit/explore_cubit.dart';
import 'package:kuemele/features/explore/cubit/explore_state.dart';
import 'package:kuemele/features/explore/domain/entities/explore_event.dart';
import 'package:kuemele/features/explore/presentation/explore_config.dart';
import 'package:kuemele/features/explore/presentation/swipe_card/cubit/swipe_card_bloc.dart';
import 'package:kuemele/features/explore/presentation/swipe_card/swipe_card_layout.dart';
import 'package:kuemele/features/explore/presentation/swipe_card/widgets/swipe_card.dart';
import 'package:kuemele/features/explore/presentation/swipe_card/widgets/share_event_bottom_sheet.dart';
import 'package:kuemele/features/explore/presentation/widgets/explore_swipe_empty_state.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/modals/dialog/app_dialog.dart';

class ExploreSwipeCards extends StatefulWidget {
  const ExploreSwipeCards({
    super.key,
    required this.state,
    required this.responsive,
    required this.events,
  });

  final ExploreState state;
  final ResponsiveData responsive;
  final List<ExploreEventItem> events;

  @override
  State<ExploreSwipeCards> createState() => _ExploreSwipeCardsState();
}

class _ExploreSwipeCardsState extends State<ExploreSwipeCards> {
  final ExploreCubit _cubit = InjectionHelper.exploreCubit;
  final SwipeCardBloc _swipeCardBloc = InjectionHelper.swipeCardBloc;
  final EventDetailCubit _eventDetailCubit = InjectionHelper.eventDetailCubit;

  ExploreEvent? _pendingSwipeJoinEvent;

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
            cardsCount: widget.events.length,
            onEnd: _cubit.onAllCardsSwiped,
            onSwipe: _onSwipe,
            cardBuilder: (context, index, horizontalOffset, verticalOffset) {
              return _buildCard(index, swipeCardState);
            },
            numberOfCardsDisplayed:
                widget.events.length < 3 ? widget.events.length : 3,
          );
        },
      ),
    );
  }

  Widget _buildCard(int index, SwipeCardState swipeCardState) {
    final event = widget.events[index];
    final isCurrent = widget.state.currentCardIndex == index;
    final isNext = index == widget.state.currentCardIndex + 1 ||
        (widget.state.currentCardIndex == widget.events.length - 1 &&
            index == 0);
    final isExpanded = swipeCardState.isExpanded && isCurrent;

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

    if (direction.isCloseTo(CardSwiperDirection.left)) {
      final event = widget.state.events[previousIndex];
      final confirmed = await _confirmSwipeJoin(event);
      if (!confirmed) return false;

      _pendingSwipeJoinEvent = event;
      SmartDialog.showLoading(msg: 'Joining event...');
      try {
        await _eventDetailCubit.joinEventById(event.id);
      } finally {
        SmartDialog.dismiss();
      }
    }

    _cubit.onCardSwipe(currentIndex);
    if (currentIndex == null) {
      _cubit.onAllCardsSwiped();
    }
    return true;
  }

  Future<bool> _confirmSwipeJoin(ExploreEvent event) async {
    var confirmed = false;

    await AppDialog.joinEvent(
      context: context,
      width: AppDialogSize.widthFor(context),
      eventTitle: event.title,
      onConfirm: () => confirmed = true,
    );

    return confirmed;
  }

  void _onJoinStateChanged(BuildContext context, EventDetailState state) {
    if (state.joinSucceeded) {
      final pendingEvent = _pendingSwipeJoinEvent;
      final detail = state.detail;

      if (pendingEvent != null) {
        EventMatchedFlow.show(
          context,
          eventData: DiscoverConfig.matchedEvent(
            eventId: pendingEvent.id,
            guestCount: pendingEvent.spotsRemaining,
            title: pendingEvent.title,
            eventImagePath: pendingEvent.displayImageUrl,
            categoryIconPath: detail?.categoryIcon,
            attendees: [
              DiscoverMatchedAttendee(
                name: pendingEvent.hostName.isNotEmpty
                    ? pendingEvent.hostName
                    : '--',
                avatarPath: pendingEvent.hostAvatar ?? '',
                borderColor: ColorSet.specialYellowColor,
              ),
              DiscoverMatchedAttendee(
                name: InjectionHelper.profileCubit.userData?.fullname ?? '--',
                avatarPath:
                    InjectionHelper.profileCubit.userData?.profilePicture ?? '',
                borderColor: ColorSet.specialBlueColor,
              ),
            ],
          ),
        );
      } else if (detail != null) {
        EventMatchedFlow.show(
          context,
          eventData: DiscoverConfig.matchedEvent(
            eventId: detail.id,
            guestCount: detail.spotsRemaining,
            title: detail.title,
            eventImagePath: detail.primaryImageUrl,
            categoryIconPath: detail.categoryIcon,
            attendees: [
              DiscoverMatchedAttendee(
                name: detail.hostName.isNotEmpty ? detail.hostName : '--',
                avatarPath: detail.hostProfile.avatarUrl ?? '',
                borderColor: ColorSet.specialYellowColor,
              ),
              DiscoverMatchedAttendee(
                name: InjectionHelper.profileCubit.userData?.fullname ?? '--',
                avatarPath:
                    InjectionHelper.profileCubit.userData?.profilePicture ?? '',
                borderColor: ColorSet.specialBlueColor,
              ),
            ],
          ),
        );
      }

      _pendingSwipeJoinEvent = null;
      _eventDetailCubit.clearJoinSucceeded();
      return;
    }

    final joinError = state.joinErrorMessage;
    if (joinError != null) {
      InjectionHelper.snackBar.showError(joinError);
      _pendingSwipeJoinEvent = null;
      _eventDetailCubit.clearJoinError();
    }
  }
}
