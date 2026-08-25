import 'package:flutter/material.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/features/profile/presentation/guideline/guideline_config.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/size.dart';

class GuidelineTabBar extends StatelessWidget {
  const GuidelineTabBar({
    super.key,
    required this.selectedTab,
    required this.onTabSelected,
  });

  final GuidelineTab selectedTab;
  final ValueChanged<GuidelineTab> onTabSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: ColorSet.tileFillColor,
        borderRadius: BorderRadius.circular(size(8)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: GuidelineTab.values
            .map((tab) => Expanded(
                  child: _TabChip(
                    label: tab.label,
                    isSelected: selectedTab == tab,
                    onTap: () => onTabSelected(tab),
                  ),
                ))
            .toList(),
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
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color: isSelected ? ColorSet.bg2Color : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          maxLines: 2,
          textAlign: TextAlign.center,
          style: context.textTheme.bodyLarge.copyWith(
            fontSize: 14,
            height: 1,
            color: isSelected ? ColorSet.textColor : ColorSet.subTextColor,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
