import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/core/responsive/responsive.dart';
import 'package:kuemele/features/blog/presentation/models/blog_models.dart';
import 'package:kuemele/features/profile/presentation/profileset/data/models/hobby_category_model.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/widgets/category_icon_widget.dart';
import 'package:kuemele/l10n/app_localizations.dart';

class BlogCategoryFilterBar extends StatelessWidget {
  const BlogCategoryFilterBar({
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
    final displayCategories = isLoading
        ? List.generate(BlogCategory.placeholders.length, (index) {
            final placeholder = BlogCategory.placeholders[index];
            return BlogCategory(
              label: placeholder.label,
              isSelected: selectedIndex == index,
            );
          })
        : [
            BlogCategory(
              label: AppLocalizations.of(context)!.blogCategoryAll,
              isSelected: selectedIndex == 0,
            ),
            ...List.generate(categories.length, (index) {
              final category = categories[index];
              return BlogCategory(
                label: category.name,
                icon: category.icon,
                iconDark: category.iconDark,
                color: category.color,
                isSelected: selectedIndex == index + 1,
              );
            }),
          ];

    final isTablet = context.responsive.isTablet;
    // Tablet reads the pills from further away, so they get a bigger label
    // — but the vertical padding that drove the 46 cell height shrinks to
    // compensate, keeping the row itself compact.
    final cellHeight = isTablet ? 40.w : 46.w;
    final verticalPadding = isTablet ? 8.w : 12.w;
    final fontSize = isTablet ? 16.0 : 13.sp;

    return SizedBox(
      height: cellHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: displayCategories.length,
        separatorBuilder: (_, __) => Gap(8.w),
        itemBuilder: (context, index) {
          final category = displayCategories[index];
          final isSelected = category.isSelected;
          // Matches iOS's categoryIconURL: dark mode picks `icon`, light
          // mode picks `iconDark ?? icon` — gate on this resolved value,
          // not the raw `icon` field, so a category with only `iconDark`
          // set still shows its icon.
          final resolvedIcon = ColorSet.isDarkMode
              ? category.icon
              : (category.iconDark ?? category.icon);

          return InkWell(
            borderRadius: BorderRadius.circular(999.r),
            onTap: () => onSelected(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: EdgeInsets.symmetric(
                horizontal: 24.w,
                vertical: verticalPadding,
              ),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999.r),
                color: isSelected
                    ? ColorSet.specialYellowColor
                    : ColorSet.revbg3Color,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (resolvedIcon != null && resolvedIcon.isNotEmpty) ...[
                    CategoryIconWidget(
                      // This pill's background is revbg3Color, which
                      // inverts with the app theme (black in light mode,
                      // white in dark) — the opposite of
                      // CategoryIconWidget's own default swap. Passing
                      // the already-resolved value only as `icon:`
                      // bypasses the widget's built-in (opposite) swap.
                      icon: resolvedIcon,
                      size: 16.w,
                    ),
                    Gap(6.w),
                  ],
                  Text(
                    category.label,
                    style: context.textTheme.bodySmall.copyWith(
                      color: isSelected
                          ? const Color(0xFF242424)
                          : ColorSet.bg2Color,
                      fontSize: fontSize,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
