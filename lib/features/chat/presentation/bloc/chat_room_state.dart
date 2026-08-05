part of 'chat_room_bloc.dart';

abstract class ChatRoomState extends Equatable {
  const ChatRoomState();

  @override
  List<Object?> get props => [];
}

class ChatRoomInitial extends ChatRoomState {}

class ChatRoomLoading extends ChatRoomState {}

class ChatRoomLoaded extends ChatRoomState {
  final List<ChatRoomEntity> chatRooms;
  final String? checkingEventId;

  const ChatRoomLoaded({
    required this.chatRooms,
    this.checkingEventId,
  });

  ChatRoomLoaded copyWith({
    List<ChatRoomEntity>? chatRooms,
    String? checkingEventId,
    bool clearCheckingEventId = false,
  }) {
    return ChatRoomLoaded(
      chatRooms: chatRooms ?? this.chatRooms,
      checkingEventId:
          clearCheckingEventId ? null : checkingEventId ?? this.checkingEventId,
    );
  }

  @override
  List<Object?> get props => [chatRooms, checkingEventId];
}

class ChatRoomError extends ChatRoomState {
  final String message;

  const ChatRoomError({required this.message});

  @override
  List<Object?> get props => [message];
}

class ChatAccessGranted extends ChatRoomState {
  final ChatRoomEntity chat;
  final List<ChatRoomEntity> chatRooms;

  const ChatAccessGranted({
    required this.chat,
    required this.chatRooms,
  });

  @override
  List<Object?> get props => [chat, chatRooms];
}

class ChatAccessDenied extends ChatRoomState {
  final String message;
  final List<ChatRoomEntity> chatRooms;

  const ChatAccessDenied({
    required this.message,
    required this.chatRooms,
  });

  @override
  List<Object?> get props => [message, chatRooms];
}

class ChatRoomEntering extends ChatRoomState {
  final String eventId;

  const ChatRoomEntering({required this.eventId});

  @override
  List<Object?> get props => [eventId];
}

class ChatMessagesLoading extends ChatRoomState {
  final String eventId;

  const ChatMessagesLoading({required this.eventId});

  @override
  List<Object?> get props => [eventId];
}

class ChatMessagesLoaded extends ChatRoomState {
  final String eventId;
  final String? roomId;
  final DateTime? closesAt;
  final List<ChatRoomMessageEntity> messages;
  final bool isSending;

  const ChatMessagesLoaded({
    required this.eventId,
    required this.messages,
    this.roomId,
    this.closesAt,
    this.isSending = false,
  });

  ChatMessagesLoaded copyWith({
    String? eventId,
    String? roomId,
    DateTime? closesAt,
    List<ChatRoomMessageEntity>? messages,
    bool? isSending,
  }) {
    return ChatMessagesLoaded(
      eventId: eventId ?? this.eventId,
      roomId: roomId ?? this.roomId,
      closesAt: closesAt ?? this.closesAt,
      messages: messages ?? this.messages,
      isSending: isSending ?? this.isSending,
    );
  }

  @override
  List<Object?> get props => [
        eventId,
        roomId,
        closesAt,
        isSending,
        messages.length,
        messages.map((m) => '${m.id}:${m.content}').join('|'),
      ];
}

class ChatMessagesError extends ChatRoomState {
  final String eventId;
  final String message;

  const ChatMessagesError({
    required this.eventId,
    required this.message,
  });

  @override
  List<Object?> get props => [eventId, message];
}

class ChatMessageSendFailed extends ChatRoomState {
  final String message;

  const ChatMessageSendFailed({required this.message});

  @override
  List<Object?> get props => [message];
}
