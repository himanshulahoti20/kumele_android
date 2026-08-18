import 'package:kuemele/features/blog/presentation/models/blog_models.dart';
import 'package:kuemele/features/profile/presentation/profileset/data/models/hobby_category_model.dart';

enum BlogStatus { initial, loading, loaded, failure }

class BlogState {
  static const _unset = Object();

  final List<HobbyCategoryModel> categories;
  final List<BlogPostModel> blogs;
  final String searchQuery;
  final int selectedCategoryIndex;
  final BlogStatus status;
  final bool isCategoriesLoading;
  final bool isBlogsLoading;
  final bool isBlogDetailsLoading;
  final bool isPostingComment;
  final bool isReplyingComment;
  final bool isCommentsLoading;
  final Map<String, BlogPostModel> blogDetailsCache;
  final Map<String, List<BlogCommentModel>> commentsCache;
  final String? blogDetailsError;
  final String? commentsError;
  final String? commentError;
  final String? errorMessage;

  const BlogState({
    this.categories = const [],
    this.blogs = const [],
    this.searchQuery = '',
    this.selectedCategoryIndex = 0,
    this.status = BlogStatus.initial,
    this.isCategoriesLoading = false,
    this.isBlogsLoading = false,
    this.isBlogDetailsLoading = false,
    this.isPostingComment = false,
    this.isReplyingComment = false,
    this.isCommentsLoading = false,
    this.blogDetailsCache = const {},
    this.commentsCache = const {},
    this.blogDetailsError,
    this.commentsError,
    this.commentError,
    this.errorMessage,
  });

  bool get isFetching => isCategoriesLoading || isBlogsLoading;

  List<BlogPostModel> get filteredBlogs {
    final query = searchQuery.trim().toLowerCase();
    if (query.isEmpty) {
      return blogs;
    }

    return blogs
        .where(
          (blog) =>
              blog.title.toLowerCase().contains(query) ||
              blog.excerpt.toLowerCase().contains(query) ||
              blog.author.displayName.toLowerCase().contains(query),
        )
        .toList();
  }

  BlogState copyWith({
    List<HobbyCategoryModel>? categories,
    List<BlogPostModel>? blogs,
    String? searchQuery,
    int? selectedCategoryIndex,
    BlogStatus? status,
    bool? isCategoriesLoading,
    bool? isBlogsLoading,
    bool? isBlogDetailsLoading,
    bool? isPostingComment,
    bool? isReplyingComment,
    bool? isCommentsLoading,
    Map<String, BlogPostModel>? blogDetailsCache,
    Map<String, List<BlogCommentModel>>? commentsCache,
    Object? blogDetailsError = _unset,
    Object? commentsError = _unset,
    Object? commentError = _unset,
    String? errorMessage,
  }) {
    return BlogState(
      categories: categories ?? this.categories,
      blogs: blogs ?? this.blogs,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategoryIndex:
          selectedCategoryIndex ?? this.selectedCategoryIndex,
      status: status ?? this.status,
      isCategoriesLoading: isCategoriesLoading ?? this.isCategoriesLoading,
      isBlogsLoading: isBlogsLoading ?? this.isBlogsLoading,
      isBlogDetailsLoading: isBlogDetailsLoading ?? this.isBlogDetailsLoading,
      isPostingComment: isPostingComment ?? this.isPostingComment,
      isReplyingComment: isReplyingComment ?? this.isReplyingComment,
      isCommentsLoading: isCommentsLoading ?? this.isCommentsLoading,
      blogDetailsCache: blogDetailsCache ?? this.blogDetailsCache,
      commentsCache: commentsCache ?? this.commentsCache,
      blogDetailsError: identical(blogDetailsError, _unset)
          ? this.blogDetailsError
          : blogDetailsError as String?,
      commentsError: identical(commentsError, _unset)
          ? this.commentsError
          : commentsError as String?,
      commentError: identical(commentError, _unset)
          ? this.commentError
          : commentError as String?,
      errorMessage: errorMessage,
    );
  }
}
