import 'package:kuemele/shared/models/aiml_models.dart';
import 'package:kuemele/shared/services/api_service/api_service.dart';

class AimlRepo {
  static const _auth = true;

  static Future<List<Map<String, dynamic>>> getMatchedEvents({
    required String userId,
    required double lat,
    required double lon,
    required double radiusKm,
    String languages = 'en',
    String? rewardTier,
    int limit = 10,
  }) {
    return _getList('/match/events', {
      'user_id': userId,
      'lat': lat,
      'lon': lon,
      'radius_km': radiusKm,
      'languages': languages,
      if (rewardTier != null && rewardTier.isNotEmpty)
        'reward_tier': rewardTier,
      'limit': limit,
    });
  }

  static Future<List<Map<String, dynamic>>> getRecommendedEvents({
    required String userId,
    double? lat,
    double? lon,
    double? radiusKm,
    String? languages,
    String? rewardTier,
    int limit = 10,
  }) {
    return _getList('/recommendations/events', {
      'user_id': userId,
      if (lat != null) 'lat': lat,
      if (lon != null) 'lon': lon,
      if (radiusKm != null) 'radius_km': radiusKm,
      if (languages != null && languages.isNotEmpty) 'languages': languages,
      if (rewardTier != null && rewardTier.isNotEmpty)
        'reward_tier': rewardTier,
      'limit': limit,
    });
  }

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

  static Future<Map<String, dynamic>> moderateContent(
    Map<String, dynamic> body,
  ) {
    return _postMap('/moderation', body);
  }

  static Future<Map<String, dynamic>> getModerationResult(String contentId) {
    return _getMap('/moderation/$contentId');
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

  static Future<Map<String, dynamic>> getDiscountSuggestion({
    required String eventId,
    required String hostId,
    String? campaignGoal,
  }) {
    return _getMap('/discount/suggestion', {
      'event_id': eventId,
      'host_id': hostId,
      if (campaignGoal != null && campaignGoal.isNotEmpty)
        'campaign_goal': campaignGoal,
    });
  }

  static Future<Map<String, dynamic>> getPredictTrends({
    String? location,
    String? hobby,
    int limit = 10,
  }) {
    return _getMap('/predict/trends', {
      if (location != null && location.isNotEmpty) 'location': location,
      if (hobby != null && hobby.isNotEmpty) 'hobby': hobby,
      'limit': limit,
    });
  }

  static Future<AimlRewardsSuggestion> getRewardsSuggestion(
    String userId,
  ) async {
    final data = await _getMap('/rewards/suggestion', {'user_id': userId});
    return AimlRewardsSuggestion.fromJson(data);
  }

  static Future<Map<String, dynamic>> getHostRating(String hostId) {
    return _getMap('/host/$hostId/rating');
  }

  static Future<Map<String, dynamic>> rateEvent({
    required String eventId,
    required String userId,
    required int rating,
    String? comment,
  }) {
    return _postMap('/event/$eventId/rating', {
      'user_id': userId,
      'rating': rating,
      if (comment != null && comment.isNotEmpty) 'comment': comment,
    });
  }

  static Future<Map<String, dynamic>> validateCheckin(
    Map<String, dynamic> body,
  ) {
    return _postMap('/checkin/validate', body);
  }

  static Future<Map<String, dynamic>> verifyCheckin(
    Map<String, dynamic> body,
  ) {
    return _postMap('/checkin/verify', body);
  }

  static Future<Map<String, dynamic>> detectCheckinFraud(
    Map<String, dynamic> body,
  ) {
    return _postMap('/checkin/fraud-detect', body);
  }

  static Future<Map<String, dynamic>> getEventTranslation({
    required String eventId,
    required String language,
  }) {
    return getContentTranslation(
      contentType: 'event',
      contentId: eventId,
      language: language,
    );
  }

  static Future<Map<String, dynamic>> getContentTranslation({
    required String contentType,
    required String contentId,
    required String language,
  }) {
    return _getMap('/content-translations/$contentType/$contentId', {
      'language': language,
    });
  }

  static Future<Map<String, dynamic>> translate({
    required String text,
    required String targetLanguage,
    String? sourceLanguage,
  }) {
    return _postMap('/translate', {
      'text': text,
      'target_language': targetLanguage,
      if (sourceLanguage != null && sourceLanguage.isNotEmpty)
        'source_language': sourceLanguage,
    });
  }

  static Future<Map<String, dynamic>> getI18nStrings(String language) {
    return _getMap('/i18n/$language');
  }

  static Future<Map<String, dynamic>> approveI18n(
    Map<String, dynamic> body,
  ) {
    return _postMap('/admin/i18n/approve', body);
  }

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

  static Future<List<Map<String, dynamic>>> getTaxonomyInterests({
    String? language,
  }) {
    return _getList('/taxonomy/interests', {
      if (language != null && language.isNotEmpty) 'language': language,
    });
  }

  static Future<Map<String, dynamic>> getAdsAudienceMatch({
    required String advertiserId,
    required String campaignText,
  }) {
    return _getMap('/ads/audience-match', {
      'advertiser_id': advertiserId,
      'campaign_text': campaignText,
    });
  }

  static Future<Map<String, dynamic>> getAdsPerformancePredict(
    Map<String, dynamic> query,
  ) {
    return _getMap('/ads/performance-predict', query);
  }

  static Future<Map<String, dynamic>> analyzeSentiment({
    required String text,
    String? entityType,
    String? entityId,
  }) {
    return _postMap('/nlp/sentiment', {
      'text': text,
      if (entityType != null && entityType.isNotEmpty)
        'entity_type': entityType,
      if (entityId != null && entityId.isNotEmpty) 'entity_id': entityId,
    });
  }

  static Future<Map<String, dynamic>> extractKeywords({
    required String text,
    int limit = 10,
  }) {
    return _postMap('/nlp/keywords', {'text': text, 'limit': limit});
  }

  static Future<Map<String, dynamic>> getTrends({
    String? category,
    String? location,
    int limit = 10,
  }) {
    return _getMap('/nlp/trends', {
      if (category != null && category.isNotEmpty) 'category': category,
      if (location != null && location.isNotEmpty) 'location': location,
      'limit': limit,
    });
  }

  static Future<Map<String, dynamic>> analyzeFeedback({
    required String userId,
    required String feedback,
    String? context,
  }) {
    return _postMap('/feedback/analyze', {
      'user_id': userId,
      'feedback': feedback,
      if (context != null && context.isNotEmpty) 'context': context,
    });
  }

  static Future<Map<String, dynamic>> getRetentionRisk({
    required String userId,
  }) {
    return _getMap('/engagement/retention-risk', {'user_id': userId});
  }

  static Future<String> askChatbot({
    required String userId,
    required String query,
    String language = 'en',
  }) async {
    final data = await _postMap('/chatbot/ask', {
      'user_id': userId,
      'userId': userId,
      'query': query,
      'language': language,
      'top_k': 5,
    });
    final answer = data['answer'] ?? data['response'] ?? data['message'];
    if (answer != null && answer.toString().trim().isNotEmpty) {
      return answer.toString().trim();
    }
    throw const FormatException('Missing chatbot answer');
  }

  static Future<Map<String, dynamic>> sendChatbotFeedback({
    required String userId,
    required String messageId,
    required bool helpful,
    String? comment,
  }) {
    return _postMap('/chatbot/feedback', {
      'user_id': userId,
      'message_id': messageId,
      'helpful': helpful,
      if (comment != null && comment.isNotEmpty) 'comment': comment,
    });
  }

  static Future<Map<String, dynamic>> classifySupport({
    required String ticketId,
    required String message,
  }) {
    return _postMap('/support/classify', {
      'ticket_id': ticketId,
      'message': message,
    });
  }

  static Future<Map<String, dynamic>> suggestSupportReply({
    required String ticketId,
    required String message,
  }) {
    return _postMap('/support/suggest-reply', {
      'ticket_id': ticketId,
      'message': message,
    });
  }

  static Future<Map<String, dynamic>> sendSupportReply({
    required String ticketId,
    required String reply,
  }) {
    return _postMap('/support/email/reply/$ticketId', {'reply': reply});
  }

  static Future<Map<String, dynamic>> escalateSupportTicket({
    required String ticketId,
    String? reason,
  }) {
    return _postMap('/support/email/escalate/$ticketId', {
      if (reason != null && reason.isNotEmpty) 'reason': reason,
    });
  }

  static Future<Map<String, dynamic>> _postMap(
    String path,
    Map<String, dynamic> body,
  ) async {
    final response = await ApiService.callRequest(
      RequestMethod.POST,
      path,
      'aiml:$path',
      body: body,
      useAuthenHeader: _auth,
    );
    return _asMap(response);
  }

  static Future<Map<String, dynamic>> _getMap(String path,
      [Map<String, dynamic>? query]) async {
    final response = await ApiService.callRequest(
      RequestMethod.GET,
      path,
      'aiml:$path',
      params: query,
      useAuthenHeader: _auth,
    );
    return _asMap(response);
  }

  static Future<List<Map<String, dynamic>>> _getList(
    String path,
    Map<String, dynamic> query,
  ) async {
    final response = await ApiService.callRequest(
      RequestMethod.GET,
      path,
      'aiml:$path',
      params: query,
      useAuthenHeader: _auth,
    );
    return _asList(response);
  }

  static Map<String, dynamic> _asMap(dynamic response) {
    return Map<String, dynamic>.from(ApiService.extractMap(response));
  }

  static List<Map<String, dynamic>> _asList(dynamic response) {
    var list = ApiService.extractList(response);
    if (list.isEmpty && response is Map) {
      list = response.values.whereType<List>().firstOrNull ?? const [];
    }
    return list
        .whereType<Map>()
        .map((value) => Map<String, dynamic>.from(value))
        .toList();
  }
}
