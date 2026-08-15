import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/features/blog/presentation/blog_detail_page/widgets/blog_detail_page_comment_section.dart';
import 'package:kuemele/features/blog/presentation/models/blog_models.dart';
import 'package:kuemele/features/blog/presentation/blog_detail_page/widgets/blog_detail_comments_list.dart';

class BlogDetailPageBody extends StatelessWidget {
  const BlogDetailPageBody({
    super.key,
    this.comments = const [],
    this.isCommentsLoading = false,
    this.isPostingComment = false,
    required this.commentController,
    this.onCommentSubmit,
    this.onReply,
  });

  final List<BlogCommentModel> comments;
  final bool isCommentsLoading;
  final bool isPostingComment;
  final TextEditingController commentController;
  final ValueChanged<String>? onCommentSubmit;
  final ValueChanged<BlogCommentModel>? onReply;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
            onReply: onReply,
          ),
        ],
      ),
    );
  }
}
