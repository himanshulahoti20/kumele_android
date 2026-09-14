import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/core/responsive/responsive.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/features/explore/cubit/explore_cubit.dart';
import 'package:kuemele/features/explore/cubit/explore_state.dart';
import 'package:kuemele/features/explore/domain/entities/explore_event.dart';
import 'package:kuemele/features/explore/presentation/explore_config.dart';
import 'package:kuemele/features/explore/presentation/explorepreview.dart';
import 'package:kuemele/features/explore/presentation/notification/widgets/ad_carousel_rail.dart';
import 'package:kuemele/features/explore/presentation/widgets/explore_event_grid_section.dart';
import 'package:kuemele/features/explore/presentation/widgets/explore_events_carousel.dart';
import 'package:kuemele/features/explore/presentation/widgets/explore_notifications_panel.dart';
import 'package:kuemele/features/explore/presentation/widgets/explore_phone_search_bar.dart';
import 'package:kuemele/features/explore/presentation/widgets/explore_search_with_dropdown.dart';
import 'package:kuemele/features/explore/presentation/widgets/explore_swipe_cards.dart';
import 'package:kuemele/features/explore/presentation/widgets/explore_swipe_empty_state.dart';
import 'package:kuemele/features/explore/presentation/widgets/explore_tablet_header.dart';
import 'package:kuemele/features/home/cubit/home_page_cubit.dart';
import 'package:kuemele/features/home/presentation/home_tab_type.dart';
import 'package:kuemele/gen/assets.gen.dart';
import 'package:kuemele/l10n/app_localizations.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/app_text_theme.dart';
import 'package:kuemele/shared/components/close_keyboard_widget.dart';
import 'package:kuemele/shared/cubit/location_cubit.dart';
import 'package:kuemele/shared/models/ads.dart';
import 'package:kuemele/shared/modals/dialog/app_dialog.dart';
import 'package:kuemele/shared/modals/dialog/invite_dialog.dart';
import 'package:kuemele/shared/modals/dialog/what_would_you_like_dialog.dart';
import 'package:kuemele/shared/utils/storage_util.dart';
import 'package:kuemele/shared/widgets/size_reporting_widget.dart';
import 'package:lottie/lottie.dart';

class Explore extends StatefulWidget {
  const Explore({super.key});

  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  static const _fallbackLatitude = 36.851725;
  static const _fallbackLongitude = 28.277519;
  static const _homeRadiusKm = 28.0;

  // Guards against re-triggering the async storage check below on every
  // Home revisit within the same app process — Explore rebuilds fresh each
  // time the user switches back to the Home tab. The actual "has this
  // already been shown" answer is persisted (StorageKey
  // .WHAT_WOULD_YOU_LIKE_SHOWN), not just this in-memory flag, so it
  // survives app restarts and only resets on logout.
  static bool _checkedWhatWouldYouLike = false;

  final ExploreCubit _cubit = InjectionHelper.exploreCubit;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    final locationState = InjectionHelper.locationCubit.state;
    if (locationState.status == LocationStatus.initial) {
      InjectionHelper.locationCubit.requestLocation();
    } else {
      _loadEventsFromLocation(locationState);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _maybeShowWhatWouldYouLike();
  }

  /// Tablet-only, matches iOS HomeView_iPad's `onAppear`: 0.5s after first
  /// Home load, show the rotating "what would you like to do today" prompt.
  /// MediaQuery.sizeOf needs an inherited-widget dependency, which can't be
  /// established in initState — didChangeDependencies is where Flutter
  /// expects this kind of one-time read to happen instead.
  void _maybeShowWhatWouldYouLike() {
    if (_checkedWhatWouldYouLike) return;
    if (MediaQuery.sizeOf(context).shortestSide < 600) return;
    _checkedWhatWouldYouLike = true;
    unawaited(_checkAndShowWhatWouldYouLike());
  }

  Future<void> _checkAndShowWhatWouldYouLike() async {
    final alreadyShown =
        await StorageUtil.retrieveItem(StorageKey.WHAT_WOULD_YOU_LIKE_SHOWN);
    if (alreadyShown == true) return;
    await StorageUtil.storeItem(StorageKey.WHAT_WOULD_YOU_LIKE_SHOWN, true);

    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    AppDialog.show(
      context: context,
      width: AppDialogSize.notificationModalWidthFor(context),
      dialog: WhatWouldYouLikeDialog(onAction: _handleWhatYouLikeAction),
    );
  }

  void _handleWhatYouLikeAction(WhatYouLikeAction action) {
    switch (action) {
      case WhatYouLikeAction.create:
        InjectionHelper.homePageCubit
            .onTapTab(context, HomeTabType.createEvent);
      case WhatYouLikeAction.inviteFriend:
        AppDialog.adaptive(
          context: context,
          width: AppDialogSize.widthFor(context),
          dialog: const InviteDialog(),
        );
      case WhatYouLikeAction.readBlog:
        InjectionHelper.homePageCubit.onTapTab(context, HomeTabType.blog);
    }
  }

  void _loadEventsFromLocation(LocationState locationState) {
    final filters = InjectionHelper.homePageCubit.state.eventFilters;
    if (filters != null) {
      _cubit.loadEvents(
        latitude: filters.centerLat,
        longitude: filters.centerLon,
        radius: filters.hasLocation ? filters.radiusKm : null,
        city: filters.city,
        limit: filters.limit,
        filters: filters,
      );
      return;
    }

    final coords = locationState.coordinates;
    final user = InjectionHelper.profileCubit.userData;
    _cubit.loadEvents(
      latitude: coords?.latitude ?? user?.latitude ?? _fallbackLatitude,
      longitude: coords?.longitude ?? user?.longitude ?? _fallbackLongitude,
      radius: _homeRadiusKm,
      city: coords?.city ?? user?.city,
      country: coords?.country ?? user?.country,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomePageCubit, HomePageState>(
      bloc: InjectionHelper.homePageCubit,
      listenWhen: (previous, current) =>
          previous.eventFilterRevision != current.eventFilterRevision,
      listener: (context, state) =>
          _loadEventsFromLocation(InjectionHelper.locationCubit.state),
      child: BlocConsumer<LocationCubit, LocationState>(
        bloc: InjectionHelper.locationCubit,
        listenWhen: (previous, current) =>
            (current.isGranted || current.isDenied) &&
            (previous.status != current.status ||
                previous.coordinates?.latitude !=
                    current.coordinates?.latitude ||
                previous.coordinates?.longitude !=
                    current.coordinates?.longitude),
        listener: (context, locationState) =>
            _loadEventsFromLocation(locationState),
        builder: (context, locationState) {
          if (locationState.status == LocationStatus.initial ||
              locationState.status == LocationStatus.loading) {
            final responsive = context.responsive;
            return Center(
              child: Lottie.asset(
                Assets.animations.manCandy.path,
                width: responsive.w(300),
                height: responsive.w(300),
                fit: BoxFit.contain,
                repeat: true,
              ),
            );
          }

          return BlocBuilder<ExploreCubit, ExploreState>(
            bloc: _cubit,
            builder: (context, state) {
              final responsive = context.responsive;

              return CloseKeyboard(
                onTap: () => _cubit.setFocusSearch(false),
                child: Scaffold(
                  backgroundColor: ColorSet.bgColor,
                  body: _buildBody(state, responsive),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildBody(ExploreState state, ResponsiveData responsive) {
    if (state.hasError && !state.hasEvents) {
      return _buildErrorState(state);
    }

    final events = ExploreEvent.toItems(state.visibleEvents);

    // Tablet always renders the full multi-section layout — each section
    // (hobby/matched/created) states its own empty case internally, and the
    // ad rails + notifications panel don't depend on the hobby feed at all
    // (matches HomeView_iPad: LeftView/RightView always render). Phone keeps
    // its own single swipe-card empty state, unchanged.
    if (responsive.isTablet) {
      return _buildTabletLayout(state, responsive, events);
    }

    if (events.isEmpty) {
      return _buildPhoneEmptyLayout(state, responsive);
    }

    return _buildPhoneLayout(state, responsive, events);
  }

  Widget _buildErrorState(ExploreState state) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              state.errorMessage ??
                  AppLocalizations.of(context)!.exploreLoadEventsFailed,
              textAlign: TextAlign.center,
              style: AppTextTheme.bodyLarge.copyWith(color: ColorSet.textColor),
            ),
            const Gap(16),
            TextButton(
              onPressed: () =>
                  _loadEventsFromLocation(InjectionHelper.locationCubit.state),
              child: Text(AppLocalizations.of(context)!.retry),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhoneEmptyLayout(
    ExploreState state,
    ResponsiveData responsive,
  ) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: responsive.horizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: ExplorePhoneSearchBar(
                isExpanded: state.focusSearch,
                onTapSearch: () => _cubit.setFocusSearch(true),
                onTextChanged: _cubit.setSearchQuery,
              ),
            ),
            _buildActiveFiltersBanner(state),
            _buildPhoneSearchResults(state),
            const Expanded(child: ExploreSwipeEmptyState()),
          ],
        ),
      ),
    );
  }

  Widget _buildPhoneLayout(
    ExploreState state,
    ResponsiveData responsive,
    List<ExploreEventItem> events,
  ) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: responsive.horizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: ExplorePhoneSearchBar(
                isExpanded: state.focusSearch,
                onTapSearch: () => _cubit.setFocusSearch(true),
                onTextChanged: _cubit.setSearchQuery,
              ),
            ),
            _buildActiveFiltersBanner(state),
            _buildPhoneSearchResults(state),
            Expanded(
              child: ExploreSwipeCards(
                state: state,
                responsive: responsive,
                events: events,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabletLayout(
    ExploreState state,
    ResponsiveData responsive,
    List<ExploreEventItem> events,
  ) {
    final rightColumnWidth = responsive.screenSize.width * 0.3;

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: responsive.verticalPadding,
        horizontal: responsive.horizontalPadding,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row (categories + search) naturally share one height,
            // so this one stays a Row — the sections below must NOT be
            // locked to each other's height (that was forcing the empty
            // "Hobby events" text to stretch to match the ad rail's tall
            // image, leaving a big grey gap before "Matched Event").
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: ExploreTabletHeader(
                    categories: state.categories,
                    selectedIndex: state.selectedCategoryIndex,
                    isLoading: state.isCategoriesLoading,
                    onSelected: _cubit.selectCategory,
                  ),
                ),
                Gap(ExploreConfig.tableColumnGap),
                SizedBox(
                  width: rightColumnWidth,
                  child: ExploreSearchWithDropdown(
                    hint: AppLocalizations.of(context)!.exploreSearchHint,
                    onTextChanged: _cubit.setSearchQuery,
                  ),
                ),
              ],
            ),
            if (state.activeFilters != null) ...[
              Gap(ExploreConfig.tableRowGap),
              _buildActiveFiltersBanner(state),
            ],
            Gap(ExploreConfig.tableRowGap),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizeReportingWidget(
                        onSizeChange: (size) =>
                            _cubit.updateEventInLocationHeight(size.height),
                        child: ExploreEventsCarousel(
                          events: events,
                          scrollController: _scrollController,
                        ),
                      ),
                      Gap(ExploreConfig.tableRowGap),
                      SizeReportingWidget(
                        onSizeChange: (size) =>
                            _cubit.updateSecondSectionHeight(size.height),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          spacing: ExploreConfig.tableRowGap,
                          children: [
                            ExploreMatchedEventsSection(
                              events: ExploreEvent.toItems(
                                state.visibleRecommendedEvents.isEmpty
                                    ? state.visibleEvents
                                    : state.visibleRecommendedEvents,
                              ),
                              showAll: state.showAllMatchedEvents,
                              onToggleViewAll:
                                  _cubit.toggleMatchedEventsViewAll,
                            ),
                            if (state.showCreatedEventSection)
                              ExploreCreatedEventsSection(
                                events: ExploreEvent.toItems(
                                    state.visibleCreatedEvents),
                                showAll: state.showAllCreatedEvents,
                                onToggleViewAll:
                                    _cubit.toggleCreatedEventsViewAll,
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Gap(ExploreConfig.tableColumnGap),
                SizedBox(
                  width: rightColumnWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _ExploreFeedAdsRail(
                        ads: _topFeedAds(state.feedAds),
                        placement: state.feedAdsPlacement,
                      ),
                      Gap(ExploreConfig.tableRowGap),
                      ConstrainedBox(
                        constraints: BoxConstraints.tightFor(
                          height: state.secondSectionHeight,
                        ),
                        child: Column(
                          spacing: ExploreConfig.tableRowGap,
                          children: [
                            const Expanded(child: ExploreNotificationsPanel()),
                            _ExploreFeedAdsRail(
                              ads: _bottomFeedAds(state.feedAds),
                              placement: state.feedAdsPlacement,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<AdItem> _topFeedAds(List<AdItem> ads) => ads.take(6).toList();

  // Always the ads after the top 6 — never falls back to re-showing the
  // top rail's own ads when there are fewer than 8 total.
  List<AdItem> _bottomFeedAds(List<AdItem> ads) => ads.skip(6).take(2).toList();

  Widget _buildActiveFiltersBanner(ExploreState state) {
    final filters = state.activeFilters;
    if (filters == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: ColorSet.tileFillColor,
          borderRadius: BorderRadius.circular(200),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                filters.summary,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.bodySmall.copyWith(
                  color: ColorSet.textColor,
                ),
              ),
            ),
            const Gap(8),
            GestureDetector(
              onTap: InjectionHelper.homePageCubit.clearEventFilters,
              child: Icon(Icons.close, size: 16, color: ColorSet.textColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhoneSearchResults(ExploreState state) {
    if (!state.focusSearch || state.searchQuery.trim().isEmpty) {
      return const SizedBox.shrink();
    }
    final results = state.searchResults;
    if (results.isEmpty) return const SizedBox.shrink();
    return Container(
      margin: const EdgeInsets.only(top: 8, bottom: 8),
      constraints: const BoxConstraints(maxHeight: 260),
      decoration: BoxDecoration(
        color: ColorSet.tileFillColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: results.length,
        separatorBuilder: (_, __) =>
            Divider(height: 1, color: ColorSet.profileBorderColor),
        itemBuilder: (context, index) {
          final event = results[index];
          return ListTile(
            dense: true,
            title: Text(
              event.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.textTheme.bodyMedium,
            ),
            subtitle: Text(
              event.displayLocation,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.textTheme.bodySmall,
            ),
            onTap: () {
              _cubit.setFocusSearch(false);
              AppDialog.show(
                context: context,
                width: AppDialogSize.eventDetailWidthFor(context),
                dialog: ExplorePreview(eventId: event.id),
              );
            },
          );
        },
      ),
    );
  }
}

class _ExploreFeedAdsRail extends StatelessWidget {
  const _ExploreFeedAdsRail({
    required this.ads,
    required this.placement,
  });

  final List<AdItem> ads;
  final String placement;

  @override
  Widget build(BuildContext context) {
    if (ads.isEmpty) return const SizedBox.shrink();

    // No forced height here — AdCarouselRail already sizes itself exactly
    // to its own row count and column width, matching iOS.
    return AdCarouselRail(
      ads: ads,
      placement: placement,
    );
  }
}
