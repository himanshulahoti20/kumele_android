import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/features/blog/presentation/blog_detail_page/widgets/blog_detail_page_body.dart';
import 'package:kuemele/features/blog/presentation/blog_detail_page/widgets/blog_detail_page_sections.dart';
import 'package:kuemele/features/blog/presentation/blog_detail_page/widgets/reply_dialog.dart';
import 'package:kuemele/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:kuemele/features/blog/presentation/models/blog_models.dart';
import 'package:kuemele/l10n/app_localizations.dart';
import 'package:kuemele/shared/base/base_page.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/widgets/mobile_header.dart';

class BlogDetailPage extends StatefulWidget implements BasePage {
  const BlogDetailPage({
    super.key,
    required this.blog,
    this.onActionTap,
  });

  final BlogPostModel blog;
  final ValueChanged<BlogDetailSocialAction>? onActionTap;

  @override
  String get screenName => 'BlogDetailPage';

  @override
  State<BlogDetailPage> createState() => _BlogDetailPageState();
}

class _BlogDetailPageState extends State<BlogDetailPage> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<BlogBloc>().add(BlogFetchDetails(widget.blog.id));
    context.read<BlogBloc>().add(BlogFetchComments(widget.blog.id));
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BlogBloc, BlogState>(
      listenWhen: (previous, current) =>
          previous.isPostingComment &&
          !current.isPostingComment &&
          current.errorMessage == null,
      listener: (context, state) {
        if (!mounted) return;
        InjectionHelper.snackBar
            .showSuccess(AppLocalizations.of(context)!.posted);
        _commentController.clear();
      },
      builder: (context, state) {
        final blog = state.blogDetailsCache[widget.blog.id] ?? widget.blog;
        final isLoading = state.isBlogDetailsLoading &&
            state.blogDetailsCache[widget.blog.id] == null;
        final comments = state.commentsCache[widget.blog.id] ?? [];
        final isCommentsLoading = state.isCommentsLoading &&
            state.commentsCache[widget.blog.id] == null;

        return Scaffold(
          backgroundColor: ColorSet.bg3Color,
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(16.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  MobileHeader(label: AppLocalizations.of(context)!.blogDetailsTitle),
                  Gap(16.h),
                  Expanded(
                    child: BlogDetailPageBody(
                      blog: blog,
                      comments: comments,
                      isLoading: isLoading,
                      isCommentsLoading: isCommentsLoading,
                      isPostingComment: state.isPostingComment,
                      commentController: _commentController,
                      onActionTap: (action) {
                        if (action == BlogDetailSocialAction.like) {
                          context.read<BlogBloc>().add(
                                BlogLikeToggled(widget.blog.id),
                              );
                          return;
                        }
                        widget.onActionTap?.call(action);
                      },
                      onCommentSubmit: (comment) {
                        context.read<BlogBloc>().add(
                              BlogPostComment(widget.blog.id, comment),
                            );
                      },
                      onReply: (comment) {
                        showReplyDialog(
                          context: context,
                          comment: comment,
                          onSubmit: (reply) {
                            context.read<BlogBloc>().add(
                                  BlogPostComment(
                                    widget.blog.id,
                                    reply,
                                    parentId: comment.parentId ?? comment.id,
                                  ),
                                );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
