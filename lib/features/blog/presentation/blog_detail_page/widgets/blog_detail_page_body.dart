import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/features/blog/presentation/blog_detail_page/widgets/blog_detail_page_comment_section.dart';
import 'package:kuemele/features/blog/presentation/blog_detail_page/widgets/blog_detail_page_content.dart';
import 'package:kuemele/features/blog/presentation/blog_detail_page/widgets/blog_detail_page_sections.dart';
import 'package:kuemele/features/blog/presentation/models/blog_models.dart';
import 'package:kuemele/features/blog/presentation/blog_detail_page/widgets/blog_detail_comments_list.dart';

class BlogDetailPageBody extends StatelessWidget {
  const BlogDetailPageBody({
    super.key,
    required this.blog,
    this.isBlogLoading = false,
    this.blogDetailsError,
    this.comments = const [],
    this.isCommentsLoading = false,
    this.commentsError,
    this.isPostingComment = false,
    required this.commentController,
    this.onCommentSubmit,
    this.onReply,
    this.onActionTap,
    this.onRetryBlog,
    this.onRetryComments,
    this.scrollController,
    this.commentsKey,
  });

  final BlogPostModel blog;
  final bool isBlogLoading;
  final String? blogDetailsError;
  final List<BlogCommentModel> comments;
  final bool isCommentsLoading;
  final String? commentsError;
  final bool isPostingComment;
  final TextEditingController commentController;
  final ValueChanged<String>? onCommentSubmit;
  final ValueChanged<BlogCommentModel>? onReply;
  final ValueChanged<BlogDetailSocialAction>? onActionTap;
  final VoidCallback? onRetryBlog;
  final VoidCallback? onRetryComments;
  final ScrollController? scrollController;
  final GlobalKey? commentsKey;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: scrollController,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          BlogDetailContent(
            blog: blog,
            isLoading: isBlogLoading,
            errorMessage: blogDetailsError,
            onRetry: onRetryBlog,
            onActionTap: onActionTap,
          ),
          Gap(28.h),
          Container(
            key: commentsKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                BlogDetailCommentSection(
                  controller: commentController,
                  isLoading: isPostingComment,
                  onSubmit: onCommentSubmit,
                ),
                Gap(28.h),
                BlogDetailCommentsList(
                  comments: comments,
                  isLoading: isCommentsLoading,
                  errorMessage: commentsError,
                  onRetry: onRetryComments,
                  onReply: onReply,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
