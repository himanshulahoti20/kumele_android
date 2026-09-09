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
import 'package:kuemele/shared/widgets/store_credit_toggle.dart';
import 'package:kuemele/shared/widgets/swipe_card.dart';
import 'package:kuemele/features/explore/presentation/swipe_card/widgets/share_event_bottom_sheet.dart';

class ExplorePreview extends StatefulWidget {
  final String eventId;
  final bool showCancel;
  final String? primaryButtonLabel;
  final List<Widget>? footer;
  final bool showRating;

  /// Matches iOS EventJoinView: always fully expanded (no collapse toggle),
  /// no Decline button — a discount-code field + store-credit toggle (when
  /// the event requires payment) sit above a single full-width "Join now"
  /// button that joins directly, skipping the separate confirm dialog
  /// [AppDialog.joinEvent] uses elsewhere.
  final bool isJoinFlow;

  const ExplorePreview({
    super.key,
    required this.eventId,
    this.showCancel = true,
    this.primaryButtonLabel,
    this.footer,
    this.showRating = false,
    this.isJoinFlow = false,
  });

  @override
  State<ExplorePreview> createState() => _ExplorePreviewState();
}

class _ExplorePreviewState extends State<ExplorePreview> {
  final EventDetailCubit _eventDetailCubit = InjectionHelper.eventDetailCubit;
  final SwipeCardBloc _swipeCardBloc = InjectionHelper.swipeCardBloc;
  final TextEditingController _discountController = TextEditingController();
  final ValueNotifier<bool> _useStoreCreditNotifier =
      ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _eventDetailCubit.loadEventDetail(widget.eventId);
  }

  @override
  void dispose() {
    _discountController.dispose();
    _useStoreCreditNotifier.dispose();
    super.dispose();
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
            final footerWidgets = widget.isJoinFlow
                ? [
                    Expanded(
                      child: AppButton.primary(
                        isLoading: detailState.isJoining,
                        onPressed: detailState.detail == null
                            ? null
                            : () => _handleJoinNow(),
                        label: detailState.isJoining ? 'Joining…' : 'Join now',
                      ),
                    ),
                  ]
                : widget.footer ??
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
                              AppLocalizations.of(context)!
                                  .exploreInterestedLabel,
                        ),
                      ),
                    ];

            final responsive = context.responsive;
            return Container(
              constraints: BoxConstraints(
                maxHeight: AppDialogSize.eventDetailMaxHeightFor(context),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  responsive.pick(mobilePortrait: 28, tabletPortrait: 36),
                ),
                color: ColorSet.bg2Color,
              ),
              padding: EdgeInsets.all(
                responsive.pick(mobilePortrait: 20.0, tabletPortrait: 32.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: AppRoundedIconButton(
                      assetPath: IconSet.closeIcon,
                      iconSize: responsive.pick(
                          mobilePortrait: 20, tabletPortrait: 24),
                      semanticLabel: AppLocalizations.of(context)!.close,
                      onTap: () => context.pop(),
                    ),
                  ),
                  SizedBox(
                    height: responsive.pick(
                        mobilePortrait: 12.0, tabletPortrait: 16.0),
                  ),
                  Flexible(
                    child: _buildCardContent(
                      detailState: detailState,
                      isExpanded:
                          widget.isJoinFlow || swipeCardState.isExpanded,
                    ),
                  ),
                  if (widget.isJoinFlow &&
                      (detailState.detail?.isPaid ?? false)) ...[
                    Gap(responsive.pick(
                        mobilePortrait: 12.0, tabletPortrait: 16.0)),
                    _buildJoinExtras(detailState),
                  ],
                  Gap(responsive.pick(
                      mobilePortrait: 16.0, tabletPortrait: 24.0)),
                  Row(
                    spacing: responsive.pick(
                        mobilePortrait: 16.0, tabletPortrait: 24.0),
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
          // This is a fixed-size modal, not the full-screen swipe feed — it
          // should never switch to the image-left "landscape" card layout
          // just because the device happens to be rotated.
          forcePortrait: true,
          // Tablet's event popup always shows the rating breakdown and the
          // host's other events (matches the tablet mockup); phone keeps
          // the compact version — showRating only when a caller opts in
          // (e.g. the rate-event flow), related events hidden entirely.
          // The join flow (iOS EventJoinView) never shows either, on any
          // platform — it's a quicker, join-focused screen.
          showRating: !widget.isJoinFlow &&
              (widget.showRating || context.responsive.isTablet),
          showRelatedEvents: !widget.isJoinFlow && context.responsive.isTablet,
          heroImageHeight: isExpanded
              ? null
              : MediaQuery.sizeOf(context).height *
                  context.responsive
                      .pick(mobilePortrait: 0.2, tabletPortrait: 0.28),
        ),
      EventDetailStatus.loaded => const SwipeCardExpandedSkeleton(),
    };
  }

  /// Discount code field + (when the account has store credit) the toggle
  /// to spend it — matches iOS EventJoinView's fixed section between the
  /// scrollable content and the "Join now" footer button.
  Widget _buildJoinExtras(EventDetailState detailState) {
    final storeCreditBalance = detailState.storeCreditBalance;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _discountController,
          decoration: InputDecoration(
            hintText: 'Discount code (optional)',
            hintStyle: context.textTheme.bodyLarge.copyWith(
              color: ColorSet.subTextColor,
              fontSize: 16,
            ),
            filled: true,
            fillColor: ColorSet.txtFieldFillColor,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        if (storeCreditBalance?.hasCredit == true) ...[
          const Gap(12),
          StoreCreditToggle(
            balance: storeCreditBalance!,
            notifier: _useStoreCreditNotifier,
          ),
        ],
      ],
    );
  }

  void _handleJoinNow() {
    _eventDetailCubit.joinEvent(
      useStoreCredit: _useStoreCreditNotifier.value,
      discountCode: _discountController.text.trim(),
    );
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
