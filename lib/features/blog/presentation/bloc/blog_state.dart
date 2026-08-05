import 'package:kuemele/features/blog/presentation/models/blog_models.dart';

enum BlogStatus { initial, loading, loaded, failure }

class BlogState {
  final List<String> categoryNames;
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
  final String? errorMessage;

  const BlogState({
    this.categoryNames = const [],
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
    this.errorMessage,
  });

  bool get isFetching => isCategoriesLoading || isBlogsLoading;

  List<BlogPostModel> get filteredBlogs {
    final query = searchQuery.trim().toLowerCase();
    if (query.isEmpty) {
      return blogs;
    }

    return blogs
        .where((blog) => blog.title.toLowerCase().contains(query))
        .toList();
  }

  BlogState copyWith({
    List<String>? categoryNames,
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
    String? errorMessage,
  }) {
    return BlogState(
      categoryNames: categoryNames ?? this.categoryNames,
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
      errorMessage: errorMessage,
    );
  }
}
