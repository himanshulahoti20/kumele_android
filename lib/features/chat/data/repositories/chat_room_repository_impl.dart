import 'package:kuemele/features/chat/data/datasources/chat_remote_data_source.dart';
import 'package:kuemele/features/chat/domain/entities/chat_room_entity.dart';
import 'package:kuemele/features/chat/domain/entities/chat_room_message_entity.dart';
import 'package:kuemele/features/chat/domain/entities/chat_status_entity.dart';
import 'package:kuemele/features/chat/domain/entities/join_chat_result.dart';
import 'package:kuemele/features/chat/domain/repositories/chat_room_repository.dart';

class ChatRoomRepositoryImpl implements ChatRoomRepository {
  final ChatRemoteDataSource _remoteDataSource;

  ChatRoomRepositoryImpl({ChatRemoteDataSource? remoteDataSource})
      : _remoteDataSource = remoteDataSource ?? ChatRemoteDataSource();

  @override
  Future<List<ChatRoomEntity>> getChatRooms() async {
    final models = await _remoteDataSource.fetchChatRooms();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<ChatStatusEntity> getChatStatus(String eventId) async {
    return _remoteDataSource.getChatStatus(eventId);
  }

  @override
  Future<JoinChatResult> joinChatRoom(String eventId) async {
    return _remoteDataSource.joinChatRoom(eventId);
  }

  @override
  Future<List<ChatRoomMessageEntity>> getChatMessages(String eventId) async {
    return _remoteDataSource.getChatMessages(eventId, 1, 100);
  }

  @override
  Future<void> postChatMessage(String eventId, String content) async {
    await _remoteDataSource.postChatMessage(eventId, content);
  }
}
