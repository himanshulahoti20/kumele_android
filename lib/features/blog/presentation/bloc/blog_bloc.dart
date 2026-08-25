import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kuemele/features/blog/domain/repositories/blog_repository.dart';
import 'package:kuemele/features/blog/presentation/bloc/blog_event.dart';
import 'package:kuemele/features/blog/presentation/bloc/blog_state.dart';
import 'package:kuemele/features/blog/presentation/models/blog_models.dart';
import 'package:kuemele/features/profile/presentation/profileset/data/models/hobby_category_model.dart';
import 'package:kuemele/features/profile/presentation/profileset/domain/repositories/hobbies_repository.dart';
import 'package:kuemele/shared/services/api_service/api_exception.dart';

export 'blog_event.dart';
export 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  BlogBloc({
    required HobbiesRepository hobbiesRepository,
    required BlogRepository blogRepository,
  })  : _hobbiesRepository = hobbiesRepository,
        _blogRepository = blogRepository,
        super(const BlogState()) {
    on<BlogInit>(_onInit);
    on<BlogRefresh>(_onRefresh);
    on<BlogSearchChanged>(_onSearchChanged);
    on<BlogSelectCategory>(_onSelectCategory);
    on<BlogFetchDetails>(_onFetchDetails);
    on<BlogPostComment>(_onPostComment);
    on<BlogFetchComments>(_onFetchComments);
    on<BlogLikeToggled>(_onLikeToggled);
  }

  final HobbiesRepository _hobbiesRepository;
  final BlogRepository _blogRepository;

  List<HobbyCategoryModel> _categories = [];
  final Set<String> _loadingBlogDetails = {};

  Future<List<BlogPostModel>> _loadBlogsForSelectedCategory(
    int selectedCategoryIndex,
  ) {
    String? hobbyCategoryId;
    if (selectedCategoryIndex > 0 &&
        selectedCategoryIndex - 1 < _categories.length) {
      hobbyCategoryId = _categories[selectedCategoryIndex - 1].id;
    }

    return _blogRepository.getBlogFeed(hobbyCategoryId: hobbyCategoryId);
  }

  Future<void> _onInit(
    BlogInit event,
    Emitter<BlogState> emit,
  ) async {
    emit(state.copyWith(
      status: BlogStatus.loading,
      isCategoriesLoading: true,
      isBlogsLoading: true,
      errorMessage: null,
    ));

    try {
      _categories = await _hobbiesRepository.getHobbyCategories();

      final blogs = await _loadBlogsForSelectedCategory(0);

      emit(state.copyWith(
        categories: _categories,
        blogs: blogs,
        selectedCategoryIndex: 0,
        status: BlogStatus.loaded,
        isCategoriesLoading: false,
        isBlogsLoading: false,
      ));
    } on ApiException catch (e) {
      emit(state.copyWith(
        status: BlogStatus.failure,
        errorMessage: e.error ?? 'Failed to load blogs.',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: BlogStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onRefresh(
    BlogRefresh event,
    Emitter<BlogState> emit,
  ) async {
    emit(state.copyWith(
      status: BlogStatus.loading,
      isBlogsLoading: true,
      errorMessage: null,
    ));

    try {
      final blogs = await _loadBlogsForSelectedCategory(
        state.selectedCategoryIndex,
      );

      emit(state.copyWith(
        blogs: blogs,
        status: BlogStatus.loaded,
        isBlogsLoading: false,
      ));
    } on ApiException catch (e) {
      emit(state.copyWith(
        status: BlogStatus.failure,
        isBlogsLoading: false,
        errorMessage: e.error ?? 'Failed to refresh blogs.',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: BlogStatus.failure,
        isBlogsLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onSearchChanged(
    BlogSearchChanged event,
    Emitter<BlogState> emit,
  ) {
    emit(state.copyWith(searchQuery: event.query));
  }

  Future<void> _onSelectCategory(
    BlogSelectCategory event,
    Emitter<BlogState> emit,
  ) async {
    emit(state.copyWith(
      selectedCategoryIndex: event.index,
      status: BlogStatus.loading,
      isBlogsLoading: true,
      errorMessage: null,
    ));

    try {
      final blogs = await _loadBlogsForSelectedCategory(event.index);

      emit(state.copyWith(
        blogs: blogs,
        status: BlogStatus.loaded,
        isBlogsLoading: false,
      ));
    } on ApiException catch (e) {
      emit(state.copyWith(
        status: BlogStatus.failure,
        isBlogsLoading: false,
        errorMessage: e.error ?? 'Failed to load blogs for category.',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: BlogStatus.failure,
        isBlogsLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onFetchDetails(
    BlogFetchDetails event,
    Emitter<BlogState> emit,
  ) async {
    if (state.blogDetailsCache.containsKey(event.blogId) ||
        !_loadingBlogDetails.add(event.blogId)) {
      return; // Already cached
    }

    emit(state.copyWith(
      isBlogDetailsLoading: true,
      blogDetailsError: null,
      errorMessage: null,
    ));

    try {
      final blogDetails = await _blogRepository.getBlogDetails(event.blogId);
      final newCache = Map<String, BlogPostModel>.from(state.blogDetailsCache);
      newCache[event.blogId] = blogDetails;

      emit(state.copyWith(
        isBlogDetailsLoading: false,
        blogDetailsCache: newCache,
        blogDetailsError: null,
      ));
    } on ApiException catch (e) {
      emit(state.copyWith(
        isBlogDetailsLoading: false,
        blogDetailsError: e.error ?? 'Failed to load blog details.',
        errorMessage: e.error ?? 'Failed to load blog details.',
      ));
    } catch (e) {
      emit(state.copyWith(
        isBlogDetailsLoading: false,
        blogDetailsError: e.toString(),
        errorMessage: e.toString(),
      ));
    } finally {
      _loadingBlogDetails.remove(event.blogId);
    }
  }

  Future<void> _onPostComment(
    BlogPostComment event,
    Emitter<BlogState> emit,
  ) async {
    final isReply = event.parentId != null;
    emit(state.copyWith(
      isPostingComment: !isReply ? true : state.isPostingComment,
      isReplyingComment: isReply ? true : state.isReplyingComment,
      commentError: null,
      errorMessage: null,
    ));

    try {
      final newComment = await _blogRepository.postComment(
        event.blogId,
        event.content,
        parentId: event.parentId,
      );

      final existingComments = state.commentsCache[event.blogId] ?? const [];
      final updatedComments = insertCommentReply(
        existingComments,
        newComment,
        parentId: event.parentId,
      );
      final newCommentsCache =
          Map<String, List<BlogCommentModel>>.from(state.commentsCache)
            ..[event.blogId] = updatedComments;

      emit(state.copyWith(
        isPostingComment: !isReply ? false : state.isPostingComment,
        isReplyingComment: isReply ? false : state.isReplyingComment,
        commentsCache: newCommentsCache,
        commentError: null,
      ));
    } on ApiException catch (e) {
      emit(state.copyWith(
        isPostingComment: !isReply ? false : state.isPostingComment,
        isReplyingComment: isReply ? false : state.isReplyingComment,
        commentError: e.error ?? 'Failed to post comment.',
        errorMessage: e.error ?? 'Failed to post comment.',
      ));
    } catch (e) {
      emit(state.copyWith(
        isPostingComment: !isReply ? false : state.isPostingComment,
        isReplyingComment: isReply ? false : state.isReplyingComment,
        commentError: e.toString(),
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onFetchComments(
    BlogFetchComments event,
    Emitter<BlogState> emit,
  ) async {
    emit(state.copyWith(
      isCommentsLoading: true,
      commentsError: null,
      errorMessage: null,
    ));

    try {
      final comments = await _blogRepository.getBlogComments(event.blogId);
      final newCache =
          Map<String, List<BlogCommentModel>>.from(state.commentsCache);
      newCache[event.blogId] = comments;

      emit(state.copyWith(
        isCommentsLoading: false,
        commentsCache: newCache,
        commentsError: null,
      ));
    } on ApiException catch (e) {
      emit(state.copyWith(
        isCommentsLoading: false,
        commentsError: e.error ?? 'Failed to load comments.',
        errorMessage: e.error ?? 'Failed to load comments.',
      ));
    } catch (e) {
      emit(state.copyWith(
        isCommentsLoading: false,
        commentsError: e.toString(),
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onLikeToggled(
    BlogLikeToggled event,
    Emitter<BlogState> emit,
  ) async {
    final current = state.blogDetailsCache[event.blogId] ??
        state.blogs.firstWhereOrNull((blog) => blog.id == event.blogId);
    if (current == null) return;

    final wasLiked = current.isLiked ?? false;
    final optimistic = current.copyWithLike(
      isLiked: !wasLiked,
      likeCount: current.likeCount + (wasLiked ? -1 : 1),
    );

    emit(state.copyWith(
      blogDetailsCache: _applyToCache(state.blogDetailsCache, optimistic),
      blogs: _applyToList(state.blogs, optimistic),
    ));

    try {
      await _blogRepository.toggleLike(event.blogId);
    } catch (_) {
      emit(state.copyWith(
        blogDetailsCache: _applyToCache(state.blogDetailsCache, current),
        blogs: _applyToList(state.blogs, current),
      ));
    }
  }

  Map<String, BlogPostModel> _applyToCache(
    Map<String, BlogPostModel> cache,
    BlogPostModel blog,
  ) {
    if (!cache.containsKey(blog.id)) return cache;
    return Map<String, BlogPostModel>.from(cache)..[blog.id] = blog;
  }

  List<BlogPostModel> _applyToList(
      List<BlogPostModel> blogs, BlogPostModel blog) {
    final index = blogs.indexWhere((b) => b.id == blog.id);
    if (index == -1) return blogs;
    return List<BlogPostModel>.from(blogs)..[index] = blog;
  }
}
