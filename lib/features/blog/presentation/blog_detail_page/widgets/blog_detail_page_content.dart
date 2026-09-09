import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/core/responsive/responsive.dart';
import 'package:kuemele/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:kuemele/features/blog/presentation/models/blog_models.dart';
import 'package:kuemele/features/blog/presentation/blog_detail_page/widgets/blog_detail_page_sections.dart';
import 'package:kuemele/features/profile/presentation/profileset/data/models/hobby_category_model.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/icons.dart';
import 'package:kuemele/shared/utils/conversion_utils.dart';
import 'package:kuemele/shared/widgets/category_icon_widget.dart';
import 'package:kuemele/shared/widgets/kumele_asset_widget.dart';

class BlogDetailContent extends StatelessWidget {
  const BlogDetailContent({
    super.key,
    required this.blog,
    required this.isLoading,
    this.errorMessage,
    this.onRetry,
    this.onActionTap,
  });

  final BlogPostModel blog;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback? onRetry;
  final ValueChanged<BlogDetailSocialAction>? onActionTap;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            errorMessage!,
            textAlign: TextAlign.center,
            style: context.textTheme.bodyMedium.copyWith(
              color: ColorSet.subTextColor,
            ),
          ),
          if (onRetry != null)
            TextButton(
              onPressed: onRetry,
              child: const Text('Retry'),
            ),
        ],
      );
    }

    final parsedDate = ConversionUtils.parseDateTime(blog.createdAt);
    final dateLabel = parsedDate != null
        ? ConversionUtils.formatDateTime(parsedDate, 'dd MMMM, yyyy')
        : blog.createdAt;
    final category = blog.hobbyCategory?.name.trim();
    final hobbyCategory = blog.hobbyCategory;
    final categoryModel = hobbyCategory == null
        ? null
        : context
            .watch<BlogBloc>()
            .state
            .categories
            .cast<HobbyCategoryModel?>()
            .firstWhere(
              (c) => c!.id == hobbyCategory.id || c.slug == hobbyCategory.slug,
              orElse: () => null,
            );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildCover(category, categoryModel),
        SizedBox(height: 22.h),
        Text(
          blog.title,
          style: context.textTheme.titleMediumBold.copyWith(
            color: ColorSet.textColor,
            fontSize: 20.sp,
            height: 1.25,
          ),
        ),
        SizedBox(height: 10.h),
        Text(
          '${blog.author.displayName} • $dateLabel',
          style: context.textTheme.bodySmall.copyWith(
            color: ColorSet.textColor,
            fontSize: 13.sp,
          ),
        ),
        SizedBox(height: 10.h),
        BlogDetailSocialActionsRow(
          likeCount: blog.likeCount,
          isLiked: blog.isLiked ?? false,
          hasYoutube: blog.youtubeLink?.trim().isNotEmpty == true,
          hasFacebook: blog.facebookLink?.trim().isNotEmpty == true,
          hasInstagram: blog.instagramLink?.trim().isNotEmpty == true,
          hasPinterest: blog.pinterestLink?.trim().isNotEmpty == true,
          hasTwitter: blog.twitterLink?.trim().isNotEmpty == true,
          onActionTap: onActionTap,
        ),
        SizedBox(height: 24.h),
        _buildArticle(context),
      ],
    );
  }

  Widget _buildCover(String? category, HobbyCategoryModel? categoryModel) {
    final imageUrl = blog.coverImage?.trim();
    return Builder(
      builder: (context) {
        final isPhone = context.responsive.isPhone;
        // Phone: compact padding (4h vertical), Tablet: normal padding (6h)
        final verticalPadding = isPhone ? 4.h : 6.h;

        return AspectRatio(
          aspectRatio: 16 / 9,
          child: ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
            child: Stack(
              fit: StackFit.expand,
              children: [
                KumeleAssetWidget(
                  assetPath: imageUrl?.isNotEmpty == true
                      ? imageUrl!
                      : IconSet.blogDefaultImage,
                  fit: BoxFit.cover,
                ),
                if (category != null && category.isNotEmpty)
                  Positioned(
                    top: 16.h,
                    right: 16.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: verticalPadding,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.78),
                        borderRadius: BorderRadius.circular(999.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Always the dark-mode icon variant — this chip's
                          // background stays dark (black @ 78%) regardless of
                          // the app theme, same reasoning as CategoryTag.
                          CategoryIconWidget(
                            icon: categoryModel?.iconDark ??
                                categoryModel?.icon,
                            size: 14.r,
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            category,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11.sp,
                              height: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildArticle(BuildContext context) {
    final blocks = blog.contentBlocks;
    if (blocks != null && blocks.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: blocks.map((block) {
          final value = block.value.trim();
          if (value.isEmpty) return const SizedBox.shrink();
          return Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: Html(data: value, style: _contentStyles()),
          );
        }).toList(),
      );
    }

    final contentHtml = blog.contentHtml;
    if (contentHtml != null && contentHtml.trim().isNotEmpty) {
      return Html(
        data: contentHtml,
        style: _contentStyles(),
      );
    }

    return Text(
      blog.excerpt,
      style: context.textTheme.bodyLarge.copyWith(
        color: ColorSet.textColor,
        height: 1.45,
      ),
    );
  }

  Map<String, Style> _contentStyles() {
    return {
      "body": Style(
        margin: Margins.zero,
        padding: HtmlPaddings.zero,
        color: ColorSet.textColor,
        fontSize: FontSize(16.sp),
        lineHeight: LineHeight(1.45),
      ),
      "h1": Style(
        color: ColorSet.textColor,
        margin: Margins.only(top: 16, bottom: 8),
      ),
      "h2": Style(
        color: ColorSet.textColor,
        margin: Margins.only(top: 16, bottom: 8),
      ),
      "h3": Style(
        color: ColorSet.textColor,
        margin: Margins.only(top: 16, bottom: 8),
      ),
      "h4": Style(
        color: ColorSet.textColor,
        margin: Margins.only(top: 14, bottom: 6),
      ),
      "h5": Style(
        color: ColorSet.textColor,
        margin: Margins.only(top: 12, bottom: 6),
      ),
      "h6": Style(
        color: ColorSet.textColor,
        margin: Margins.only(top: 12, bottom: 6),
      ),
      "p": Style(
        color: ColorSet.textColor,
        margin: Margins.only(bottom: 12),
      ),
      "ul": Style(
        color: ColorSet.textColor,
        margin: Margins.only(left: 18, bottom: 12),
        padding: HtmlPaddings.zero,
      ),
      "ol": Style(
        color: ColorSet.textColor,
        margin: Margins.only(left: 18, bottom: 12),
        padding: HtmlPaddings.zero,
      ),
      "li": Style(
        color: ColorSet.textColor,
        margin: Margins.only(bottom: 4),
      ),
      "a": Style(
        color: ColorSet.specialColor,
        textDecoration: TextDecoration.underline,
      ),
      "strong": Style(
        color: ColorSet.textColor,
        fontWeight: FontWeight.w700,
      ),
      "b": Style(
        color: ColorSet.textColor,
        fontWeight: FontWeight.w700,
      ),
      "em": Style(
        color: ColorSet.textColor,
        fontStyle: FontStyle.italic,
      ),
      "blockquote": Style(
        color: ColorSet.textColor.withValues(alpha: 0.85),
        margin: Margins.only(left: 8, top: 12, bottom: 12),
        padding: HtmlPaddings.only(left: 12),
        border: Border(
          left: BorderSide(
            color: ColorSet.specialColor.withValues(alpha: 0.35),
            width: 3,
          ),
        ),
      ),
      "code": Style(
        color: ColorSet.textColor,
        backgroundColor: ColorSet.bg2Color,
        padding: HtmlPaddings.symmetric(horizontal: 6, vertical: 4),
        fontFamily: 'monospace',
      ),
      "pre": Style(
        color: ColorSet.textColor,
        backgroundColor: ColorSet.bg2Color,
        padding: HtmlPaddings.all(12),
        margin: Margins.only(bottom: 12),
      ),
      "table": Style(
        color: ColorSet.textColor,
        margin: Margins.only(bottom: 12),
      ),
      "th": Style(
        color: ColorSet.textColor,
        padding: HtmlPaddings.all(8),
      ),
      "td": Style(
        color: ColorSet.textColor,
        padding: HtmlPaddings.all(8),
      ),
      "img": Style(
        margin: Margins.only(top: 8, bottom: 12),
        width: Width(100, Unit.percent),
        height: Height.auto(),
      ),
      "hr": Style(
        margin: Margins.only(top: 12, bottom: 12),
      ),
    };
  }
}
