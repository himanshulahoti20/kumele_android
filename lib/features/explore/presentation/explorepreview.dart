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
import 'package:kuemele/features/explore/domain/entities/explore_event_detail.dart';
import 'package:kuemele/features/explore/presentation/swipe_card/cubit/swipe_card_bloc.dart';
import 'package:kuemele/l10n/app_localizations.dart';
import 'package:kuemele/features/explore/presentation/swipe_card/widgets/swipe_card_expanded_skeleton.dart';
import 'package:kuemele/shared/components/app_button.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/icons.dart';
import 'package:kuemele/shared/modals/dialog/app_dialog.dart';
import 'package:kuemele/shared/widgets/app_rounded_icon_button.dart';
import 'package:kuemele/shared/widgets/swipe_card.dart';
import 'package:kuemele/features/explore/presentation/swipe_card/widgets/share_event_bottom_sheet.dart';

class ExplorePreview extends StatefulWidget {
  final String eventId;
  final bool showCancel;
  final String? primaryButtonLabel;
  final List<Widget>? footer;
  final bool showRating;

  const ExplorePreview({
    super.key,
    required this.eventId,
    this.showCancel = true,
    this.primaryButtonLabel,
    this.footer,
    this.showRating = false,
  });

  @override
  State<ExplorePreview> createState() => _ExplorePreviewState();
}

class _ExplorePreviewState extends State<ExplorePreview> {
  final EventDetailCubit _eventDetailCubit = InjectionHelper.eventDetailCubit;
  final SwipeCardBloc _swipeCardBloc = InjectionHelper.swipeCardBloc;

  @override
  void initState() {
    super.initState();
    _eventDetailCubit.loadEventDetail(widget.eventId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EventDetailCubit, EventDetailState>(
      bloc: _eventDetailCubit,
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
          _eventDetailCubit.clearJoinSucceeded();
          return;
        }

        final joinError = state.joinErrorMessage;
        if (joinError != null) {
          InjectionHelper.snackBar.showError(joinError);
          _eventDetailCubit.clearJoinError();
        }
      },
      buildWhen: (previous, current) =>
          previous.status != current.status ||
          previous.detail != current.detail ||
          previous.errorMessage != current.errorMessage ||
          previous.isJoining != current.isJoining,
      builder: (context, detailState) {
        return BlocBuilder<SwipeCardBloc, SwipeCardState>(
          bloc: _swipeCardBloc,
          builder: (context, swipeCardState) {
            final footerWidgets = widget.footer ??
                [
                  if (widget.showCancel)
                    Expanded(
                      child: AppButton.outline(
                        onPressed: () => context.pop(),
                        label: AppLocalizations.of(context)!.cancel,
                      ),
                    ),
                  Expanded(
                    child: AppButton.primary(
                      isLoading: detailState.isJoining,
                      onPressed: detailState.detail == null
                          ? null
                          : () => _confirmJoin(detailState.detail!),
                      label: widget.primaryButtonLabel ??
                          AppLocalizations.of(context)!.exploreInterestedLabel,
                    ),
                  ),
                ];

            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                color: ColorSet.bg2Color,
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: AppRoundedIconButton(
                      assetPath: IconSet.closeIcon,
                      iconSize: 20,
                      semanticLabel: AppLocalizations.of(context)!.close,
                      onTap: () => context.pop(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Flexible(
                    child: _buildCardContent(
                      detailState: detailState,
                      isExpanded: swipeCardState.isExpanded,
                    ),
                  ),
                  const Gap(16),
                  Row(
                    spacing: 16,
                    children: footerWidgets,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCardContent({
    required EventDetailState detailState,
    required bool isExpanded,
  }) {
    return switch (detailState.status) {
      EventDetailStatus.initial ||
      EventDetailStatus.loading =>
        const SwipeCardExpandedSkeleton(),
      EventDetailStatus.failure => _ExplorePreviewError(
          message: detailState.errorMessage ??
              AppLocalizations.of(context)!.exploreEventDetailLoadFailed,
          onRetry: () => _eventDetailCubit.loadEventDetail(widget.eventId),
        ),
      EventDetailStatus.loaded when detailState.detail != null => SwipeCard(
          event: detailState.detail!.toItem(),
          onShareTap: () =>
              ShareEventBottomSheet.show(context, detailState.detail!.toItem()),
          onChangeExpand: () {
            _swipeCardBloc.add(const SwipeCardExpandToggled());
          },
          isExpanded: isExpanded,
          showRating: widget.showRating,
          showRelatedEvents: false,
        ),
      EventDetailStatus.loaded => const SwipeCardExpandedSkeleton(),
    };
  }

  void _confirmJoin(ExploreEventDetail detail) {
    AppDialog.joinEvent(
      context: context,
      width: AppDialogSize.widthFor(context),
      eventTitle: detail.title.isNotEmpty
          ? detail.title
          : ExploreEventDetail.emptyField,
      storeCreditBalance: _eventDetailCubit.state.storeCreditBalance,
      onConfirm: (useStoreCredit) =>
          _eventDetailCubit.joinEvent(useStoreCredit: useStoreCredit),
    );
  }
}

class _ExplorePreviewError extends StatelessWidget {
  const _ExplorePreviewError({
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
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
