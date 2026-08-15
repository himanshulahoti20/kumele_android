import 'package:kuemele/features/blog/presentation/models/blog_models.dart';

abstract class BlogRepository {
  Future<List<BlogPostModel>> getBlogFeed({
    String? hobbyCategoryId,
    String sortBy = 'most_recent',
    int limit = 20,
  });

  Future<BlogPostModel> getBlogDetails(String id);

  Future<List<BlogCommentModel>> getBlogComments(String blogId,
      {int limit = 100});

  Future<void> postComment(String blogId, String content, {String? parentId});

  Future<void> toggleLike(String blogId);

  /// Requests a real share token/URL for [blogId] from the backend
  /// (POST /share/token) instead of building a URL locally.
  Future<String> getShareUrl(String blogId);
}
