import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kuemele/core/responsive/responsive.dart';
import 'package:kuemele/features/profile/presentation/my_events/cubit/my_events_cubit.dart';
import 'package:kuemele/features/profile/presentation/my_events/cubit/my_events_state.dart';
import 'package:kuemele/features/profile/presentation/my_events/widgets/my_event_card.dart';
import 'package:kuemele/l10n/app_localizations.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/widgets/app_empty_state.dart';
import 'package:skeletonizer/skeletonizer.dart';

class JoinedEventsPage extends StatelessWidget {
  const JoinedEventsPage({
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

    return _buildEmptyState(context);
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

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 40.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: ColorSet.tileFillColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: AppEmptyState(
        title: AppLocalizations.of(context)!.joinedEvents,
        description: AppLocalizations.of(context)!.noEventsJoinedYet,
        icon: Icon(
          Icons.event_seat_rounded,
          size: 56.r,
          color: ColorSet.profileSubTextColor,
        ),
      ),
    );
  }
}
