import 'package:dio/dio.dart';
import 'package:kuemele/shared/services/api_service/api_config.dart';
import 'package:kuemele/shared/services/api_service/api_exception.dart';
import 'package:kuemele/shared/services/api_service/api_service.dart';

class ChatbotRepo {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConfig.aimlBaseUrl,
      connectTimeout: const Duration(milliseconds: ApiConfig.timeout),
      contentType: Headers.jsonContentType,
    ),
  );

  static Future<String> ask({
    required String userId,
    required String query,
  }) async {
    try {
      final response = await _dio.post<dynamic>(
        '/chatbot/ask',
        data: {
          'user_id': userId,
          'userId': userId,
          'query': query,
          'language': 'en',
          'top_k': 5,
        },
        options: Options(headers: ApiService.getHeader(false)),
      );
      final data = response.data;
      if (data is Map) {
        final answer = data['answer'] ?? data['response'] ?? data['message'];
        if (answer != null && answer.toString().trim().isNotEmpty) {
          return answer.toString().trim();
        }
      }
      throw ApiException(error: ApiErrorMessage.APP_PARSE_ERROR);
    } on DioException catch (error) {
      throw ApiException(
        error: ApiErrorExtractor.messageFrom(error.response?.data) ??
            ApiErrorMessage.APP_API_ERROR,
        statusCode: error.response?.statusCode,
      );
    }
  }
}
