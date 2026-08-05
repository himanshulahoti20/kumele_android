import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kuemele/features/explore/domain/entities/event_guest_entity.dart';
import 'package:kuemele/features/explore/domain/entities/explore_event_detail.dart';
import 'package:kuemele/features/explore/domain/repositories/explore_repository.dart';
import 'package:kuemele/shared/bloc/bloc_extension.dart';

part 'chat_room_header_state.dart';

class ChatRoomHeaderCubit extends Cubit<ChatRoomHeaderState> {
  ChatRoomHeaderCubit({required ExploreRepository repository})
      : _repository = repository,
        super(const ChatRoomHeaderState());

  final ExploreRepository _repository;

  Future<void> load(String eventId) async {
    if (eventId.isEmpty) return;
    if (state.eventId == eventId && state.isLoaded) return;

    safeEmit(
      state.copyWith(
        status: ChatRoomHeaderStatus.loading,
        eventId: eventId,
        clearEventDetail: true,
        clearGuests: true,
      ),
    );

    final results = await Future.wait([
      _loadEventDetail(eventId),
      _loadGuests(eventId),
    ]);

    if (isClosed || state.eventId != eventId) return;

    final detail = results[0] as ExploreEventDetail?;
    final guests = results[1] as List<EventGuestEntity>;
    final hasData = detail != null || guests.isNotEmpty;

    safeEmit(
      state.copyWith(
        status: hasData
            ? ChatRoomHeaderStatus.loaded
            : ChatRoomHeaderStatus.failure,
        eventId: eventId,
        eventDetail: detail,
        guests: guests,
        clearEventDetail: detail == null,
      ),
    );
  }

  Future<ExploreEventDetail?> _loadEventDetail(String eventId) async {
    try {
      return await _repository.getEventById(eventId);
    } catch (_) {
      return null;
    }
  }

  Future<List<EventGuestEntity>> _loadGuests(String eventId) async {
    try {
      return await _repository.getEventGuests(eventId);
    } catch (_) {
      return const [];
    }
  }

  void reset() {
    safeEmit(const ChatRoomHeaderState());
  }
}
