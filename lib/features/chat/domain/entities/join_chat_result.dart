class JoinChatResult {
  final String roomId;
  final DateTime? closesAt;

  const JoinChatResult({
    required this.roomId,
    this.closesAt,
  });
}
