class ChatStatusEntity {
  final bool exists;
  final String? roomId;
  final String status;
  final DateTime? openedAt;
  final DateTime? closesAt;
  final bool hasAccess;
  final bool isOpen;
  final int messageCount;

  const ChatStatusEntity({
    required this.exists,
    this.roomId,
    required this.status,
    this.openedAt,
    this.closesAt,
    required this.hasAccess,
    required this.isOpen,
    this.messageCount = 0,
  });

  bool get canEnter => exists && hasAccess && isOpen;
}
