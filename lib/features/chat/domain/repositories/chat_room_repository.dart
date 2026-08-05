import 'package:kuemele/features/chat/domain/entities/chat_room_entity.dart';
import 'package:kuemele/features/chat/domain/entities/chat_room_message_entity.dart';
import 'package:kuemele/features/chat/domain/entities/chat_status_entity.dart';
import 'package:kuemele/features/chat/domain/entities/join_chat_result.dart';

abstract class ChatRoomRepository {
  Future<List<ChatRoomEntity>> getChatRooms();
  Future<ChatStatusEntity> getChatStatus(String eventId);
  Future<JoinChatResult> joinChatRoom(String eventId);
  Future<List<ChatRoomMessageEntity>> getChatMessages(String eventId);
  Future<void> postChatMessage(String eventId, String content);
}
