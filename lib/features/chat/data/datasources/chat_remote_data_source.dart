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
            exists: data['exists'] == true ||
                data['chatRoomCreated'] == true ||
                data['active'] == true ||
                data['isActive'] == true,
            roomId: data['roomId']?.toString(),
            status: data['status']?.toString() ?? '',
            openedAt: data['openedAt'] != null
                ? DateTime.tryParse(data['openedAt'].toString())
                : null,
            closesAt: data['closesAt'] != null
                ? DateTime.tryParse(data['closesAt'].toString())
                : null,
            hasAccess: data['hasAccess'] != false,
            isOpen: data['isOpen'] == true ||
                data['isActive'] == true ||
                data['active'] == true,
            messageCount: _parseInt(
              data['messageCount'] ??
                  data['message_count'] ??
                  data['unreadCount'],
            ),
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
          final roomId = data['roomId']?.toString();

          if (!ok) {
            throw StateError('Invalid join chat response');
          }

          return JoinChatResult(
            roomId: roomId ?? '',
            closesAt: data['closesAt'] != null
                ? DateTime.tryParse(data['closesAt'].toString())
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
          final data = _extractMessages(response);
          return data
              .whereType<Map>()
              .map((json) => ChatRoomMessageModel.fromJson(
                    Map<String, dynamic>.from(json),
                  ))
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

  List<dynamic> _extractMessages(dynamic response) {
    final direct = ApiService.extractList(response);
    if (direct.isNotEmpty) return direct;

    final data = ApiService.extractMap(response);
    for (final key in const ['items', 'messages', 'results', 'data']) {
      final value = data[key];
      if (value is List) return value;
    }
    return const [];
  }

  int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}
