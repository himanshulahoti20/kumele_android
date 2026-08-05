import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kuemele/core/app_strings.dart';
import 'package:kuemele/features/chat/data/datasources/chat_socket_data_source.dart';
import 'package:kuemele/features/chat/domain/entities/chat_room_entity.dart';
import 'package:kuemele/features/chat/domain/entities/chat_room_message_entity.dart';
import 'package:kuemele/features/chat/domain/entities/chat_status_entity.dart';
import 'package:kuemele/features/chat/domain/repositories/chat_room_repository.dart';
import 'package:kuemele/shared/services/api_service/api_exception.dart';
import 'dart:developer';

part 'chat_room_event.dart';
part 'chat_room_state.dart';

class ChatRoomBloc extends Bloc<ChatRoomEvent, ChatRoomState> {
  final ChatRoomRepository _repository;
  final ChatSocketDataSource _socket;

  List<ChatRoomEntity> _chatRooms = const [];
  String? _activeEventId;

  ChatRoomBloc({
    required ChatRoomRepository repository,
    ChatSocketDataSource? socket,
  })  : _repository = repository,
        _socket = socket ?? ChatSocketDataSource(),
        super(ChatRoomInitial()) {
    _socket.onNewMessage = _handleSocketNewMessage;
    _socket.onMessageModerated = _handleSocketMessageModerated;
    _socket.onError = _handleSocketError;

    on<LoadChatRooms>(_onLoadChatRooms);
    on<LeaveChatRoom>(_onLeaveChatRoom);
    on<CheckChatAccess>(_onCheckChatAccess);
    on<EnterChatRoom>(_onEnterChatRoom);
    on<LoadChatMessages>(_onLoadChatMessages);
    on<ConnectChatSocket>(_onConnectChatSocket);
    on<SendChatMessage>(_onSendChatMessage);
    on<_SocketMessageReceived>(_onSocketMessageReceived);
    on<_SocketMessageModerated>(_onSocketMessageModerated);
    on<_SocketSendFailed>(_onSocketSendFailed);
  }

  Future<void> _onLoadChatRooms(
    LoadChatRooms event,
    Emitter<ChatRoomState> emit,
  ) async {
    emit(ChatRoomLoading());
    try {
      _chatRooms = await _repository.getChatRooms();
      emit(ChatRoomLoaded(chatRooms: _chatRooms));
    } catch (e) {
      emit(const ChatRoomError(message: AppStrings.somethingWentWrong));
    }
  }

  Future<void> _onLeaveChatRoom(
    LeaveChatRoom event,
    Emitter<ChatRoomState> emit,
  ) async {
    final leavingEventId = event.eventId ?? _activeEventId;
    if (leavingEventId != null &&
        (_activeEventId == null || _activeEventId == leavingEventId)) {
      _disconnectSocket();
    }

    if (_chatRooms.isNotEmpty) {
      emit(ChatRoomLoaded(chatRooms: _chatRooms));
    } else {
      emit(ChatRoomLoading());
    }

    try {
      _chatRooms = await _repository.getChatRooms();
      emit(ChatRoomLoaded(chatRooms: _chatRooms));
    } catch (_) {
      if (_chatRooms.isEmpty) {
        emit(const ChatRoomError(message: AppStrings.somethingWentWrong));
      }
    }
  }

  Future<void> _onCheckChatAccess(
    CheckChatAccess event,
    Emitter<ChatRoomState> emit,
  ) async {
    emit(ChatRoomLoaded(
      chatRooms: _chatRooms,
      checkingEventId: event.chat.eventId,
    ));

    try {
      final status = await _repository.getChatStatus(event.chat.eventId);
      if (!status.canEnter) {
        emit(ChatAccessDenied(
          message: _denyMessage(status),
          chatRooms: _chatRooms,
        ));
        emit(ChatRoomLoaded(chatRooms: _chatRooms));
        return;
      }

      final joinResult = await _repository.joinChatRoom(event.chat.eventId);
      final messages = await _repository.getChatMessages(event.chat.eventId);

      emit(ChatAccessGranted(chat: event.chat, chatRooms: _chatRooms));
      emit(ChatMessagesLoaded(
        eventId: event.chat.eventId,
        roomId: joinResult.roomId,
        closesAt: joinResult.closesAt,
        messages: messages,
      ));
      _connectSocket(event.chat.eventId);
    } on ApiException catch (e) {
      emit(ChatAccessDenied(
        message: e.error?.trim().isNotEmpty == true
            ? e.error!.trim()
            : AppStrings.chatAccessDenied,
        chatRooms: _chatRooms,
      ));
      emit(ChatRoomLoaded(chatRooms: _chatRooms));
    } catch (_) {
      emit(ChatAccessDenied(
        message: AppStrings.somethingWentWrong,
        chatRooms: _chatRooms,
      ));
      emit(ChatRoomLoaded(chatRooms: _chatRooms));
    }
  }

  String _denyMessage(ChatStatusEntity status) {
    if (!status.exists) return AppStrings.chatNotAvailable;
    if (!status.hasAccess) return AppStrings.chatAccessDenied;
    if (!status.isOpen) return AppStrings.chatClosed;
    return AppStrings.chatNotAvailable;
  }

  Future<void> _onEnterChatRoom(
    EnterChatRoom event,
    Emitter<ChatRoomState> emit,
  ) async {
    emit(ChatRoomEntering(eventId: event.eventId));
    try {
      final joinResult = await _repository.joinChatRoom(event.eventId);
      try {
        final messages = await _repository.getChatMessages(event.eventId);
        emit(ChatMessagesLoaded(
          eventId: event.eventId,
          roomId: joinResult.roomId,
          closesAt: joinResult.closesAt,
          messages: messages,
        ));
        _connectSocket(event.eventId);
      } catch (_) {
        emit(ChatMessagesError(
          eventId: event.eventId,
          message: AppStrings.loadMessagesFailed,
        ));
      }
    } on ApiException catch (e) {
      emit(ChatMessagesError(
        eventId: event.eventId,
        message: e.error?.trim().isNotEmpty == true
            ? e.error!.trim()
            : AppStrings.joinChatFailed,
      ));
    } catch (_) {
      emit(ChatMessagesError(
        eventId: event.eventId,
        message: AppStrings.joinChatFailed,
      ));
    }
  }

  Future<void> _onLoadChatMessages(
    LoadChatMessages event,
    Emitter<ChatRoomState> emit,
  ) async {
    emit(ChatMessagesLoading(eventId: event.eventId));
    try {
      final messages = await _repository.getChatMessages(event.eventId);
      emit(ChatMessagesLoaded(
        eventId: event.eventId,
        messages: messages,
      ));
      _connectSocket(event.eventId);
    } catch (e) {
      emit(ChatMessagesError(
        eventId: event.eventId,
        message: AppStrings.loadMessagesFailed,
      ));
    }
  }

  Future<void> _onConnectChatSocket(
    ConnectChatSocket event,
    Emitter<ChatRoomState> emit,
  ) async {
    _connectSocket(event.eventId);
  }

  Future<void> _onSendChatMessage(
    SendChatMessage event,
    Emitter<ChatRoomState> emit,
  ) async {
    final current = state;
    if (current is! ChatMessagesLoaded) return;

    final content = event.content.trim();
    if (content.isEmpty) return;

    if (!_socket.isConnected) {
      emit(const ChatMessageSendFailed(message: AppStrings.sendMessageFailed));
      emit(current.copyWith(isSending: false));
      return;
    }

    final tempId = 'temp_${DateTime.now().microsecondsSinceEpoch}';
    final optimistic = ChatRoomMessageEntity(
      id: tempId,
      chatRoomId: current.roomId ?? '',
      userId: event.userId,
      content: content,
      createdAt: DateTime.now(),
      userDisplayName: event.userDisplayName,
      userAvatar: event.userAvatar,
    );

    emit(current.copyWith(
      messages: [...current.messages, optimistic],
      isSending: true,
    ));

    try {
      _socket.sendMessage(eventId: event.eventId, content: content);
    } catch (_) {
      _rollbackOptimisticMessage(
        emit,
        tempId: tempId,
        errorMessage: AppStrings.sendMessageFailed,
      );
    }
  }

  Future<void> _onSocketMessageReceived(
    _SocketMessageReceived event,
    Emitter<ChatRoomState> emit,
  ) async {
    final current = state;
    if (current is! ChatMessagesLoaded) return;
    if (current.eventId != _activeEventId) return;

    final incoming = event.message;
    if (incoming.id.isEmpty) return;

    if (current.messages.any((m) => m.id == incoming.id)) return;

    final withoutMatchingTemps = current.messages.where((m) {
      if (!m.id.startsWith('temp_')) return true;
      return !(m.userId == incoming.userId && m.content == incoming.content);
    }).toList();

    final stillPending =
        withoutMatchingTemps.any((m) => m.id.startsWith('temp_'));

    emit(current.copyWith(
      messages: [...withoutMatchingTemps, incoming],
      isSending: stillPending,
    ));
  }

  Future<void> _onSocketMessageModerated(
    _SocketMessageModerated event,
    Emitter<ChatRoomState> emit,
  ) async {
    final current = state;
    if (current is! ChatMessagesLoaded) return;
    if (event.messageId.isEmpty) return;

    final remaining =
        current.messages.where((m) => m.id != event.messageId).toList();
    if (remaining.length == current.messages.length) return;

    emit(current.copyWith(messages: remaining));
  }

  Future<void> _onSocketSendFailed(
    _SocketSendFailed event,
    Emitter<ChatRoomState> emit,
  ) async {
    final current = state;
    emit(ChatMessageSendFailed(message: event.message));
    if (current is ChatMessagesLoaded) {
      emit(current);
    }
  }

  void _rollbackOptimisticMessage(
    Emitter<ChatRoomState> emit, {
    required String tempId,
    required String errorMessage,
  }) {
    final latest = state;
    if (latest is! ChatMessagesLoaded) {
      emit(ChatMessageSendFailed(message: errorMessage));
      return;
    }

    final remaining = latest.messages.where((m) => m.id != tempId).toList();
    final stillPending = remaining.any((m) => m.id.startsWith('temp_'));

    emit(ChatMessageSendFailed(message: errorMessage));
    emit(latest.copyWith(messages: remaining, isSending: stillPending));
  }

  void _connectSocket(String eventId) {
    if (isClosed) return;
    _activeEventId = eventId;
    _socket.connect(eventId: eventId);
  }

  void _disconnectSocket() {
    _activeEventId = null;
    _socket.disconnect();
  }

  void _handleSocketNewMessage(ChatRoomMessageEntity message) {
    if (isClosed) return;
    log('ChatRoomBloc received socket message id=${message.id}',
        name: 'ChatRoomBloc');
    add(_SocketMessageReceived(message: message));
  }

  void _handleSocketMessageModerated(String messageId) {
    if (isClosed) return;
    add(_SocketMessageModerated(messageId: messageId));
  }

  void _handleSocketError(Object error) {
    if (isClosed) return;
    final current = state;
    if (current is ChatMessagesLoaded && current.isSending) {
      add(const _SocketSendFailed(message: AppStrings.sendMessageFailed));
    }
  }

  @override
  Future<void> close() {
    _socket.onNewMessage = null;
    _socket.onMessageModerated = null;
    _socket.onError = null;
    _disconnectSocket();
    return super.close();
  }
}
