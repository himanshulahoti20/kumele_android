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
}
