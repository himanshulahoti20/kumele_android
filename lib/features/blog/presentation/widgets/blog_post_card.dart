import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/core/responsive/responsive.dart';
import 'package:kuemele/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:kuemele/features/blog/presentation/models/blog_models.dart';
import 'package:kuemele/features/profile/presentation/profileset/data/models/hobby_category_model.dart';
import 'package:kuemele/navigation/app_routes.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/event_card/widgets/category_tag.dart';
import 'package:kuemele/shared/components/icons.dart';
import 'package:kuemele/shared/utils/conversion_utils.dart';
import 'package:kuemele/shared/widgets/kumele_asset_widget.dart';

class BlogPostCard extends StatelessWidget {
  const BlogPostCard({
    super.key,
    required this.blog,
    this.onTap,
  });

  final BlogPostModel blog;

  /// Tablet-only override: opens the blog in the popup overlay instead of
  /// pushing the detail route. Null keeps the existing push behavior.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final dateTime = ConversionUtils.parseDateTime(blog.createdAt);
    final formattedDate = dateTime != null
        ? ConversionUtils.formatDateTime(dateTime, 'dd MMMM, yyyy')
        : blog.createdAt;
    final isPlaceholder = blog.id.startsWith('placeholder-');
    final isTablet = context.responsive.isTablet;
    final cardRadius = isTablet ? 16.r : 10.r;
    final imageSize = isTablet ? 92.w : 106.w;
    final category = blog.hobbyCategory;
    // Matches iOS's HobbyCategoryBadge: looked up by name (the blog
    // payload's hobby-category id/slug don't reliably match the
    // /hobbies/categories cache), and falls back to the icon fields
    // embedded directly on the blog's own hobbyCategory when the cache
    // has no match at all — see BlogHobbyCategory.icon/iconDark.
    final categoryModel = category == null || category.name.trim().isEmpty
        ? null
        : context
            .watch<BlogBloc>()
            .state
            .categories
            .cast<HobbyCategoryModel?>()
            .firstWhere(
              (c) => c!.name == category.name.trim(),
              orElse: () => null,
            );

    return InkWell(
      onTap: isPlaceholder
          ? null
          : () {
              context.read<BlogBloc>().add(BlogFetchDetails(blog.id));
              if (onTap != null) {
                onTap!();
                return;
              }
              context.push(
                AppRoutes.blogDetail,
                extra: BlogDetailRouteArgs(blog: blog),
              );
            },
      borderRadius: BorderRadius.circular(cardRadius),
      child: Container(
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: ColorSet.chatListTileFillColor,
          borderRadius: BorderRadius.circular(cardRadius),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            KumeleAssetWidget(
              assetPath: blog.coverImage?.isNotEmpty == true
                  ? blog.coverImage!
                  : IconSet.blogDefaultImage,
              width: imageSize,
              height: imageSize,
              fit: BoxFit.cover,
              borderRadius: BorderRadius.circular(10.r),
            ),
            Gap(12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    blog.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.titleMedium.copyWith(
                      color: ColorSet.textColor,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Gap(6.h),
                  Text(
                    blog.author.displayName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.bodyMedium.copyWith(
                      color: ColorSet.textColor,
                      fontSize: 13.sp,
                    ),
                  ),
                  Gap(6.h),
                  Text(
                    formattedDate,
                    style: context.textTheme.bodyMedium.copyWith(
                      color: ColorSet.textColor,
                      fontSize: 13.sp,
                    ),
                  ),
                  if (category != null) ...[
                    Gap(12.h),
                    if (isPlaceholder)
                      Container(
                        width: 90.w,
                        height: 26.w,
                        decoration: BoxDecoration(
                          color: ColorSet.bg8Color,
                          borderRadius: BorderRadius.circular(999.r),
                        ),
                      )
                    else
                      CategoryTag(
                        label: category.name,
                        iconPath: categoryModel?.icon ?? category.icon,
                        iconPathDark:
                            categoryModel?.iconDark ?? category.iconDark,
                        fontSize: 12.sp,
                      ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
