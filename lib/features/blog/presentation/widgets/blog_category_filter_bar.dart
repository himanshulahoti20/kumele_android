import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/features/blog/presentation/models/blog_models.dart';
import 'package:kuemele/shared/components/app_colors.dart';

class BlogCategoryFilterBar extends StatelessWidget {
  const BlogCategoryFilterBar({
    super.key,
    required this.categoryNames,
    required this.selectedIndex,
    required this.onSelected,
    this.isLoading = false,
  });

  final List<String> categoryNames;
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
              label: 'All',
              isSelected: selectedIndex == 0,
            ),
            ...List.generate(categoryNames.length, (index) {
              final name = categoryNames[index];
              return BlogCategory(
                label: name,
                isSelected: selectedIndex == index + 1,
              );
            }),
          ];

    return SizedBox(
      height: 46.w,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: displayCategories.length,
        separatorBuilder: (_, __) => Gap(8.w),
        itemBuilder: (context, index) {
          final category = displayCategories[index];
          final isSelected = category.isSelected;

          return InkWell(
            borderRadius: BorderRadius.circular(999.r),
            onTap: () => onSelected(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.w),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999.r),
                color: isSelected
                    ? ColorSet.specialYellowColor
                    : ColorSet.bg8Color,
              ),
              child: Text(
                category.label,
                style: context.textTheme.bodySmall.copyWith(
                    color:
                        isSelected ? ColorSet.tileFontColor : ColorSet.bg3Color,
                    fontSize: 13.sp),
              ),
            ),
          );
        },
      ),
    );
  }
}
