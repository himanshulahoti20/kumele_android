import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/app_text_theme.dart';

class ExploreSectionHeader extends StatelessWidget {
  const ExploreSectionHeader({
    super.key,
    required this.title,
    required this.showAll,
    required this.onToggleViewAll,
  });

  final String title;
  final bool showAll;
  final VoidCallback onToggleViewAll;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppTextTheme.headlineSmallBold.copyWith(
              color: ColorSet.textColor,
            ),
          ),
          GestureDetector(
            onTap: onToggleViewAll,
            child: Text(
              showAll ? 'Show Less  ' : 'View All  ',
              style: AppTextTheme.titleMediumSemiBold.copyWith(
                color: ColorSet.lightBlueColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ExploreSectionContainer extends StatelessWidget {
  const ExploreSectionContainer({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.only(top: 15, bottom: 35),
  });

  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorSet.bg3Color.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}

class ExploreSectionTitle extends StatelessWidget {
  const ExploreSectionTitle({
    super.key,
    required this.title,
    this.padding = const EdgeInsets.only(left: 15),
  });

  final String title;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Text(
        title,
        style: AppTextTheme.headlineSmallBold.copyWith(
          color: ColorSet.textColor,
        ),
      ),
    );
  }
}

class ExploreSectionSpacer extends StatelessWidget {
  const ExploreSectionSpacer({super.key});

  @override
  Widget build(BuildContext context) => const Gap(23);
}
