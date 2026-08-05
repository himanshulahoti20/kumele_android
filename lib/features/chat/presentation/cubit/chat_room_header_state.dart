part of 'chat_room_header_cubit.dart';

enum ChatRoomHeaderStatus { initial, loading, loaded, failure }

class ChatRoomHeaderState extends Equatable {
  const ChatRoomHeaderState({
    this.status = ChatRoomHeaderStatus.initial,
    this.eventId,
    this.eventDetail,
    this.guests = const [],
  });

  final ChatRoomHeaderStatus status;
  final String? eventId;
  final ExploreEventDetail? eventDetail;
  final List<EventGuestEntity> guests;

  bool get isLoading => status == ChatRoomHeaderStatus.loading;
  bool get isLoaded => status == ChatRoomHeaderStatus.loaded;

  String? get title => eventDetail?.title;
  String? get hostName => eventDetail?.hostName;

  ChatRoomHeaderState copyWith({
    ChatRoomHeaderStatus? status,
    String? eventId,
    ExploreEventDetail? eventDetail,
    List<EventGuestEntity>? guests,
    bool clearEventDetail = false,
    bool clearGuests = false,
  }) {
    return ChatRoomHeaderState(
      status: status ?? this.status,
      eventId: eventId ?? this.eventId,
      eventDetail: clearEventDetail ? null : eventDetail ?? this.eventDetail,
      guests: clearGuests ? const [] : guests ?? this.guests,
    );
  }

  @override
  List<Object?> get props => [status, eventId, eventDetail, guests];
}
