class ChatStatusEntity {
  final bool exists;
  final String? roomId;
  final String status;
  final DateTime? openedAt;
  final DateTime? closesAt;
  final bool hasAccess;
  final bool isOpen;

  const ChatStatusEntity({
    required this.exists,
    this.roomId,
    required this.status,
    this.openedAt,
    this.closesAt,
    required this.hasAccess,
    required this.isOpen,
  });

  bool get canEnter => exists && hasAccess && isOpen;
}
