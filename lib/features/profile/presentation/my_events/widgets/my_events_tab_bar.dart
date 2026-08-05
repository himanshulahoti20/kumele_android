import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kuemele/core/app_strings.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/features/profile/presentation/my_events/cubit/my_events_state.dart';
import 'package:kuemele/shared/components/app_colors.dart';

class MyEventsTabBar extends StatelessWidget {
  const MyEventsTabBar({
    super.key,
    required this.activeTab,
    required this.onTabSelected,
  });

  final MyEventsTab activeTab;
  final ValueChanged<MyEventsTab> onTabSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.h,
      padding: EdgeInsets.all(4.r),
      decoration: BoxDecoration(
        color: ColorSet.tileFillColor,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: _TabChip(
              label: AppStrings.createdEvents,
              isSelected: activeTab == MyEventsTab.created,
              onTap: () => onTabSelected(MyEventsTab.created),
            ),
          ),
          Expanded(
            child: _TabChip(
              label: AppStrings.joinedEvents,
              isSelected: activeTab == MyEventsTab.joined,
              onTap: () => onTabSelected(MyEventsTab.joined),
            ),
          ),
        ],
      ),
    );
  }
}

class _TabChip extends StatelessWidget {
  const _TabChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? ColorSet.bg2Color : Colors.transparent,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Text(
          label,
          style: context.textTheme.titleMediumSemiBold.copyWith(
            fontSize: 15.sp,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color:
                isSelected ? ColorSet.textColor : ColorSet.profileSubTextColor,
          ),
        ),
      ),
    );
  }
}
