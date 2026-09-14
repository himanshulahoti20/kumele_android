import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/core/responsive/responsive.dart';
import 'package:kuemele/features/blog/presentation/blog_detail_page.dart';
import 'package:kuemele/features/blog/presentation/models/blog_models.dart';
import 'package:kuemele/features/blog/presentation/widgets/blog_category_filter_bar.dart';
import 'package:kuemele/features/blog/presentation/widgets/blog_header.dart';
import 'package:kuemele/features/blog/presentation/widgets/blog_post_card.dart';
import 'package:kuemele/features/blog/presentation/widgets/blog_search_bar.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:kuemele/l10n/app_localizations.dart';
import 'package:kuemele/shared/widgets/app_empty_state.dart';
import 'package:kuemele/shared/widgets/app_refresh_indicator.dart';
import 'package:skeletonizer/skeletonizer.dart';

class Blog extends StatefulWidget {
  const Blog({super.key});

  @override
  State<Blog> createState() => _BlogState();
}

class _BlogState extends State<Blog> {
  // Tablet-only: the iPad blog screen shows its detail view as a popup
  // overlaid on the grid instead of pushing a new route. On mobile this stays
  // null forever, since BlogPostCard falls back to its normal push behavior.
  BlogPostModel? _selectedBlog;

  @override
  Widget build(BuildContext context) {
    final isTablet = context.responsive.isTablet;

    return BlocBuilder<BlogBloc, BlogState>(
      builder: (context, state) {
        return Stack(
          children: [
            Scaffold(
              backgroundColor: ColorSet.bg3Color,
              body: SafeArea(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const BlogHeader(),
                      Gap(16.h),
                      if (isTablet)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: _BlogCategorySection(
                                state: state,
                                onSelected: (index) {
                                  context
                                      .read<BlogBloc>()
                                      .add(BlogSelectCategory(index));
                                },
                              ),
                            ),
                            Gap(16.w),
                            SizedBox(
                              width: context.responsive.screenSize.width * 0.3,
                              child: BlogSearchBar(
                                onChanged: (value) {
                                  context
                                      .read<BlogBloc>()
                                      .add(BlogSearchChanged(value));
                                },
                              ),
                            ),
                          ],
                        )
                      else ...[
                        _BlogCategorySection(
                          state: state,
                          onSelected: (index) {
                            context
                                .read<BlogBloc>()
                                .add(BlogSelectCategory(index));
                          },
                        ),
                        Gap(16.h),
                        BlogSearchBar(
                          onChanged: (value) {
                            context
                                .read<BlogBloc>()
                                .add(BlogSearchChanged(value));
                          },
                        ),
                      ],
                      Gap(20.h),
                      Expanded(
                        child: AppCleanRefresh(
                          onRefresh: () async {
                            context.read<BlogBloc>().add(const BlogRefresh());
                          },
                          child: _BlogFeedSection(
                            state: state,
                            onTapBlog: isTablet
                                ? (blog) => setState(() => _selectedBlog = blog)
                                : null,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (isTablet && _selectedBlog != null)
              _BlogDetailPopup(
                blog: _selectedBlog!,
                onClose: () => setState(() => _selectedBlog = null),
                onNavigate: (blog) => setState(() => _selectedBlog = blog),
              ),
          ],
        );
      },
    );
  }
}

/// Tablet-only popup: mirrors the iPad blog detail's `ZStack` overlay — a
/// rounded surface panel margined over the same screen background, instead
/// of a full pushed page.
class _BlogDetailPopup extends StatelessWidget {
  const _BlogDetailPopup({
    required this.blog,
    required this.onClose,
    required this.onNavigate,
  });

  final BlogPostModel blog;
  final VoidCallback onClose;
  final ValueChanged<BlogPostModel> onNavigate;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      // iOS BlogDetailView_iPad: ScrollView sits on "bgContent" (screen
      // background = Android bgColor), the card inside is "bgColor" (surface
      // = Android bg3Color) — opposite of the two ColorSet names.
      child: Container(
        color: ColorSet.bgColor,
        padding: EdgeInsets.symmetric(horizontal: 35.w, vertical: 15.h),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.r),
          child: BlogDetailPage(
            key: ValueKey(blog.id),
            blog: blog,
            onClose: onClose,
            onNavigate: onNavigate,
            backgroundColor: ColorSet.bg3Color,
          ),
        ),
      ),
    );
  }
}

class _BlogCategorySection extends StatelessWidget {
  const _BlogCategorySection({
    required this.state,
    required this.onSelected,
  });

  final BlogState state;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return BlogCategoryFilterBar(
      categories: state.categories,
      selectedIndex: state.selectedCategoryIndex,
      isLoading: state.isCategoriesLoading,
      onSelected: state.isBlogsLoading ? (_) {} : onSelected,
    );
  }
}

class _BlogFeedSection extends StatelessWidget {
  const _BlogFeedSection({
    required this.state,
    this.onTapBlog,
  });

  final BlogState state;

  /// Tablet-only: opens the blog in the popup overlay instead of BlogPostCard's
  /// default route push. Null on mobile.
  final ValueChanged<BlogPostModel>? onTapBlog;

  @override
  Widget build(BuildContext context) {
    if (state.status == BlogStatus.failure &&
        !state.isBlogsLoading &&
        state.blogs.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 48.h),
            child: Column(
              children: [
                Text(
                  state.errorMessage ?? 'Failed to load blogs.',
                  textAlign: TextAlign.center,
                  style: context.textTheme.bodyMedium.copyWith(
                    color: ColorSet.subTextColor,
                  ),
                ),
                TextButton(
                  onPressed: () => context.read<BlogBloc>().add(
                        const BlogRefresh(),
                      ),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ],
      );
    }

    var blogs = state.isBlogsLoading ? BlogPostModel.placeholders : state.blogs;
    if (!state.isBlogsLoading) {
      blogs = state.filteredBlogs;
    }

    final isTablet = context.responsive.isTablet;

    return Skeletonizer(
      enabled: state.isBlogsLoading,
      child: blogs.isEmpty
          ? ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 48.h),
                  child: AppEmptyState(
                    title: AppLocalizations.of(context)!.blogEmptyStateTitle,
                    description:
                        AppLocalizations.of(context)!.blogEmptyStateDescription,
                  ),
                ),
              ],
            )
          : isTablet
              // Matches the iPad's LazyVGrid: two flexible-width columns whose
              // row height follows the card's own content instead of a forced
              // aspect ratio (which left tall, mostly-empty tiles).
              ? ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.only(top: 4.h),
                  itemCount: (blogs.length / 2).ceil(),
                  itemBuilder: (context, rowIndex) {
                    final firstIndex = rowIndex * 2;
                    final secondIndex = firstIndex + 1;
                    return Padding(
                      padding: EdgeInsets.only(bottom: 16.h),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: BlogPostCard(
                              blog: blogs[firstIndex],
                              onTap: onTapBlog == null
                                  ? null
                                  : () => onTapBlog!(blogs[firstIndex]),
                            ),
                          ),
                          Gap(16.w),
                          Expanded(
                            child: secondIndex < blogs.length
                                ? BlogPostCard(
                                    blog: blogs[secondIndex],
                                    onTap: onTapBlog == null
                                        ? null
                                        : () => onTapBlog!(blogs[secondIndex]),
                                  )
                                : const SizedBox.shrink(),
                          ),
                        ],
                      ),
                    );
                  },
                )
              : ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.only(top: 4.h),
                  children: List.generate(
                    blogs.length,
                    (index) => Padding(
                      padding: EdgeInsets.only(bottom: 16.h),
                      child: BlogPostCard(
                        blog: blogs[index],
                      ),
                    ),
                  ),
                ),
    );
  }
}
