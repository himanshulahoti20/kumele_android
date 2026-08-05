import 'package:equatable/equatable.dart';

class ChatRoomEntity extends Equatable {
  final String id;
  final String eventId;
  final String eventName;
  final DateTime? eventDate;
  final String eventImage;
  final String hostId;
  final String hostName;
  final String hostImage;
  final String status;
  final bool isOpen;
  final DateTime? openedAt;
  final DateTime? closesAt;
  final DateTime? closedAt;

  const ChatRoomEntity({
    required this.id,
    required this.eventId,
    required this.eventName,
    this.eventDate,
    required this.eventImage,
    required this.hostId,
    required this.hostName,
    required this.hostImage,
    required this.status,
    required this.isOpen,
    this.openedAt,
    this.closesAt,
    this.closedAt,
  });

  @override
  List<Object?> get props => [
        id,
        eventId,
        eventName,
        eventDate,
        eventImage,
        hostId,
        hostName,
        hostImage,
        status,
        isOpen,
        openedAt,
        closesAt,
        closedAt,
      ];
}
