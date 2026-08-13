import 'package:kuemele/shared/services/api_service/aiml/aiml_repo.dart';

class ChatbotRepo {
  static Future<String> ask({
    required String userId,
    required String query,
  }) =>
      AimlRepo.askChatbot(userId: userId, query: query);
}
