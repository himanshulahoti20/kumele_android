import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kuemele/features/explore/domain/repositories/notification_repository.dart';
import 'package:kuemele/features/explore/presentation/notification/notification_data.dart';
import 'package:kuemele/features/explore/presentation/notification/notification_event.dart';
import 'package:kuemele/features/explore/presentation/notification/notification_state.dart';
import 'package:kuemele/shared/services/pagination/pagination_service.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc({required NotificationRepository repository})
      : _repository = repository,
        _paginationService = PaginationService<NotificationItem>(
          fetchPage: repository.getNotifications,
          defaultLimit: 20,
        ),
        super(const NotificationState()) {
    on<NotificationsRequested>(_onNotificationsRequested);
    on<NotificationsLoadMoreRequested>(_onLoadMoreRequested);
    on<NotificationsRetryRequested>(_onRetryRequested);
    on<NotificationTapped>(_onNotificationTapped);
    on<NotificationActionCleared>(_onActionCleared);
  }

  final NotificationRepository _repository;
  final PaginationService<NotificationItem> _paginationService;

  Future<void> _onNotificationsRequested(
    NotificationsRequested event,
    Emitter<NotificationState> emit,
  ) async {
    await _paginationService.loadInitial(
      emit: (newPaginationState) =>
          emit(state.copyWith(paginationState: newPaginationState)),
      currentState: state.paginationState,
      refresh: event.refresh,
    );
  }

  Future<void> _onLoadMoreRequested(
    NotificationsLoadMoreRequested event,
    Emitter<NotificationState> emit,
  ) async {
    await _paginationService.loadMore(
      emit: (newPaginationState) =>
          emit(state.copyWith(paginationState: newPaginationState)),
      currentState: state.paginationState,
    );
  }

  void _onRetryRequested(
    NotificationsRetryRequested event,
    Emitter<NotificationState> emit,
  ) async {
    await _paginationService.retry(
      emit: (newPaginationState) =>
          emit(state.copyWith(paginationState: newPaginationState)),
      currentState: state.paginationState,
    );
  }

  Future<void> _onNotificationTapped(
    NotificationTapped event,
    Emitter<NotificationState> emit,
  ) async {
    final tappedNotification = state.notifications.firstWhere(
      (n) => n.id == event.notificationId,
    );

    final updatedNotifications = state.notifications.map((n) {
      return n.id == event.notificationId ? n.copyWith(isRead: true) : n;
    }).toList(growable: false);

    final unreadCount = updatedNotifications.where((n) => !n.isRead).length;

    final pendingAction =
        tappedNotification.actionType == NotificationActionType.none
            ? null
            : NotificationAction(notification: tappedNotification);

    emit(
      state.copyWith(
        paginationState:
            state.paginationState.copyWith(items: updatedNotifications),
        unreadCount: unreadCount,
        pendingAction: pendingAction,
      ),
    );

    if (!tappedNotification.isRead) {
      try {
        await _repository.markAsRead(event.notificationId);
      } catch (_) {}
    }
  }

  void _onActionCleared(
    NotificationActionCleared event,
    Emitter<NotificationState> emit,
  ) {
    if (state.pendingAction == null) return;
    emit(state.copyWith(clearPendingAction: true));
  }
}
