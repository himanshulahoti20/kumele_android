import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/core/app_strings.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/features/explore/cubit/event_detail_cubit.dart';
import 'package:kuemele/features/profile/presentation/my_events/widgets/my_event_bottom_actions.dart';
import 'package:kuemele/features/profile/presentation/my_events/widgets/my_event_cover_image.dart';
import 'package:kuemele/features/profile/presentation/my_events/widgets/my_event_description_section.dart';
import 'package:kuemele/features/profile/presentation/my_events/widgets/my_event_guests_section.dart';
import 'package:kuemele/features/profile/presentation/my_events/widgets/my_event_host_section.dart';
import 'package:kuemele/features/profile/presentation/my_events/widgets/my_event_quick_info_grid.dart';
import 'package:kuemele/features/profile/presentation/my_events/widgets/my_event_rules_section.dart';
import 'package:kuemele/features/profile/presentation/my_events/widgets/my_event_title_section.dart';
import 'package:kuemele/shared/components/app_button.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/widgets/app_empty_state.dart';
import 'package:kuemele/shared/widgets/app_loading_indicator.dart';
import 'package:kuemele/shared/widgets/mobile_header.dart';

class MyEventDetailPage extends StatefulWidget {
  const MyEventDetailPage({
    super.key,
    required this.eventId,
  });

  final String eventId;

  @override
  State<MyEventDetailPage> createState() => _MyEventDetailPageState();
}

class _MyEventDetailPageState extends State<MyEventDetailPage> {
  late final EventDetailCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = InjectionHelper.eventDetailCubit;
    _cubit.loadEventDetail(widget.eventId, forceRefresh: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorSet.bg3Color,
      body: SafeArea(
        child: BlocBuilder<EventDetailCubit, EventDetailState>(
          bloc: _cubit,
          builder: (context, state) {
            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 16.w, 16.w, 8.h),
                  child: const MobileHeader(
                    label: 'Event Details',
                    showBackButton: true,
                  ),
                ),
                Expanded(
                  child: _buildBody(context, state),
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: BlocBuilder<EventDetailCubit, EventDetailState>(
        bloc: _cubit,
        builder: (context, state) {
          if (state.detail == null || state.isLoading) {
            return const SizedBox.shrink();
          }
          return MyEventBottomActions(
            detail: state.detail!,
            eventId: widget.eventId,
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, EventDetailState state) {
    if (state.isLoading) {
      return const Center(
        child: AppLoadingIndicator.circle(
          size: 40,
        ),
      );
    }

    if (state.hasError) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: AppEmptyState(
            title: AppStrings.error,
            description: state.errorMessage ?? AppStrings.somethingWentWrong,
            icon: Icon(
              Icons.error_outline_rounded,
              size: 56.r,
              color: ColorSet.profileSubTextColor,
            ),
            action: AppButton(
              label: AppStrings.retry,
              size: AppButtonSize.sm,
              fullWidth: false,
              onPressed: () =>
                  _cubit.loadEventDetail(widget.eventId, forceRefresh: true),
            ),
          ),
        ),
      );
    }

    final detail = state.detail;
    if (detail == null) {
      return Center(
        child: AppEmptyState(
          title: 'Event Not Found',
          description: 'The requested event details could not be found.',
          icon: Icon(
            Icons.search_off_rounded,
            size: 56.r,
            color: ColorSet.profileSubTextColor,
          ),
        ),
      );
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyEventCoverImage(detail: detail),
          Gap(16.h),
          MyEventTitleSection(detail: detail),
          Gap(16.h),
          MyEventQuickInfoGrid(detail: detail),
          Gap(20.h),
          MyEventHostSection(detail: detail),
          Gap(20.h),
          MyEventDescriptionSection(detail: detail),
          if (detail.eventRules.hasRules) ...[
            Gap(20.h),
            MyEventRulesSection(detail: detail),
          ],
          Gap(24.h),
          MyEventGuestsSection(
            guests: state.guests,
            isGuestsLoading: state.isGuestsLoading,
          ),
        ],
      ),
    );
  }
}
