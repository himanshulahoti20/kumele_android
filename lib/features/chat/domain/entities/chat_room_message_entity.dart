class ChatRoomMessageEntity {
  final String id;
  final String chatRoomId;
  final String userId;
  final String content;
  final DateTime createdAt;
  final String userDisplayName;
  final String userAvatar;

  ChatRoomMessageEntity({
    required this.id,
    required this.chatRoomId,
    required this.userId,
    required this.content,
    required this.createdAt,
    required this.userDisplayName,
    required this.userAvatar,
  });
}
