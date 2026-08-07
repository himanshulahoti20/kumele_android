import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/l10n/app_localizations.dart';
import 'package:kuemele/shared/components/app_colors.dart';

enum ProfileTab { settings, myEvents }

class ProfileTabBar extends StatelessWidget {
  const ProfileTabBar({
    super.key,
    required this.selectedTab,
    required this.onTabSelected,
  });

  final ProfileTab selectedTab;
  final ValueChanged<ProfileTab> onTabSelected;

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
            child: _TabItem(
              label: AppLocalizations.of(context)!.settingsTitle,
              isSelected: selectedTab == ProfileTab.settings,
              onTap: () => onTabSelected(ProfileTab.settings),
            ),
          ),
          Expanded(
            child: _TabItem(
              label: AppLocalizations.of(context)!.myEvents,
              isSelected: selectedTab == ProfileTab.myEvents,
              onTap: () => onTabSelected(ProfileTab.myEvents),
            ),
          ),
        ],
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  const _TabItem({
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
