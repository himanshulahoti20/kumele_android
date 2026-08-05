import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:kuemele/core/app_strings.dart';
import 'package:kuemele/core/responsive/responsive.dart';
import 'package:kuemele/features/explore/domain/entities/explore_event.dart';
import 'package:kuemele/features/profile/presentation/my_events/cubit/my_events_cubit.dart';
import 'package:kuemele/features/profile/presentation/my_events/cubit/my_events_state.dart';
import 'package:kuemele/features/profile/presentation/my_events/widgets/my_event_card.dart';
import 'package:kuemele/navigation/app_routes.dart';
import 'package:kuemele/shared/components/app_button.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/widgets/app_empty_state.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CreatedEventsPage extends StatelessWidget {
  const CreatedEventsPage({
    super.key,
    required this.state,
    required this.cubit,
  });

  final MyEventsState state;
  final MyEventsCubit cubit;

  @override
  Widget build(BuildContext context) {
    if (state.isLoading) {
      return _buildSkeletonLoader(context);
    }

    if (state.hasError) {
      return _buildErrorState();
    }

    if (!state.hasCreatedEvents) {
      return _buildEmptyState();
    }

    return _buildEventsGrid(context, state.createdEvents);
  }

  Widget _buildSkeletonLoader(BuildContext context) {
    final responsive = context.responsive;

    return Skeletonizer(
      enabled: true,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.only(bottom: 16.h),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: responsive.gridColumns,
          crossAxisSpacing: responsive.gutter,
          mainAxisSpacing: responsive.gutter,
          childAspectRatio: 0.82,
        ),
        itemCount: 4,
        itemBuilder: (context, index) => MyEventCard.placeholder(),
      ),
    );
  }

  Widget _buildEventsGrid(BuildContext context, List<ExploreEvent> events) {
    final responsive = context.responsive;
    final items = ExploreEvent.toItems(events);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.only(bottom: 16.h),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: responsive.gridColumns,
        crossAxisSpacing: responsive.gutter,
        mainAxisSpacing: responsive.gutter,
        childAspectRatio: 0.82,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return MyEventCard.fromItem(
          item,
          onTap: () => _openEventPreview(context, item.id),
        );
      },
    );
  }

  void _openEventPreview(BuildContext context, String eventId) {
    final id = eventId.trim();
    if (id.isEmpty) return;

    context.push(AppRoutes.myEventDetail, extra: id);
  }

  Widget _buildErrorState() {
    return _ContentContainer(
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
          onPressed: cubit.loadCreatedEvents,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return _ContentContainer(
      child: AppEmptyState(
        title: AppStrings.createdEvents,
        description: AppStrings.noEventsCreatedYet,
        icon: Icon(
          Icons.event_available_rounded,
          size: 56.r,
          color: ColorSet.profileSubTextColor,
        ),
      ),
    );
  }
}

class _ContentContainer extends StatelessWidget {
  const _ContentContainer({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 40.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: ColorSet.tileFillColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: child,
    );
  }
}
