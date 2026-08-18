import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
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
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BlogBloc, BlogState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: ColorSet.bg3Color,
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const BlogHeader(),
                  Gap(16.h),
                  _BlogCategorySection(
                    state: state,
                    onSelected: (index) {
                      context.read<BlogBloc>().add(BlogSelectCategory(index));
                    },
                  ),
                  Gap(16.h),
                  BlogSearchBar(
                    onChanged: (value) {
                      context.read<BlogBloc>().add(BlogSearchChanged(value));
                    },
                  ),
                  Gap(20.h),
                  Expanded(
                    child: AppCleanRefresh(
                      onRefresh: () async {
                        context.read<BlogBloc>().add(const BlogRefresh());
                      },
                      child: _BlogFeedSection(
                        state: state,
                      ),
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
  });

  final BlogState state;

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

    return Skeletonizer(
      enabled: state.isBlogsLoading,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.only(top: 4.h),
        children: [
          if (blogs.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 48.h),
              child: AppEmptyState(
                title: AppLocalizations.of(context)!.blogEmptyStateTitle,
                description:
                    AppLocalizations.of(context)!.blogEmptyStateDescription,
              ),
            )
          else
            ...List.generate(
              blogs.length,
              (index) => Padding(
                padding: EdgeInsets.only(bottom: 16.h),
                child: BlogPostCard(
                  blog: blogs[index],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
