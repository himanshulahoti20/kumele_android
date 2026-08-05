import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/core/app_strings.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/shared/components/app_colors.dart';

enum MyEventsSubTab { created, joined }

class ProfileEventsSection extends StatefulWidget {
  const ProfileEventsSection({super.key});

  @override
  State<ProfileEventsSection> createState() => _ProfileEventsSectionState();
}

class _ProfileEventsSectionState extends State<ProfileEventsSection> {
  MyEventsSubTab _activeSubTab = MyEventsSubTab.created;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSubTabBar(),
        Gap(16.h),
        _buildEventsContent(),
      ],
    );
  }

  Widget _buildSubTabBar() {
    return Container(
      padding: EdgeInsets.all(3.r),
      decoration: BoxDecoration(
        color: ColorSet.tileFillColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: _SubTabChip(
              label: AppStrings.createdEvents,
              isSelected: _activeSubTab == MyEventsSubTab.created,
              onTap: () =>
                  setState(() => _activeSubTab = MyEventsSubTab.created),
            ),
          ),
          Expanded(
            child: _SubTabChip(
              label: AppStrings.joinedEvents,
              isSelected: _activeSubTab == MyEventsSubTab.joined,
              onTap: () =>
                  setState(() => _activeSubTab = MyEventsSubTab.joined),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventsContent() {
    final isCreatedTab = _activeSubTab == MyEventsSubTab.created;
    final emptyMessage = isCreatedTab
        ? AppStrings.noEventsCreatedYet
        : AppStrings.noEventsJoinedYet;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 36.h, horizontal: 20.w),
      decoration: BoxDecoration(
        color: ColorSet.tileFillColor,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isCreatedTab
                ? Icons.event_available_outlined
                : Icons.event_seat_outlined,
            size: 48.r,
            color: ColorSet.profileSubTextColor,
          ),
          Gap(12.h),
          Text(
            isCreatedTab ? AppStrings.createdEvents : AppStrings.joinedEvents,
            style: context.textTheme.titleMediumBold.copyWith(
              color: ColorSet.textColor,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          Gap(6.h),
          Text(
            emptyMessage,
            textAlign: TextAlign.center,
            style: context.textTheme.bodyMedium.copyWith(
              color: ColorSet.profileSubTextColor,
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }
}

class _SubTabChip extends StatelessWidget {
  const _SubTabChip({
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
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.symmetric(vertical: 8.h),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? ColorSet.bg2Color : Colors.transparent,
          borderRadius: BorderRadius.circular(6.r),
        ),
        child: Text(
          label,
          style: context.textTheme.bodyMediumSemiBold.copyWith(
            fontSize: 14.sp,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color:
                isSelected ? ColorSet.textColor : ColorSet.profileSubTextColor,
          ),
        ),
      ),
    );
  }
}
