part of 'chat_room_bloc.dart';

abstract class ChatRoomEvent extends Equatable {
  const ChatRoomEvent();

  @override
  List<Object?> get props => [];
}

class LoadChatRooms extends ChatRoomEvent {}

class LeaveChatRoom extends ChatRoomEvent {
  final String? eventId;

  const LeaveChatRoom({this.eventId});

  @override
  List<Object?> get props => [eventId];
}

class CheckChatAccess extends ChatRoomEvent {
  final ChatRoomEntity chat;

  const CheckChatAccess({required this.chat});

  @override
  List<Object> get props => [chat];
}

class EnterChatRoom extends ChatRoomEvent {
  final String eventId;

  const EnterChatRoom({required this.eventId});

  @override
  List<Object> get props => [eventId];
}

class LoadChatMessages extends ChatRoomEvent {
  final String eventId;

  const LoadChatMessages({required this.eventId});

  @override
  List<Object> get props => [eventId];
}

class ConnectChatSocket extends ChatRoomEvent {
  final String eventId;

  const ConnectChatSocket({required this.eventId});

  @override
  List<Object> get props => [eventId];
}

class SendChatMessage extends ChatRoomEvent {
  final String eventId;
  final String content;
  final String userId;
  final String userDisplayName;
  final String userAvatar;

  const SendChatMessage({
    required this.eventId,
    required this.content,
    required this.userId,
    required this.userDisplayName,
    required this.userAvatar,
  });

  @override
  List<Object> get props =>
      [eventId, content, userId, userDisplayName, userAvatar];
}

class _SocketMessageReceived extends ChatRoomEvent {
  final ChatRoomMessageEntity message;

  const _SocketMessageReceived({required this.message});

  @override
  List<Object> get props => [message];
}

class _SocketMessageModerated extends ChatRoomEvent {
  final String messageId;

  const _SocketMessageModerated({required this.messageId});

  @override
  List<Object> get props => [messageId];
}

class _SocketSendFailed extends ChatRoomEvent {
  final String message;

  const _SocketSendFailed({required this.message});

  @override
  List<Object> get props => [message];
}
