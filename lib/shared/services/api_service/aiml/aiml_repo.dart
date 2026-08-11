import 'package:dio/dio.dart';
import 'package:kuemele/shared/models/aiml_models.dart';
import 'package:kuemele/shared/services/api_service/api_config.dart';
import 'package:kuemele/shared/services/api_service/api_exception.dart';
import 'package:kuemele/shared/services/api_service/api_service.dart';

class AimlRepo {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConfig.aimlBaseUrl,
      connectTimeout: const Duration(milliseconds: ApiConfig.timeout),
      contentType: Headers.jsonContentType,
    ),
  );

  static Future<AimlModerationResult> moderateText({
    required String entityType,
    required String entityId,
    required String text,
  }) async {
    final data = await _postMap('/moderation/analyze', {
      'entity_type': entityType,
      'entity_id': entityId,
      'text': text,
    });
    return AimlModerationResult.fromJson(data);
  }

  static Future<AimlAttendancePrediction> predictAttendance({
    required String hobby,
    required String location,
    required String eventDateTime,
    required bool isPaid,
    required int capacity,
    String? eventId,
  }) async {
    final data = await _postMap('/predict/attendance', {
      'event_id': eventId,
      'hobby': hobby,
      'location': location,
      'event_datetime': eventDateTime,
      'is_paid': isPaid,
      'capacity': capacity,
    });
    return AimlAttendancePrediction.fromJson(data);
  }

  static Future<AimlPricingAdvice> optimisePricing({
    required String eventId,
    required String hostId,
    required String category,
    required String location,
    required int capacity,
    required String eventDate,
    required int basePrice,
  }) async {
    final data = await _getMap('/pricing/optimise', {
      'event_id': eventId,
      'host_id': hostId,
      'category': category,
      'location': location,
      'capacity': capacity,
      'event_date': eventDate,
      'base_price': basePrice,
    });
    return AimlPricingAdvice.fromJson(data);
  }

  static Future<AimlRewardsSuggestion> getRewardsSuggestion(
    String userId,
  ) async {
    final data = await _getMap('/rewards/suggestion', {'user_id': userId});
    return AimlRewardsSuggestion.fromJson(data);
  }

  static Future<Map<dynamic, dynamic>> getEventTranslation({
    required String eventId,
    required String language,
  }) {
    return _getMap('/content-translations/event/$eventId', {
      'language': language,
    });
  }

  // NOTE: AimlRepo is for QA, model testing, and backend integration checks ONLY.
  // Per George's Primary Rule, production frontend UI must NOT call this.
  // Production code should call the backend which internally delegates to AI/ML.
  static Future<List<AimlHobbyRecommendation>> getRecommendedHobbies({
    required String userId,
    int limit = 5,
  }) async {
    final data = await _getMap('/recommendations/hobbies', {
      'user_id': userId,
      'limit': limit,
    });
    return (data['recommended_hobbies'] as List? ?? const [])
        .whereType<Map>()
        .map(AimlHobbyRecommendation.fromJson)
        .toList();
  }

  static Future<Map<dynamic, dynamic>> _postMap(
    String path,
    Map<String, dynamic> body,
  ) async {
    try {
      final response = await _dio.post<dynamic>(
        path,
        data: body,
        options: Options(headers: ApiService.getHeader(false)),
      );
      final data = response.data;
      if (data is Map) return data;
      throw ApiException(error: ApiErrorMessage.APP_PARSE_ERROR);
    } on DioException catch (error) {
      throw ApiException(
        error: ApiErrorExtractor.messageFrom(error.response?.data) ??
            ApiErrorMessage.APP_API_ERROR,
        statusCode: error.response?.statusCode,
      );
    }
  }

  static Future<Map<dynamic, dynamic>> _getMap(
    String path,
    Map<String, dynamic> query,
  ) async {
    try {
      final response = await _dio.get<dynamic>(
        path,
        queryParameters: query,
        options: Options(headers: ApiService.getHeader(false)),
      );
      final data = response.data;
      if (data is Map) return data;
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
