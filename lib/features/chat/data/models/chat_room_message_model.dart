import 'package:kuemele/core/app_strings.dart';
import 'package:kuemele/features/chat/domain/entities/chat_room_message_entity.dart';

class ChatRoomMessageModel extends ChatRoomMessageEntity {
  ChatRoomMessageModel({
    required super.id,
    required super.chatRoomId,
    required super.userId,
    required super.content,
    required super.createdAt,
    required super.userDisplayName,
    required super.userAvatar,
  });

  factory ChatRoomMessageModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>?;
    final firstName = (user?['firstName'] as String?)?.trim();
    final displayName = (user?['displayName'] as String?)?.trim();
    final fallbackFirst = displayName == null || displayName.isEmpty
        ? null
        : displayName.split(RegExp(r'\s+')).first;

    return ChatRoomMessageModel(
      id: json['id'] as String,
      chatRoomId: json['chatRoomId'] as String,
      userId: json['userId'] as String,
      content: json['content'] as String? ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      userDisplayName: (firstName != null && firstName.isNotEmpty)
          ? firstName
          : (fallbackFirst != null && fallbackFirst.isNotEmpty
              ? fallbackFirst
              : AppStrings.unknownUser),
      userAvatar: user?['avatar'] as String? ?? '',
    );
  }

  factory ChatRoomMessageModel.fromSocketJson(
    Map<String, dynamic> json, {
    String fallbackChatRoomId = '',
  }) {
    final user = _asMap(json['user']);
    final displayName = (user?['displayName'] as String?)?.trim();
    final firstName = (user?['firstName'] as String?)?.trim();
    final fallbackFirst = displayName == null || displayName.isEmpty
        ? null
        : displayName.split(RegExp(r'\s+')).first;

    final userId = (json['userId'] ?? user?['id'])?.toString() ?? '';
    final chatRoomId = (json['chatRoomId'] ?? json['roomId'])?.toString() ??
        fallbackChatRoomId;

    final createdAtRaw = json['createdAt'];
    final createdAt = createdAtRaw is String && createdAtRaw.isNotEmpty
        ? DateTime.tryParse(createdAtRaw) ?? DateTime.now()
        : DateTime.now();

    return ChatRoomMessageModel(
      id: json['id']?.toString() ?? '',
      chatRoomId: chatRoomId,
      userId: userId,
      content: json['content']?.toString() ?? '',
      createdAt: createdAt,
      userDisplayName: (firstName != null && firstName.isNotEmpty)
          ? firstName
          : (fallbackFirst != null && fallbackFirst.isNotEmpty
              ? fallbackFirst
              : AppStrings.unknownUser),
      userAvatar: user?['avatar']?.toString() ?? '',
    );
  }

  static Map<String, dynamic>? _asMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return null;
  }
}
