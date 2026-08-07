import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/core/responsive/responsive.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/features/explore/cubit/explore_cubit.dart';
import 'package:kuemele/features/explore/cubit/explore_state.dart';
import 'package:kuemele/features/explore/domain/entities/explore_event.dart';
import 'package:kuemele/features/explore/presentation/explore_config.dart';
import 'package:kuemele/features/explore/presentation/widgets/explore_auto_scroll_gallery.dart';
import 'package:kuemele/features/explore/presentation/widgets/explore_event_grid_section.dart';
import 'package:kuemele/features/explore/presentation/widgets/explore_events_carousel.dart';
import 'package:kuemele/features/explore/presentation/widgets/explore_notifications_panel.dart';
import 'package:kuemele/features/explore/presentation/widgets/explore_phone_search_bar.dart';
import 'package:kuemele/features/explore/presentation/widgets/explore_search_with_dropdown.dart';
import 'package:kuemele/features/explore/presentation/widgets/explore_swipe_cards.dart';
import 'package:kuemele/features/explore/presentation/widgets/explore_swipe_empty_state.dart';
import 'package:kuemele/features/explore/presentation/widgets/explore_tablet_header.dart';
import 'package:kuemele/l10n/app_localizations.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/app_text_theme.dart';
import 'package:kuemele/shared/components/close_keyboard_widget.dart';
import 'package:kuemele/shared/cubit/location_cubit.dart';
import 'package:kuemele/shared/widgets/app_loading_indicator.dart';
import 'package:kuemele/shared/widgets/size_reporting_widget.dart';
import 'package:kuemele/shared/widgets/location_disabled_view.dart';

class Explore extends StatefulWidget {
  const Explore({super.key});

  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  final ExploreCubit _cubit = InjectionHelper.exploreCubit;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    final locationState = InjectionHelper.locationCubit.state;
    if (locationState.status == LocationStatus.initial) {
      InjectionHelper.locationCubit.requestLocation();
    } else if (locationState.isGranted) {
      _loadEventsFromLocation(locationState);
    }
  }

  void _loadEventsFromLocation(LocationState locationState) {
    final radius = InjectionHelper.profileCubit.userData?.locationRadius;
    _cubit.loadEvents(
      latitude: locationState.coordinates?.latitude,
      longitude: locationState.coordinates?.longitude,
      radius: radius?.toDouble(),
      city: locationState.coordinates?.city ??
          InjectionHelper.profileCubit.userData?.city,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LocationCubit, LocationState>(
      bloc: InjectionHelper.locationCubit,
      listenWhen: (previous, current) =>
          current.isGranted &&
          (previous.status != current.status ||
              previous.coordinates?.latitude != current.coordinates?.latitude ||
              previous.coordinates?.longitude !=
                  current.coordinates?.longitude),
      listener: (context, locationState) =>
          _loadEventsFromLocation(locationState),
      builder: (context, locationState) {
        if (locationState.isDenied) {
          return LocationDisabledView(locationState: locationState);
        }

        if (locationState.status == LocationStatus.initial ||
            locationState.status == LocationStatus.loading) {
          return Center(
              child: AppLoadingIndicator.circle(
            size: 24.w,
          ));
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
    );
  }

  Widget _buildBody(ExploreState state, ResponsiveData responsive) {
    if (state.isLoading && !state.hasEvents) {
      return Center(
          child: AppLoadingIndicator.circle(
        size: 24.w,
      ));
    }

    if (state.hasError && !state.hasEvents) {
      return _buildErrorState(state);
    }

    final events = ExploreEvent.toItems(state.visibleEvents);

    if (events.isEmpty) {
      return responsive.isTablet
          ? const Center(child: ExploreSwipeEmptyState())
          : _buildPhoneEmptyLayout(state, responsive);
    }

    return responsive.isTablet
        ? _buildTabletLayout(state, responsive, events)
        : _buildPhoneLayout(state, responsive, events);
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
            ExplorePhoneSearchBar(
              isExpanded: state.focusSearch,
              onTapSearch: () => _cubit.setFocusSearch(true),
              onTextChanged: _cubit.setSearchQuery,
            ),
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
            ExplorePhoneSearchBar(
              isExpanded: state.focusSearch,
              onTapSearch: () => _cubit.setFocusSearch(true),
              onTextChanged: _cubit.setSearchQuery,
            ),
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
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: responsive.verticalPadding,
        horizontal: responsive.horizontalPadding,
      ),
      child: SingleChildScrollView(
        child: Table(
          columnWidths: {
            0: const FlexColumnWidth(1),
            1: FixedColumnWidth(ExploreConfig.tableColumnGap),
            2: FixedColumnWidth(responsive.screenSize.width * 0.3),
          },
          children: [
            _tableRow(
              const ExploreTabletHeader(),
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.bottom,
                child: ExploreSearchWithDropdown(
                  hint: ExploreConfig.searchHint,
                  onTextChanged: _cubit.setSearchQuery,
                ),
              ),
            ),
            _tableSpacer,
            _tableRow(
              SizeReportingWidget(
                onSizeChange: (size) =>
                    _cubit.updateEventInLocationHeight(size.height),
                child: ExploreEventsCarousel(
                  events: events,
                  scrollController: _scrollController,
                ),
              ),
              ExploreAutoScrollGrid(height: state.eventInLocationHeight),
            ),
            _tableSpacer,
            _tableRow(
              SizeReportingWidget(
                onSizeChange: (size) =>
                    _cubit.updateSecondSectionHeight(size.height),
                child: Column(
                  spacing: ExploreConfig.tableRowGap,
                  children: [
                    ExploreMatchedEventsSection(
                      events: events,
                      showAll: state.showAllMatchedEvents,
                      onToggleViewAll: _cubit.toggleMatchedEventsViewAll,
                    ),
                    if (state.showCreatedEventSection)
                      ExploreCreatedEventsSection(
                        events: events,
                        showAll: state.showAllCreatedEvents,
                        onToggleViewAll: _cubit.toggleCreatedEventsViewAll,
                      ),
                  ],
                ),
              ),
              ConstrainedBox(
                constraints: BoxConstraints.tightFor(
                  height: state.secondSectionHeight,
                ),
                child: Column(
                  spacing: ExploreConfig.tableRowGap,
                  children: const [
                    Expanded(child: ExploreNotificationsPanel()),
                    ExploreAutoScrollList(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TableRow get _tableSpacer => TableRow(
        children: [
          Gap(ExploreConfig.tableRowGap),
          Gap(ExploreConfig.tableRowGap),
          Gap(ExploreConfig.tableRowGap),
        ],
      );

  TableRow _tableRow(Widget first, Widget second) {
    return TableRow(
      children: [first, Gap(ExploreConfig.tableColumnGap), second],
    );
  }
}
