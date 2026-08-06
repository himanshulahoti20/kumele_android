import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/core/responsive/responsive.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/features/discover/cubit/create_event_cubit.dart';
import 'package:kuemele/features/explore/domain/entities/explore_event_detail.dart';
import 'package:kuemele/features/explore/domain/entities/explore_host_profile.dart';
import 'package:kuemele/features/explore/domain/entities/explore_location_details.dart';

import 'package:kuemele/features/explore/presentation/swipe_card/swipe_card_layout.dart';
import 'package:kuemele/features/explore/presentation/swipe_card/widgets/swipe_card_expand_button.dart';
import 'package:kuemele/features/explore/presentation/swipe_card/widgets/swipe_card_expanded_loaded_content.dart';
import 'package:kuemele/features/explore/presentation/swipe_card/widgets/swipe_card_info_chip.dart';

import 'package:kuemele/features/profile/presentation/profile_config.dart';
import 'package:kuemele/gen/assets.gen.dart';
import 'package:kuemele/shared/components/app_button.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/event_card/widgets/category_tag.dart';
import 'package:kuemele/shared/components/icons.dart';
import 'package:kuemele/shared/models/aiml_models.dart';
import 'package:kuemele/shared/widgets/app_rounded_icon_button.dart';
import 'package:kuemele/shared/widgets/kumele_asset_widget.dart';
import 'package:lottie/lottie.dart';

class CreateEventPreviewDialog extends StatefulWidget {
  final CreateEventState createEventState;
  final List<Widget>? footer;

  const CreateEventPreviewDialog({
    super.key,
    required this.createEventState,
    this.footer,
  });

  @override
  State<CreateEventPreviewDialog> createState() =>
      _CreateEventPreviewDialogState();
}

class _CreateEventPreviewDialogState extends State<CreateEventPreviewDialog> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final layout = SwipeCardLayout(responsive);
    final createEventState = widget.createEventState;

    final footerWidgets = widget.footer ??
        [
          Expanded(
            child: AppButton.primary(
              fullWidth: true,
              onPressed: () => context.pop(),
              label: 'Create Event',
            ),
          ),
        ];

    final selectedCategory = createEventState.interests.firstWhere(
      (i) => i.isSelected,
      orElse: () => InterestsModel(title: '', isSelected: false),
    );
    final category = selectedCategory.title;
    final imagePath = createEventState.eventImagePath ?? '';
    final title = createEventState.title;
    final subtitle = createEventState.subtitle;
    final location = createEventState.selectedLocation?.displayAddress ?? '';
    final price = createEventState.isPaidEvent
        ? createEventState.guestPaymentType
        : 'Free';
    final guests = '${createEventState.numberOfGuests} guests';

    // Format time range with AM/PM: "7:45 AM-9:30 PM"
    String timeLabel = '--';
    if (createEventState.selectedStartTime != null &&
        createEventState.selectedEndTime != null) {
      final start = createEventState.selectedStartTime!;
      final end = createEventState.selectedEndTime!;
      final startHour = start.hourOfPeriod;
      final startMin = start.minute.toString().padLeft(2, '0');
      final startPeriod = start.period == DayPeriod.am ? 'AM' : 'PM';
      final endHour = end.hourOfPeriod;
      final endMin = end.minute.toString().padLeft(2, '0');
      final endPeriod = end.period == DayPeriod.am ? 'AM' : 'PM';
      timeLabel =
          '$startHour:$startMin $startPeriod-$endHour:$endMin $endPeriod';
    }

    // "Starts in X days / hrs / mins"
    String startsInLabel = '--';
    if (createEventState.selectedDate != null &&
        createEventState.selectedStartTime != null) {
      final date = createEventState.selectedDate!;
      final time = createEventState.selectedStartTime!;
      final eventDateTime =
          DateTime(date.year, date.month, date.day, time.hour, time.minute);
      final diff = eventDateTime.difference(DateTime.now());
      if (diff.isNegative) {
        startsInLabel = 'Event has already started';
      } else if (diff.inDays > 1) {
        startsInLabel = 'Starts in ${diff.inDays} days';
      } else if (diff.inDays == 1) {
        startsInLabel = 'Starts tomorrow';
      } else if (diff.inHours > 0) {
        startsInLabel =
            'Starts in ${diff.inHours} ${diff.inHours == 1 ? "hour" : "hours"}';
      } else if (diff.inMinutes > 0) {
        startsInLabel =
            'Starts in ${diff.inMinutes} ${diff.inMinutes == 1 ? "minute" : "minutes"}';
      } else {
        startsInLabel = 'Starting now';
      }
    }

    // Build ExploreEventDetail for the expanded section
    final eventDetail = ExploreEventDetail(
      id: 'preview',
      title: title.isNotEmpty ? title : '--',
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
      eventImages: [imagePath],
      startsAt: createEventState.selectedDate ?? DateTime.now(),
      capacity: createEventState.numberOfGuests,
      spotsRemaining: createEventState.numberOfGuests,
      isPaid: createEventState.isPaidEvent,
      price: createEventState.isPaidEvent
          ? createEventState.guestPaymentType
          : '0',
      currency: '\$',
      hobbyNames: [category.isNotEmpty ? category : 'Spirituality'],
      averageEventRating: 0.0,
      averageHostRating: 0.0,
      totalRatings: 0,
    );

    final isPortrait = responsive.layout == ResponsiveLayout.mobilePortrait ||
        responsive.layout == ResponsiveLayout.tabletPortrait;

    // ── Card content ──────────────────────────────────────────────────────────
    Widget cardContent;
    if (isPortrait) {
      // Portrait: image on top, body below
      cardContent = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _PreviewHeroImage(imagePath: imagePath, category: category),
          AnimatedSize(
            duration: layout.animationDuration,
            alignment: Alignment.topCenter,
            child: _PreviewBody(
              layout: layout,
              title: title,
              subtitle: subtitle,
              price: price,
              timeLabel: timeLabel,
              guests: guests,
              startsInLabel: startsInLabel,
              location: location,
              isExpanded: _isExpanded,
              eventDetail: eventDetail,
              attendancePrediction: createEventState.attendancePrediction,
              pricingAdvice: createEventState.pricingAdvice,
              onChangeExpand: () => setState(() => _isExpanded = !_isExpanded),
            ),
          ),
        ],
      );
    } else {
      // Landscape: image left, body right
      final imageHeight = _isExpanded
          ? layout.landscapeImageHeight * 1.4
          : layout.landscapeImageHeight;
      cardContent = Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _PreviewHeroImage(
            imagePath: imagePath,
            category: category,
            width: layout.landscapeImageWidth,
            height: imageHeight,
            categoryLeft: layout.landscapeImageWidth - responsive.w(30),
            isLandscape: true,
          ),
          Expanded(
            child: AnimatedSize(
              duration: layout.animationDuration,
              alignment: Alignment.topCenter,
              child: _PreviewBody(
                layout: layout,
                title: title,
                subtitle: subtitle,
                price: price,
                timeLabel: timeLabel,
                guests: guests,
                startsInLabel: startsInLabel,
                location: location,
                isExpanded: _isExpanded,
                eventDetail: eventDetail,
                attendancePrediction: createEventState.attendancePrediction,
                pricingAdvice: createEventState.pricingAdvice,
                isLandscape: true,
                onChangeExpand: () =>
                    setState(() => _isExpanded = !_isExpanded),
              ),
            ),
          ),
        ],
      );
    }

    final card = ClipRRect(
      borderRadius: BorderRadius.circular(layout.borderRadius),
      child: Container(
        color: ColorSet.bg2Color,
        child: _isExpanded
            ? SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: cardContent,
              )
            : Padding(
                padding: EdgeInsets.only(bottom: layout.stackBottomInset),
                child: cardContent,
              ),
      ),
    );

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
              semanticLabel: 'Close',
              onTap: () => context.pop(),
            ),
          ),
          const Gap(12),
          Flexible(
            child: _isExpanded
                ? card
                : Align(alignment: Alignment.topCenter, child: card),
          ),
          const Gap(16),
          Row(
            spacing: 16,
            children: footerWidgets,
          ),
        ],
      ),
    );
  }
}

// ── Hero Image ────────────────────────────────────────────────────────────────

class _PreviewHeroImage extends StatelessWidget {
  const _PreviewHeroImage({
    required this.imagePath,
    required this.category,
    this.width,
    this.height,
    this.categoryLeft,
    this.isLandscape = false,
  });

  final String imagePath;
  final String category;
  final double? width;
  final double? height;
  final double? categoryLeft;
  final bool isLandscape;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final layout = SwipeCardLayout(responsive);
    final imageWidth = width ?? double.infinity;
    final imageHeight = height ?? layout.imageHeight;
    final tagLabel = category.isNotEmpty ? category : null;

    return SizedBox(
      width: imageWidth,
      height: imageHeight,
      child: Stack(
        fit: StackFit.expand,
        children: [
          _buildImage(imagePath, imageWidth, imageHeight),
          if (tagLabel != null)
            Positioned(
              top: layout.categoryTagTop,
              right: isLandscape ? null : layout.categoryTagRight,
              left: isLandscape ? categoryLeft : null,
              child: CategoryTag(
                label: tagLabel,
                size: isLandscape ? responsive.w(18) : 23.sp,
                fontSize: isLandscape ? responsive.sp(14) : null,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildImage(String path, double w, double h) {
    BoxFit fit = BoxFit.cover;
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return Image.network(path, width: w, height: h, fit: fit);
    }
    if (File(path).existsSync()) {
      return Image.file(File(path), width: w, height: h, fit: fit);
    }
    if (path.isNotEmpty) {
      return KumeleAssetWidget(assetPath: path, width: w, height: h, fit: fit);
    }
    return Container(color: ColorSet.bgColor);
  }
}

// ── Card Body ─────────────────────────────────────────────────────────────────

class _PreviewBody extends StatelessWidget {
  const _PreviewBody({
    required this.layout,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.timeLabel,
    required this.guests,
    required this.startsInLabel,
    required this.location,
    required this.isExpanded,
    required this.eventDetail,
    this.attendancePrediction,
    this.pricingAdvice,
    this.isLandscape = false,
    this.onChangeExpand,
  });

  final SwipeCardLayout layout;
  final String title;
  final String subtitle;
  final String price;
  final String timeLabel;
  final String guests;
  final String startsInLabel;
  final String location;
  final bool isExpanded;
  final ExploreEventDetail eventDetail;
  final AimlAttendancePrediction? attendancePrediction;
  final AimlPricingAdvice? pricingAdvice;
  final bool isLandscape;
  final VoidCallback? onChangeExpand;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Container(
      width: double.infinity,
      color: ColorSet.bg2Color,
      padding: isExpanded
          ? layout.expandedContentPadding
          : (isLandscape
              ? layout.landscapeContentPadding
              : layout.contentPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.isNotEmpty ? title : '--',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.heading2.copyWith(
              fontSize: layout.titleFontSize,
              color: ColorSet.textColor,
            ),
          ),
          Gap(isLandscape ? responsive.h(10) : layout.titleToInfoGap),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: SwipeCardInfoChip(
                  assetPath: Assets.svg.iconTicket.path,
                  label: price,
                  alignment: Alignment.centerLeft,
                  compact: isLandscape,
                ),
              ),
              Expanded(
                flex: 2,
                child: SwipeCardInfoChip(
                  assetPath: Assets.icons.clock.path,
                  label: timeLabel,
                  alignment: Alignment.centerLeft,
                  compact: isLandscape,
                ),
              ),
            ],
          ),
          Gap(isLandscape ? responsive.h(4) : 8.h),
          SwipeCardInfoChip(
            assetPath: Assets.icons.guests.path,
            label: guests,
            alignment: Alignment.centerLeft,
            compact: isLandscape,
          ),
          Gap(isLandscape ? responsive.h(6) : 8.h),
          Row(
            children: [
              Lottie.asset(
                Assets.iconsJson.clock.path,
                height: 20.w,
                width: 20.w,
                fit: BoxFit.contain,
              ),
              Gap(responsive.w(4)),
              Flexible(
                child: Text(
                  startsInLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.bodyLarge
                      .copyWith(color: ColorSet.textColor),
                ),
              ),
            ],
          ),
          Gap(8.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: responsive.h(2)),
                child: KumeleAssetWidget(
                  assetPath: Assets.svg.iconLocation.path,
                  height: 20.w,
                  width: 20.w,
                  color: ColorSet.textColor,
                ),
              ),
              Gap(responsive.w(1.2)),
              Expanded(
                child: Text(
                  location.isNotEmpty ? location : '--',
                  style: context.textTheme.bodyLarge
                      .copyWith(color: ColorSet.textColor),
                ),
              ),
              SwipeCardExpandButton(
                isExpanded: isExpanded,
                onTap: onChangeExpand,
              ),
            ],
          ),
          if (attendancePrediction != null || pricingAdvice != null) ...[
            Gap(8.h),
            _AimlAdviceLine(
              attendancePrediction: attendancePrediction,
              pricingAdvice: pricingAdvice,
            ),
          ],
          if (isExpanded) ...[
            Gap(layout.expandedTopGap),
            if (subtitle.isNotEmpty) ...[
              Text(
                subtitle,
                style: context.textTheme.bodyLarge.copyWith(
                  color: ColorSet.subTextColor,
                ),
              ),
              Gap(layout.expandedSectionGapSmall),
            ],
            SwipeCardExpandedLoadedContent(
              detail: eventDetail,
              showRating: false,
              onJoin: () {},
              hostEvents: const [],
            ),
          ],
        ],
      ),
    );
  }
}

class _AimlAdviceLine extends StatelessWidget {
  const _AimlAdviceLine({
    this.attendancePrediction,
    this.pricingAdvice,
  });

  final AimlAttendancePrediction? attendancePrediction;
  final AimlPricingAdvice? pricingAdvice;

  @override
  Widget build(BuildContext context) {
    final pieces = [
      if (attendancePrediction != null)
        'Expected ${attendancePrediction!.label}',
      if (pricingAdvice != null && pricingAdvice!.optimalTier.isNotEmpty)
        'Pricing ${pricingAdvice!.label}',
    ];
    if (pieces.isEmpty) return const SizedBox.shrink();

    return Text(
      pieces.join(' • '),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: context.textTheme.bodyLarge.copyWith(
        color: ColorSet.subTextColor,
        fontSize: 12.sp,
      ),
    );
  }
}
