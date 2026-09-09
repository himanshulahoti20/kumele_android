import 'package:flutter/material.dart';
import 'package:kuemele/features/blog/presentation/widgets/blog_category_filter_bar.dart';
import 'package:kuemele/features/profile/presentation/profileset/data/models/hobby_category_model.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/app_text_theme.dart';
import 'package:kuemele/l10n/app_localizations.dart';

class ExploreTabletHeader extends StatelessWidget {
  const ExploreTabletHeader({
    super.key,
    required this.categories,
    required this.selectedIndex,
    required this.onSelected,
    this.isLoading = false,
  });

  final List<HobbyCategoryModel> categories;
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 48),
      padding: const EdgeInsets.only(top: 8),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        runSpacing: 10,
        children: [
          Text(
            AppLocalizations.of(context)!.exploreTabletHeaderTitle,
            style: AppTextTheme.heading2.copyWith(
              color: ColorSet.textColor,
            ),
          ),
          // Same category filter bar as the Blog screen — real hobby
          // categories, same theme-swapping icon/selection behavior.
          BlogCategoryFilterBar(
            categories: categories,
            selectedIndex: selectedIndex,
            isLoading: isLoading,
            onSelected: onSelected,
          ),
        ],
      ),
    );
  }
}
