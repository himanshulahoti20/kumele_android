import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/features/blog/presentation/blog_detail_page/widgets/blog_detail_page_comment_section.dart';
import 'package:kuemele/features/blog/presentation/blog_detail_page/widgets/blog_detail_page_content.dart';
import 'package:kuemele/features/blog/presentation/blog_detail_page/widgets/blog_detail_page_sections.dart';
import 'package:kuemele/features/blog/presentation/models/blog_models.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/event_card/widgets/category_tag.dart';
import 'package:kuemele/shared/components/icons.dart';
import 'package:kuemele/shared/utils/conversion_utils.dart';
import 'package:kuemele/shared/widgets/kumele_asset_widget.dart';
import 'package:kuemele/features/blog/presentation/blog_detail_page/widgets/blog_detail_comments_list.dart';

class BlogDetailPageBody extends StatelessWidget {
  const BlogDetailPageBody({
    super.key,
    required this.blog,
    this.comments = const [],
    required this.isLoading,
    this.isCommentsLoading = false,
    this.isPostingComment = false,
    required this.commentController,
    this.onActionTap,
    this.onCommentSubmit,
    this.onReply,
  });

  final BlogPostModel blog;
  final List<BlogCommentModel> comments;
  final bool isLoading;
  final bool isCommentsLoading;
  final bool isPostingComment;
  final TextEditingController commentController;
  final ValueChanged<BlogDetailSocialAction>? onActionTap;
  final ValueChanged<String>? onCommentSubmit;
  final ValueChanged<BlogCommentModel>? onReply;

  @override
  Widget build(BuildContext context) {
    final parsedDate = ConversionUtils.parseDateTime(blog.createdAt);
    final formattedDate = parsedDate != null
        ? ConversionUtils.formatDateTime(parsedDate, 'dd MMMM, yyyy')
        : blog.createdAt;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: AspectRatio(
              aspectRatio: 16 / 10,
              child: KumeleAssetWidget(
                assetPath: blog.coverImage?.isNotEmpty == true
                    ? blog.coverImage!
                    : IconSet.blogDefaultImage,
                fit: BoxFit.cover,
                placeholder: Container(
                  color: ColorSet.bg2Color,
                  alignment: Alignment.center,
                  child: const Icon(Icons.image_outlined),
                ),
                errorWidget: Container(
                  color: ColorSet.bg2Color,
                  alignment: Alignment.center,
                  child: const Icon(Icons.broken_image_outlined),
                ),
              ),
            ),
          ),
          Gap(16.h),
          if (blog.hobbyCategory != null)
            Align(
              alignment: Alignment.centerLeft,
              child: CategoryTag(
                label: blog.hobbyCategory!.name,
                fontSize: 12.sp,
              ),
            ),
          if (blog.hobbyCategory != null) Gap(12.h),
          Text(
            blog.title,
            style: context.textTheme.headlineSmallBold.copyWith(
              color: ColorSet.textColor,
              height: 1.2,
            ),
          ),
          Gap(12.h),
          BlogDetailMetaRow(
            authorName: blog.author.displayName,
            dateLabel: formattedDate,
            readingTimeLabel: '${blog.readingTimeMinutes} min read',
          ),
          Gap(18.h),
          BlogDetailSocialActionsRow(
            likeCount: blog.likeCount,
            isLiked: blog.isLiked ?? false,
            onActionTap: onActionTap,
          ),
          Gap(18.h),
          BlogDetailContent(
            blog: blog,
            isLoading: isLoading,
          ),
          Gap(16.h),
          BlogDetailCommentSection(
            controller: commentController,
            isLoading: isPostingComment,
            onSubmit: onCommentSubmit,
          ),
          Gap(20.h),
          BlogDetailCommentsList(
            comments: comments,
            isLoading: isCommentsLoading,
            onReply: onReply,
          ),
        ],
      ),
    );
  }
}
