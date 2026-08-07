import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/core/responsive/responsive.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/features/discover/presentation/discover_config.dart';
import 'package:kuemele/features/discover/presentation/event_matched_flow.dart';
import 'package:kuemele/features/explore/cubit/event_detail_cubit.dart';
import 'package:kuemele/features/explore/domain/entities/explore_event.dart';
import 'package:kuemele/features/explore/domain/entities/explore_event_detail.dart';
import 'package:kuemele/features/explore/presentation/explorepreview.dart';
import 'package:kuemele/features/explore/presentation/swipe_card/widgets/swipe_card_expanded_loaded_content.dart';
import 'package:kuemele/features/explore/presentation/swipe_card/widgets/swipe_card_expanded_skeleton.dart';
import 'package:kuemele/features/home/presentation/main_navigation_page.dart';
import 'package:kuemele/shared/components/app_button.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/modals/dialog/app_dialog.dart';
import 'package:kuemele/l10n/app_localizations.dart';

class SwipeCardExpandedContent extends StatelessWidget {
  const SwipeCardExpandedContent({
    super.key,
    required this.eventId,
    required this.showRating,
    this.showRelatedEvents = true,
  });

  final String eventId;
  final bool showRating;
  final bool showRelatedEvents;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EventDetailCubit, EventDetailState>(
      listenWhen: (previous, current) =>
          previous.joinSucceeded != current.joinSucceeded ||
          previous.joinErrorMessage != current.joinErrorMessage,
      listener: (context, state) {
        if (state.joinSucceeded && state.detail != null) {
          final detail = state.detail!;
          EventMatchedFlow.show(
            context,
            eventData: DiscoverConfig.matchedEvent(
              eventId: detail.id,
              guestCount: detail.spotsRemaining,
              title: detail.title,
              eventImagePath: detail.primaryImageUrl,
              categoryIconPath: detail.categoryIcon,
            ),
          );
          context.read<EventDetailCubit>().clearJoinSucceeded();
          return;
        }

        final joinError = state.joinErrorMessage;
        if (joinError != null) {
          InjectionHelper.snackBar.showError(joinError);
          context.read<EventDetailCubit>().clearJoinError();
        }
      },
      buildWhen: (previous, current) =>
          previous.status != current.status ||
          previous.eventId != current.eventId ||
          previous.detail != current.detail ||
          previous.hostEvents != current.hostEvents ||
          previous.isJoining != current.isJoining,
      builder: (context, state) {
        if (state.eventId != eventId) {
          return const SwipeCardExpandedSkeleton();
        }

        return switch (state.status) {
          EventDetailStatus.initial ||
          EventDetailStatus.loading =>
            const SwipeCardExpandedSkeleton(),
          EventDetailStatus.failure => _SwipeCardExpandedError(
              message: state.errorMessage ?? 'Failed to load event details.',
              onRetry: () =>
                  context.read<EventDetailCubit>().loadEventDetail(eventId),
            ),
          EventDetailStatus.loaded when state.detail != null =>
            SwipeCardExpandedLoadedContent(
              detail: state.detail!,
              showRating: showRating,
              isJoining: state.isJoining,
              hostEvents: showRelatedEvents
                  ? ExploreEvent.toItems(state.hostEvents)
                  : const [],
              onJoin: () => _confirmJoin(context, state.detail!),
              onHostEventTap: showRelatedEvents
                  ? (event) => _openRelatedEventPreview(context, event.id)
                  : null,
            ),
          EventDetailStatus.loaded => const SwipeCardExpandedSkeleton(),
        };
      },
    );
  }

  void _confirmJoin(BuildContext context, ExploreEventDetail detail) {
    AppDialog.joinEvent(
      context: context,
      width: AppDialogSize.widthFor(context),
      eventTitle: detail.title,
      onConfirm: () => context.read<EventDetailCubit>().joinEvent(),
    );
  }

  void _openRelatedEventPreview(BuildContext context, String eventId) {
    if (eventId.isEmpty) return;

    if (showRating) {
      if (context.canPop()) {
        context.pop();
      } else {
        InjectionHelper.homePageCubit.onTapTab(context, HomeTabType.home);
      }
    }

    AppDialog.show<void>(
      context: context,
      width: AppDialogSize.widthFor(context),
      dialog: ExplorePreview(
        eventId: eventId,
        showCancel: false,
        showRating: true,
        primaryButtonLabel: 'Join Now',
      ),
    );
  }
}

class _SwipeCardExpandedError extends StatelessWidget {
  const _SwipeCardExpandedError({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: responsive.h(24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message,
            style: context.textTheme.bodyLarge.copyWith(
              color: ColorSet.subTextColor,
            ),
          ),
          Gap(responsive.h(12)),
          AppButton.primary(
            label: AppLocalizations.of(context)!.retry,
            onPressed: onRetry,
          ),
        ],
      ),
    );
  }
}
