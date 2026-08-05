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
      height: 50,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: ColorSet.tileFillColor,
        borderRadius: BorderRadius.circular(size(8)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          spacing: 8,
          children: GuidelineTab.values
              .map((tab) => _TabChip(
                    label: tab.label,
                    isSelected: selectedTab == tab,
                    onTap: () => onTabSelected(tab),
                  ))
              .toList(),
        ),
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
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? ColorSet.bg2Color : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          style: context.textTheme.bodyLarge.copyWith(fontSize: 17),
        ),
      ),
    );
  }
}
