import 'package:kuemele/features/chat/domain/entities/chat_room_entity.dart';

class ChatRoomModel extends ChatRoomEntity {
  const ChatRoomModel({
    required super.id,
    required super.eventId,
    required super.eventName,
    super.eventDate,
    required super.eventImage,
    required super.hostId,
    required super.hostName,
    required super.hostImage,
    required super.status,
    required super.isOpen,
    super.openedAt,
    super.closesAt,
    super.closedAt,
    super.unreadCount,
  });

  factory ChatRoomModel.fromJson(Map<String, dynamic> json) {
    return ChatRoomModel(
      id: json['id'] ?? '',
      eventId: json['event_id'] ?? '',
      eventName: json['event_name'] ?? '',
      eventDate: json['event_date'] != null
          ? DateTime.tryParse(json['event_date'])
          : null,
      eventImage: json['event_image'] ?? '',
      hostId: json['host_id'] ?? '',
      hostName: json['host_name'] ?? '',
      hostImage: json['host_image'] ?? '',
      status: json['status'] ?? '',
      isOpen: json['is_open'] ?? false,
      openedAt: json['opened_at'] != null
          ? DateTime.tryParse(json['opened_at'])
          : null,
      closesAt: json['closes_at'] != null
          ? DateTime.tryParse(json['closes_at'])
          : null,
      closedAt: json['closed_at'] != null
          ? DateTime.tryParse(json['closed_at'])
          : null,
      unreadCount: _parseInt(
        json['unreadCount'] ??
            json['unread_count'] ??
            json['unreadMessages'] ??
            json['unread_messages'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'event_id': eventId,
      'event_name': eventName,
      'event_date': eventDate?.toIso8601String(),
      'event_image': eventImage,
      'host_id': hostId,
      'host_name': hostName,
      'host_image': hostImage,
      'status': status,
      'is_open': isOpen,
      'opened_at': openedAt?.toIso8601String(),
      'closes_at': closesAt?.toIso8601String(),
      'closed_at': closedAt?.toIso8601String(),
      'unread_count': unreadCount,
    };
  }

  ChatRoomEntity toEntity() {
    return this;
  }

  static int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}
