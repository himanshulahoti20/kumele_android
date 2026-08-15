import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/features/home/cubit/home_page_cubit.dart';
import 'package:kuemele/features/home/presentation/main_navigation_page.dart';
import 'package:kuemele/features/blog/presentation/blog_detail_page/widgets/blog_detail_page_body.dart';
import 'package:kuemele/features/blog/presentation/blog_detail_page/widgets/reply_dialog.dart';
import 'package:kuemele/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:kuemele/features/blog/presentation/models/blog_models.dart';
import 'package:kuemele/l10n/app_localizations.dart';
import 'package:kuemele/navigation/app_routes.dart';
import 'package:kuemele/shared/base/base_page.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/widgets/mobile_header.dart';

class BlogDetailPage extends StatefulWidget implements BasePage {
  const BlogDetailPage({
    super.key,
    required this.blog,
  });

  final BlogPostModel blog;

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
          bottomNavigationBar: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _BlogDetailPager(
                onPrevious: previousBlog == null
                    ? null
                    : () => _openBlog(context, previousBlog),
                onNext: nextBlog == null
                    ? null
                    : () => _openBlog(context, nextBlog),
              ),
              BlocBuilder<HomePageCubit, HomePageState>(
                bloc: InjectionHelper.homePageCubit,
                builder: (context, navState) {
                  return PhoneBottomNavigationBar(
                    tabs: HomeTabType.mobileTabs,
                    selectedTab: HomeTabType.blog,
                    unreadNotifications: navState.unreadNotifications,
                    unreadChats: navState.unreadChats,
                    onTapTab: (type) {
                      InjectionHelper.homePageCubit.onTapTab(context, type);
                      if (type != HomeTabType.more) {
                        context.go(AppRoutes.home);
                      }
                    },
                  );
                },
              ),
            ],
          ),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(16.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const MobileHeader(label: ''),
                  Gap(16.h),
                  Expanded(
                    child: BlogDetailPageBody(
                      comments: comments,
                      isCommentsLoading: isCommentsLoading,
                      isPostingComment: state.isPostingComment,
                      commentController: _commentController,
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
            icon: Icon(Icons.chevron_left, size: 28.r),
            label: Text(AppLocalizations.of(context)!.blogPostPreviousLabel),
            style: TextButton.styleFrom(
              foregroundColor: onPrevious == null
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
                Icon(Icons.chevron_right, size: 28.r),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
