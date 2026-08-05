import 'dart:developer';

import 'package:kuemele/features/chat/data/models/chat_room_message_model.dart';
import 'package:kuemele/features/chat/domain/entities/chat_room_message_entity.dart';
import 'package:kuemele/shared/services/api_service/api_config.dart';
import 'package:kuemele/shared/services/api_service/api_service.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

typedef ChatSocketMessageCallback = void Function(
  ChatRoomMessageEntity message,
);
typedef ChatSocketModeratedCallback = void Function(String messageId);
typedef ChatSocketErrorCallback = void Function(Object error);

class ChatSocketEvents {
  static const joinRoom = 'join_room';
  static const leaveRoom = 'leave_room';
  static const sendMessage = 'send_message';
  static const newMessage = 'new_message';
  static const messageModerated = 'message:moderated';
}

class ChatSocketDataSource {
  static const _logName = 'ChatSocket';

  io.Socket? _socket;
  String? _eventId;
  bool _disposed = false;

  ChatSocketMessageCallback? onNewMessage;
  ChatSocketModeratedCallback? onMessageModerated;
  ChatSocketErrorCallback? onError;

  bool get isConnected => _socket?.connected == true;

  void connect({required String eventId}) {
    if (_disposed) return;

    _switchRoomIfNeeded(eventId);
    _eventId = eventId;

    if (_socket != null) {
      if (_socket!.connected) {
        _joinRoom(eventId);
        return;
      }
      _teardownSocket();
    }

    final accessToken = _accessToken;
    if (accessToken.isEmpty) {
      onError?.call(StateError('Missing access token for chat socket'));
      return;
    }

    final socket = _createSocket(accessToken);
    _bindListeners(socket);
    _socket = socket;
    socket.connect();
  }

  void sendMessage({required String eventId, required String content}) {
    if (!isConnected) {
      onError?.call(StateError('Chat socket is not connected'));
      return;
    }
    _emit(ChatSocketEvents.sendMessage, {
      'eventId': eventId,
      'content': content,
    });
  }

  void disconnect() {
    final eventId = _eventId;
    if (isConnected && eventId != null && eventId.isNotEmpty) {
      _emit(ChatSocketEvents.leaveRoom, {'eventId': eventId});
    }
    _teardownSocket();
    _eventId = null;
  }

  void dispose() {
    _disposed = true;
    onNewMessage = null;
    onMessageModerated = null;
    onError = null;
    disconnect();
  }

  io.Socket _createSocket(String accessToken) {
    return io.io(
      '${ApiConfig.socketUrl}${ApiConfig.chatSocketNamespace}',
      io.OptionBuilder()
          .setTransports(ApiConfig.socketTransports)
          .setAuth({'token': accessToken})
          .setExtraHeaders({'authorization': 'Bearer $accessToken'})
          .disableAutoConnect()
          .enableForceNew()
          .enableReconnection()
          .build(),
    );
  }

  void _bindListeners(io.Socket socket) {
    socket
      ..onConnect((_) {
        log('connected id=${socket.id}', name: _logName);
        final eventId = _eventId;
        if (eventId != null && eventId.isNotEmpty) {
          _joinRoom(eventId);
        }
      })
      ..onDisconnect((reason) {
        log('disconnected: $reason', name: _logName);
      })
      ..onConnectError((error) {
        log('connect error: $error', name: _logName);
        onError?.call(error ?? 'connect_error');
      })
      ..onError((error) {
        log('error: $error', name: _logName);
        onError?.call(error ?? 'socket_error');
      })
      ..on(ChatSocketEvents.newMessage, _onNewMessage)
      ..on(ChatSocketEvents.messageModerated, _onMessageModerated);
  }

  void _onNewMessage(dynamic data) {
    try {
      final json = _extractPayload(data);
      if (json == null) return;

      final message = ChatRoomMessageModel.fromSocketJson(
        json,
        fallbackChatRoomId: _eventId ?? '',
      );
      if (message.id.isEmpty) return;

      onNewMessage?.call(message);
    } catch (e, st) {
      log('parse ${ChatSocketEvents.newMessage} failed: $e\n$st',
          name: _logName);
    }
  }

  void _onMessageModerated(dynamic data) {
    try {
      final json = _extractPayload(data);
      final messageId = (json?['messageId'] ?? json?['id'])?.toString();
      if (messageId == null || messageId.isEmpty) return;
      onMessageModerated?.call(messageId);
    } catch (e, st) {
      log('parse ${ChatSocketEvents.messageModerated} failed: $e\n$st',
          name: _logName);
    }
  }

  void _switchRoomIfNeeded(String eventId) {
    if (_eventId == null ||
        _eventId == eventId ||
        _socket == null ||
        !_socket!.connected) {
      return;
    }
    _emit(ChatSocketEvents.leaveRoom, {'eventId': _eventId});
  }

  void _joinRoom(String eventId) {
    final socket = _socket;
    if (socket == null || !socket.connected) return;

    socket.emitWithAck(
      ChatSocketEvents.joinRoom,
      [
        {'eventId': eventId}
      ],
      ack: (data) {
        log('${ChatSocketEvents.joinRoom} ack=$data', name: _logName);
      },
    );
  }

  void _emit(String event, Map<String, dynamic> payload) {
    _socket?.emit(event, [payload]);
  }

  void _teardownSocket() {
    final socket = _socket;
    if (socket == null) return;

    try {
      socket.clearListeners();
    } catch (_) {}
    try {
      socket.disconnect();
    } catch (_) {}
    try {
      socket.dispose();
    } catch (_) {}

    _socket = null;
  }

  static String get _accessToken {
    final raw = ApiService.token.trim();
    if (raw.isEmpty) return '';
    if (raw.toLowerCase().startsWith('bearer ')) {
      return raw.substring(7).trim();
    }
    return raw;
  }

  static Map<String, dynamic>? _extractPayload(dynamic data) {
    final map = _asMap(data);
    if (map == null) return null;

    final nested = map['data'] ?? map['message'] ?? map['payload'];
    final nestedMap = _asMap(nested);
    if (nestedMap != null &&
        (nestedMap.containsKey('id') || nestedMap.containsKey('content'))) {
      return nestedMap;
    }
    return map;
  }

  static Map<String, dynamic>? _asMap(dynamic data) {
    if (data is List && data.isNotEmpty) return _asMap(data.first);
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);
    return null;
  }
}
