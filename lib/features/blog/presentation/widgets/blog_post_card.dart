import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/features/blog/presentation/models/blog_models.dart';
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
  });

  final BlogPostModel blog;

  @override
  Widget build(BuildContext context) {
    final dateTime = ConversionUtils.parseDateTime(blog.createdAt);
    final formattedDate = dateTime != null
        ? ConversionUtils.formatDateTime(dateTime, 'dd MMMM, yyyy')
        : blog.createdAt;
    final isPlaceholder = blog.id.startsWith('placeholder-');

    return InkWell(
      onTap: isPlaceholder
          ? null
          : () => context.push(
                AppRoutes.blogDetail,
                extra: BlogDetailRouteArgs(blog: blog),
              ),
      borderRadius: BorderRadius.circular(10.r),
      child: Container(
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: ColorSet.bgColor,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            KumeleAssetWidget(
              assetPath: blog.coverImage?.isNotEmpty == true
                  ? blog.coverImage!
                  : IconSet.blogDefaultImage,
              width: 106.w,
              height: 106.w,
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
                  if (blog.hobbyCategory != null) ...[
                    Gap(12.h),
                    CategoryTag(
                      label: blog.hobbyCategory!.name,
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
