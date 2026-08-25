import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/features/blog/presentation/blog_detail_page/widgets/blog_detail_page_body.dart';
import 'package:kuemele/features/blog/presentation/blog_detail_page/widgets/blog_share_bottom_sheet.dart';
import 'package:kuemele/features/blog/presentation/blog_detail_page/widgets/reply_dialog.dart';
import 'package:kuemele/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:kuemele/features/blog/presentation/blog_detail_page/widgets/blog_detail_page_sections.dart';
import 'package:kuemele/features/blog/presentation/models/blog_models.dart';
import 'package:kuemele/l10n/app_localizations.dart';
import 'package:kuemele/navigation/app_routes.dart';
import 'package:kuemele/shared/base/base_page.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/widgets/mobile_header.dart';
import 'package:url_launcher/url_launcher.dart';

class BlogDetailPage extends StatefulWidget implements BasePage {
  const BlogDetailPage({
    super.key,
    required this.blog,
    this.openComments = false,
  });

  final BlogPostModel blog;
  final bool openComments;

  @override
  String get screenName => 'BlogDetailPage';

  @override
  State<BlogDetailPage> createState() => _BlogDetailPageState();
}

class _BlogDetailPageState extends State<BlogDetailPage> {
  final TextEditingController _commentController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _commentsKey = GlobalKey();
  bool _didScrollToComments = false;

  @override
  void initState() {
    super.initState();
    context.read<BlogBloc>().add(BlogFetchDetails(widget.blog.id));
    context.read<BlogBloc>().add(BlogFetchComments(widget.blog.id));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToCommentsIfNeeded();
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BlogBloc, BlogState>(
      listenWhen: (previous, current) =>
          (previous.isPostingComment && !current.isPostingComment) ||
          (widget.openComments &&
              previous.isBlogDetailsLoading &&
              !current.isBlogDetailsLoading &&
              current.blogDetailsError == null &&
              current.blogDetailsCache.containsKey(widget.blog.id)),
      listener: (context, state) {
        if (!mounted) return;

        if (widget.openComments &&
            !_didScrollToComments &&
            state.blogDetailsError == null &&
            state.blogDetailsCache.containsKey(widget.blog.id)) {
          _scrollToCommentsIfNeeded();
          return;
        }

        if (state.isPostingComment) return;
        if (state.commentError != null) {
          InjectionHelper.snackBar.showError(state.commentError!);
          return;
        }

        InjectionHelper.snackBar
            .showSuccess(AppLocalizations.of(context)!.posted);
        _commentController.clear();
      },
      builder: (context, state) {
        final blog = state.blogDetailsCache[widget.blog.id] ?? widget.blog;
        final isBlogLoading = state.isBlogDetailsLoading &&
            state.blogDetailsCache[widget.blog.id] == null;
        final comments = state.commentsCache[widget.blog.id] ?? [];
        final isCommentsLoading = state.isCommentsLoading &&
            state.commentsCache[widget.blog.id] == null;
        final blogs =
            state.filteredBlogs.isNotEmpty ? state.filteredBlogs : state.blogs;
        final currentIndex =
            blogs.indexWhere((blog) => blog.id == widget.blog.id);
        final previousBlog = currentIndex > 0 ? blogs[currentIndex - 1] : null;
        final nextBlog = currentIndex >= 0 && currentIndex < blogs.length - 1
            ? blogs[currentIndex + 1]
            : null;

        return Scaffold(
          backgroundColor: ColorSet.bg3Color,
          bottomNavigationBar: _BlogDetailPager(
            onPrevious: previousBlog == null
                ? null
                : () => _openBlog(context, previousBlog),
            onNext:
                nextBlog == null ? null : () => _openBlog(context, nextBlog),
          ),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const MobileHeader(label: ''),
                  SizedBox(height: 48.h),
                  Expanded(
                    child: BlogDetailPageBody(
                      blog: blog,
                      isBlogLoading: isBlogLoading,
                      blogDetailsError: state.blogDetailsError,
                      comments: comments,
                      isCommentsLoading: isCommentsLoading,
                      commentsError: state.commentsError,
                      isPostingComment: state.isPostingComment,
                      commentController: _commentController,
                      scrollController: _scrollController,
                      commentsKey: _commentsKey,
                      onRetryBlog: () => context
                          .read<BlogBloc>()
                          .add(BlogFetchDetails(widget.blog.id)),
                      onRetryComments: () => context
                          .read<BlogBloc>()
                          .add(BlogFetchComments(widget.blog.id)),
                      onActionTap: (action) =>
                          _handleSocialAction(context, blog, action),
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
                                    parentId: comment.id,
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

  void _scrollToCommentsIfNeeded() {
    if (!widget.openComments || _didScrollToComments || !mounted) return;
    final blogState = context.read<BlogBloc>().state;
    if (blogState.isBlogDetailsLoading ||
        !blogState.blogDetailsCache.containsKey(widget.blog.id)) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted || _didScrollToComments) return;
      final targetContext = _commentsKey.currentContext;
      if (targetContext == null) return;

      _didScrollToComments = true;
      await Scrollable.ensureVisible(
        targetContext,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeOut,
        alignment: 0.05,
      );
    });
  }

  Future<void> _handleSocialAction(
    BuildContext context,
    BlogPostModel blog,
    BlogDetailSocialAction action,
  ) async {
    if (action == BlogDetailSocialAction.like) {
      context.read<BlogBloc>().add(BlogLikeToggled(blog.id));
      return;
    }

    if (action == BlogDetailSocialAction.share) {
      await BlogShareBottomSheet.show(context, blog);
      return;
    }

    final url = switch (action) {
      BlogDetailSocialAction.youtube => blog.youtubeLink,
      BlogDetailSocialAction.facebook => blog.facebookLink,
      BlogDetailSocialAction.instagram => blog.instagramLink,
      BlogDetailSocialAction.pinterest => blog.pinterestLink,
      BlogDetailSocialAction.twitter => blog.twitterLink,
      BlogDetailSocialAction.like || BlogDetailSocialAction.share => null,
    };

    if (url != null && url.isNotEmpty) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }

  void _openBlog(BuildContext context, BlogPostModel blog) {
    context.read<BlogBloc>().add(BlogFetchDetails(blog.id));
    context.pushReplacement(
      AppRoutes.blogDetail,
      extra: BlogDetailRouteArgs(blog: blog),
    );
  }
}

class _BlogDetailPager extends StatelessWidget {
  const _BlogDetailPager({
    this.onPrevious,
    this.onNext,
  });

  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorSet.bg3Color,
      padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 10.h),
      child: Row(
        children: [
          TextButton.icon(
            onPressed: onPrevious,
            icon: Opacity(
              opacity: onPrevious == null ? 0.38 : 1,
              child: Transform.flip(
                flipX: ColorSet.isDarkMode,
                child: Image.asset(
                  ColorSet.isDarkMode
                      ? 'assets/icons/blogs/arrow_right_dark.png'
                      : 'assets/icons/blogs/arrow_left_light.png',
                  width: 28.r,
                  height: 28.r,
                  excludeFromSemantics: true,
                ),
              ),
            ),
            label: Text(AppLocalizations.of(context)!.blogPostPreviousLabel),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFFBCBCBC),
              disabledForegroundColor: const Color(0xFFBCBCBC),
              textStyle: context.textTheme.bodySmall.copyWith(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
              ),
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
          const Spacer(),
          TextButton(
            onPressed: onNext,
            style: TextButton.styleFrom(
              foregroundColor: onNext == null
                  ? ColorSet.subTextColor
                  : ColorSet.specialBlueColor,
              textStyle: context.textTheme.bodySmall.copyWith(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
              ),
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(AppLocalizations.of(context)!.next),
                Opacity(
                  opacity: onNext == null ? 0.38 : 1,
                  child: Image.asset(
                    ColorSet.isDarkMode
                        ? 'assets/icons/blogs/arrow_right_dark.png'
                        : 'assets/icons/blogs/arrow_right_light.png',
                    width: 28.r,
                    height: 28.r,
                    excludeFromSemantics: true,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
