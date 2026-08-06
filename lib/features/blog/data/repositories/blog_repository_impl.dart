import 'package:kuemele/features/blog/domain/repositories/blog_repository.dart';
import 'package:kuemele/features/blog/presentation/models/blog_models.dart';
import 'package:kuemele/shared/services/api_service/api_service.dart';
import 'package:kuemele/shared/services/api_service/generated/generated_api_catalog_lookup.dart';
import 'package:kuemele/shared/utils/utils.dart';

class BlogRepositoryImpl implements BlogRepository {
  @override
  Future<List<BlogPostModel>> getBlogFeed({
    String? hobbyCategoryId,
    String sortBy = 'most_recent',
    int limit = 20,
  }) async {
    final api = GeneratedApiOperations.getBlogFeed;

    final params = <String, dynamic>{
      'sortBy': sortBy,
      'limit': limit,
      if (hobbyCategoryId != null && hobbyCategoryId.isNotEmpty)
        'hobbyCategoryId': hobbyCategoryId,
    };

    final response = await ApiService.callRequest(
      api.method.toRequestMethod(),
      api.path,
      api.operationId,
      params: params,
    );

    return ApiService.handleResponse<List<BlogPostModel>>(
          () =>
              Utils.jsonToList(
                ApiService.extractList(response),
                BlogPostModel.fromJson,
              ) ??
              [],
        ) ??
        [];
  }

  @override
  Future<BlogPostModel> getBlogDetails(String id) async {
    final api = GeneratedApiOperations.getBlogDetails;
    final path = GeneratedApiOperations.resolvePath(
      api,
      pathValues: {'id': id},
    );

    final response = await ApiService.callRequest(
      api.method.toRequestMethod(),
      path,
      api.operationId,
    );

    return ApiService.handleResponse<BlogPostModel>(() {
          final data = ApiService.extractMap(response);
          if (data.isEmpty) {
            throw Exception('Failed to load blog details');
          }
          return BlogPostModel.fromJson(data);
        }) ??
        (throw Exception('Failed to load blog details'));
  }

  @override
  Future<List<BlogCommentModel>> getBlogComments(String blogId,
      {int limit = 100}) async {
    final api =
        GeneratedApiOperations.require('BlogsController_getComments_v1');
    final path = GeneratedApiOperations.resolvePath(
      api,
      pathValues: {'id': blogId},
    );

    final response = await ApiService.callRequest(
      api.method.toRequestMethod(),
      path,
      api.operationId,
      params: {'limit': limit},
    );

    return ApiService.handleResponse<List<BlogCommentModel>>(
          () =>
              Utils.jsonToList(
                ApiService.extractList(response),
                BlogCommentModel.fromJson,
              ) ??
              [],
        ) ??
        [];
  }

  @override
  Future<void> postComment(String blogId, String content,
      {String? parentId}) async {
    final api = GeneratedApiOperations.postBlogComment;
    final path = GeneratedApiOperations.resolvePath(
      api,
      pathValues: {'id': blogId},
    );

    final body = <String, dynamic>{'content': content};
    if (parentId != null) {
      body['parentId'] = parentId;
    }

    await ApiService.callRequest(
      api.method.toRequestMethod(),
      path,
      api.operationId,
      body: body,
    );
  }

  @override
  Future<void> toggleLike(String blogId) async {
    final api = GeneratedApiOperations.require('BlogsController_likeBlog_v1');
    final path = GeneratedApiOperations.resolvePath(
      api,
      pathValues: {'id': blogId},
    );

    await ApiService.callRequest(
      api.method.toRequestMethod(),
      path,
      api.operationId,
    );
  }
}
