import 'package:kuemele/features/chat/data/models/chat_room_model.dart';
import 'package:kuemele/features/chat/data/models/chat_room_message_model.dart';
import 'package:kuemele/features/chat/domain/entities/chat_status_entity.dart';
import 'package:kuemele/features/chat/domain/entities/join_chat_result.dart';
import 'package:kuemele/shared/services/api_service/api_service.dart';
import 'package:kuemele/shared/services/api_service/generated/generated_api_catalog_lookup.dart';

class ChatRemoteDataSource {
  Future<List<ChatRoomModel>> fetchChatRooms() async {
    final api = GeneratedApiOperations.getChatRooms;
    final response = await ApiService.callRequest(
      api.method.toRequestMethod(),
      api.path,
      api.operationId,
    );

    return ApiService.handleResponse<List<ChatRoomModel>>(() {
          final data = ApiService.extractList(response);
          return data.map((json) => ChatRoomModel.fromJson(json)).toList();
        }) ??
        [];
  }

  Future<ChatStatusEntity> getChatStatus(String eventId) async {
    final api = GeneratedApiOperations.getChatStatus;
    final url = GeneratedApiOperations.resolvePath(api,
        pathValues: {'eventId': eventId});

    final response = await ApiService.callRequest(
      api.method.toRequestMethod(),
      url,
      api.operationId,
    );

    return ApiService.handleResponse<ChatStatusEntity>(() {
          final payload = response is Map<String, dynamic> ? response : null;
          final ok = payload?['ok'] == true || payload?['success'] == true;
          final data = ApiService.extractMap(response);

          if (!ok) {
            throw StateError('Invalid chat status response');
          }

          return ChatStatusEntity(
            exists: data['exists'] == true,
            roomId: data['roomId'] as String?,
            status: data['status'] as String? ?? '',
            openedAt: data['openedAt'] != null
                ? DateTime.tryParse(data['openedAt'] as String)
                : null,
            closesAt: data['closesAt'] != null
                ? DateTime.tryParse(data['closesAt'] as String)
                : null,
            hasAccess: data['hasAccess'] == true,
            isOpen: data['isOpen'] == true,
          );
        }) ??
        (throw StateError('Failed to get chat status'));
  }

  Future<JoinChatResult> joinChatRoom(String eventId) async {
    final api = GeneratedApiOperations.joinChat;
    final url = GeneratedApiOperations.resolvePath(api,
        pathValues: {'eventId': eventId});

    final response = await ApiService.callRequest(
      api.method.toRequestMethod(),
      url,
      api.operationId,
    );

    return ApiService.handleResponse<JoinChatResult>(() {
          final payload = response is Map<String, dynamic> ? response : null;
          final ok = payload?['ok'] == true || payload?['success'] == true;
          final data = ApiService.extractMap(response);
          final roomId = data['roomId'] as String?;

          if (!ok || roomId == null || roomId.isEmpty) {
            throw StateError('Invalid join chat response');
          }

          return JoinChatResult(
            roomId: roomId,
            closesAt: data['closesAt'] != null
                ? DateTime.tryParse(data['closesAt'] as String)
                : null,
          );
        }) ??
        (throw StateError('Failed to join chat room'));
  }

  Future<List<ChatRoomMessageModel>> getChatMessages(
      String eventId, int page, int limit) async {
    final api = GeneratedApiOperations.getChatMessages;
    final url = GeneratedApiOperations.resolvePath(api,
        pathValues: {'eventId': eventId});

    final response = await ApiService.callRequest(
      api.method.toRequestMethod(),
      url,
      api.operationId,
      params: {
        'page': page,
        'limit': limit,
      },
    );

    return ApiService.handleResponse<List<ChatRoomMessageModel>>(() {
          final data = ApiService.extractList(response);
          return data
              .map((json) => ChatRoomMessageModel.fromJson(json))
              .toList();
        }) ??
        [];
  }

  Future<void> postChatMessage(String eventId, String content) async {
    final api = GeneratedApiOperations.postChatMessage;
    final url = GeneratedApiOperations.resolvePath(api,
        pathValues: {'eventId': eventId});

    await ApiService.callRequest(
      api.method.toRequestMethod(),
      url,
      api.operationId,
      body: {
        'content': content,
        'message_text': content,
      },
    );
  }
}
