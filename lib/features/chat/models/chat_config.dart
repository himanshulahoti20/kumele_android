class ChatMessage {
  ChatMessage({
    required this.from,
    required this.date,
    required this.time,
    required this.msg,
    required this.itsME,
    required this.profile,
    this.tags,
  });

  final String from;
  final String date;
  final String time;
  final String msg;
  final bool itsME;
  final String profile;
  final List<Tag>? tags;
}

class Tag {
  Tag({
    required this.name,
    required this.profileImagePath,
    required this.id,
  });

  final String name;
  final String profileImagePath;
  final String id;
}
