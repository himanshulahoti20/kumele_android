import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kuemele/features/chat/domain/repositories/chat_room_repository.dart';
import 'package:kuemele/features/discover/cubit/event_matched_event.dart';
import 'package:kuemele/features/discover/cubit/event_matched_state.dart';
import 'package:kuemele/features/discover/presentation/discover_config.dart';
import 'package:kuemele/l10n/app_localizations_en.dart';
import 'package:kuemele/shared/services/api_service/api_exception.dart';

export 'event_matched_event.dart';
export 'event_matched_state.dart';

class EventMatchedBloc extends Bloc<EventMatchedEvent, EventMatchedState> {
  EventMatchedBloc({required ChatRoomRepository chatRoomRepository})
      : _chatRoomRepository = chatRoomRepository,
        super(
          EventMatchedState(
            eventData: DiscoverConfig.matchedEvent(),
          ),
        ) {
    on<EventMatchedStarted>(_onStarted);
    on<EventMatchedGoToChatTapped>(_onGoToChatTapped);
    on<EventMatchedConfettiCompleted>(_onConfettiCompleted);
  }

  final ChatRoomRepository _chatRoomRepository;

  void _onStarted(
    EventMatchedStarted event,
    Emitter<EventMatchedState> emit,
  ) {
    emit(
      EventMatchedState(
        eventData: event.eventData,
        status: EventMatchedStatus.ready,
        showConfetti: true,
      ),
    );
  }

  Future<void> _onGoToChatTapped(
    EventMatchedGoToChatTapped event,
    Emitter<EventMatchedState> emit,
  ) async {
    if (state.status == EventMatchedStatus.joiningChat) return;

    final eventId = state.eventData.eventId.trim();
    if (eventId.isEmpty) {
      emit(
        state.copyWith(
          status: EventMatchedStatus.joinChatFailed,
          errorMessage: AppLocalizationsEn().joinChatFailed,
        ),
      );
      emit(state.copyWith(status: EventMatchedStatus.ready, clearError: true));
      return;
    }

    emit(
      state.copyWith(
        status: EventMatchedStatus.joiningChat,
        clearError: true,
      ),
    );

    try {
      await _chatRoomRepository.joinChatRoom(eventId);
      emit(state.copyWith(status: EventMatchedStatus.navigating));
    } on ApiException catch (e) {
      emit(
        state.copyWith(
          status: EventMatchedStatus.joinChatFailed,
          errorMessage: e.error?.trim().isNotEmpty == true
              ? e.error!.trim()
              : AppLocalizationsEn().joinChatFailed,
        ),
      );
      emit(state.copyWith(status: EventMatchedStatus.ready, clearError: true));
    } catch (_) {
      emit(
        state.copyWith(
          status: EventMatchedStatus.joinChatFailed,
          errorMessage: AppLocalizationsEn().joinChatFailed,
        ),
      );
      emit(state.copyWith(status: EventMatchedStatus.ready, clearError: true));
    }
  }

  void _onConfettiCompleted(
    EventMatchedConfettiCompleted event,
    Emitter<EventMatchedState> emit,
  ) {
    emit(state.copyWith(showConfetti: false));
  }
}
