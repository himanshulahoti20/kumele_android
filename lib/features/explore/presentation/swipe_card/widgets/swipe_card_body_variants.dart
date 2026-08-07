import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/core/responsive/responsive.dart';
import 'package:kuemele/features/explore/presentation/explore_config.dart';
import 'package:kuemele/features/explore/presentation/swipe_card/swipe_card_layout.dart';
import 'package:kuemele/features/explore/presentation/swipe_card/widgets/swipe_card_expand_button.dart';
import 'package:kuemele/features/explore/presentation/swipe_card/widgets/swipe_card_expanded_content.dart';
import 'package:kuemele/features/explore/presentation/swipe_card/widgets/swipe_card_info_row.dart';
import 'package:kuemele/features/explore/presentation/swipe_card/widgets/swipe_card_share_button.dart';
import 'package:kuemele/gen/assets.gen.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/widgets/kumele_asset_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:kuemele/features/explore/domain/entities/explore_event_detail.dart';
import 'package:kuemele/features/explore/domain/entities/explore_host_profile.dart';
import 'package:kuemele/features/explore/domain/entities/explore_location_details.dart';
import 'package:kuemele/features/explore/presentation/swipe_card/widgets/swipe_card_expanded_loaded_content.dart';
import 'package:kuemele/features/discover/cubit/create_event_cubit.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/features/profile/presentation/profile_config.dart';
import 'package:kuemele/l10n/app_localizations.dart';
import 'package:kuemele/l10n/app_localizations_en.dart';

class SwipeCardBodyPortrait extends StatelessWidget {
  const SwipeCardBodyPortrait({
    super.key,
    required this.event,
    this.createEventState,
    required this.backgroundColor,
    required this.isExpanded,
    required this.showRating,
    this.showRelatedEvents = true,
    required this.isPreview,
    this.onChangeExpand,
    this.onShareTap,
  });

  final ExploreEventItem event;
  final CreateEventState? createEventState;
  final Color backgroundColor;
  final bool isExpanded;
  final bool showRating;
  final bool showRelatedEvents;
  final bool isPreview;
  final VoidCallback? onChangeExpand;
  final VoidCallback? onShareTap;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final layout = SwipeCardLayout(responsive);

    return Container(
      width: double.infinity,
      color: backgroundColor,
      padding:
          isExpanded ? layout.expandedContentPadding : layout.contentPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TitleRow(
            title: event.title,
            layout: layout,
            onShareTap: onShareTap,
          ),
          Gap(layout.titleToInfoGap),
          SwipeCardInfoRow(
            layout: layout,
            price: event.price,
            time: event.time,
            guests: event.guests,
          ),
          Gap(8.h),
          _StartInRow(
            layout: layout,
            startInLabel: event.startInLabel,
          ),
          _LocationRow(
            layout: layout,
            location: event.location,
            isExpanded: isExpanded,
            onChangeExpand: onChangeExpand,
          ),
          if (isExpanded) ...[
            Gap(layout.expandedTopGap),
            if (isPreview && createEventState != null)
              SwipeCardExpandedLoadedContent(
                detail: _buildRealEventDetail(event, createEventState!),
                showRating: showRating,
                onJoin: () {},
                hostEvents: const [],
              )
            else if (event.id.isNotEmpty)
              SwipeCardExpandedContent(
                eventId: event.id,
                showRating: showRating,
                showRelatedEvents: showRelatedEvents,
              ),
          ],
        ],
      ),
    );
  }
}

class SwipeCardBodyLandscape extends StatelessWidget {
  const SwipeCardBodyLandscape({
    super.key,
    required this.event,
    this.createEventState,
    required this.backgroundColor,
    required this.isExpanded,
    required this.showRating,
    this.showRelatedEvents = true,
    required this.isPreview,
    this.onChangeExpand,
    this.onShareTap,
  });

  final ExploreEventItem event;
  final CreateEventState? createEventState;
  final Color backgroundColor;
  final bool isExpanded;
  final bool showRating;
  final bool showRelatedEvents;
  final bool isPreview;
  final VoidCallback? onChangeExpand;
  final VoidCallback? onShareTap;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final layout = SwipeCardLayout(responsive);

    return Container(
      width: double.infinity,
      color: backgroundColor,
      padding: isExpanded
          ? layout.expandedContentPadding
          : layout.landscapeContentPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TitleRow(
            title: event.title,
            layout: layout,
            onShareTap: onShareTap,
          ),
          Gap(responsive.h(10)),
          SwipeCardInfoRow(
            layout: layout,
            price: event.price,
            time: event.time,
            guests: event.guests,
            compact: true,
          ),
          Gap(responsive.h(6)),
          _StartInRow(
            layout: layout,
            startInLabel: event.startInLabel,
          ),
          Gap(responsive.h(4)),
          _LocationRow(
            layout: layout,
            location: event.location,
            isExpanded: isExpanded,
            onChangeExpand: onChangeExpand,
          ),
          if (isExpanded) ...[
            Gap(layout.expandedTopGap),
            if (isPreview && createEventState != null)
              SwipeCardExpandedLoadedContent(
                detail: _buildRealEventDetail(event, createEventState!),
                showRating: showRating,
                onJoin: () {},
                hostEvents: const [],
              )
            else if (event.id.isNotEmpty)
              SwipeCardExpandedContent(
                eventId: event.id,
                showRating: showRating,
                showRelatedEvents: showRelatedEvents,
              ),
          ],
        ],
      ),
    );
  }
}

class _TitleRow extends StatelessWidget {
  const _TitleRow({
    required this.title,
    required this.layout,
    this.onShareTap,
  });

  final String title;
  final SwipeCardLayout layout;
  final VoidCallback? onShareTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.heading2.copyWith(
              fontSize: layout.titleFontSize,
              color: ColorSet.textColor,
            ),
          ),
        ),
        SwipeCardShareButton(onShareTap: onShareTap),
      ],
    );
  }
}

class _StartInRow extends StatelessWidget {
  const _StartInRow({
    required this.layout,
    required this.startInLabel,
  });

  final SwipeCardLayout layout;
  final String startInLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Lottie.asset(
          Assets.iconsJson.clock.path,
          height: 20.w,
          width: 20.w,
          fit: BoxFit.contain,
        ),
        Gap(context.responsive.w(2)),
        Text(
          ExploreConfig.swipeCardStartInPrefix,
          style: context.textTheme.bodyLarge.copyWith(
            color: ColorSet.textColor,
          ),
        ),
        Gap(context.responsive.w(4)),
        Flexible(
          child: Text(
            startInLabel,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.bodyLarge.copyWith(
              color: ColorSet.textColor,
            ),
          ),
        ),
      ],
    );
  }
}

class _LocationRow extends StatelessWidget {
  const _LocationRow({
    required this.layout,
    required this.location,
    required this.isExpanded,
    this.onChangeExpand,
  });

  final SwipeCardLayout layout;
  final String location;
  final bool isExpanded;
  final VoidCallback? onChangeExpand;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        KumeleAssetWidget(
          assetPath: Assets.svg.iconLocation.path,
          height: 20.w,
          width: 20.w,
          color: ColorSet.textColor,
        ),
        Gap(context.responsive.w(1.2)),
        Expanded(
          child: Text(
            location,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.bodyLarge.copyWith(
              color: ColorSet.textColor,
            ),
          ),
        ),
        SwipeCardExpandButton(
          isExpanded: isExpanded,
          onTap: onChangeExpand,
        ),
      ],
    );
  }
}

ExploreEventDetail _buildRealEventDetail(
    ExploreEventItem event, CreateEventState createEventState) {
  final category = createEventState.interests
      .firstWhere(
        (i) => i.isSelected,
        orElse: () => InterestsModel(title: AppLocalizationsEn().spirituality, isSelected: false),
      )
      .title;

  return ExploreEventDetail(
    id: event.id,
    title: createEventState.title,
    description: createEventState.description,
    hostProfile: ExploreHostProfile(
      id: 'host_preview',
      displayName: InjectionHelper.profileCubit.userData?.fullname ?? 'Me',
      avatarUrl: InjectionHelper.profileCubit.userData?.profilePicture,
      bio: InjectionHelper.profileCubit.userData?.aboutMe ?? '',
    ),
    locationDetails: ExploreLocationDetails(
      displayAddress: createEventState.selectedLocation?.displayAddress,
      venueName: createEventState.selectedLocation?.displayAddress,
      latitude: createEventState.selectedLocation?.latitude,
      longitude: createEventState.selectedLocation?.longitude,
    ),
    attendeeCount: 0,
    eventImages: [createEventState.eventImagePath ?? ''],
    startsAt: createEventState.selectedDate ?? DateTime.now(),
    capacity: createEventState.numberOfGuests,
    spotsRemaining: createEventState.numberOfGuests,
    isPaid: createEventState.isPaidEvent,
    price:
        createEventState.isPaidEvent ? createEventState.guestPaymentType : '0',
    currency: '\$',
    hobbyNames: [category],
    averageEventRating: 0.0,
    averageHostRating: 0.0,
    totalRatings: 0,
  );
}
