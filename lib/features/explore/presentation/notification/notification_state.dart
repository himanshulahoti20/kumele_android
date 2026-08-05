import 'package:equatable/equatable.dart';
import 'package:kuemele/features/explore/presentation/notification/notification_data.dart';
import 'package:kuemele/shared/services/pagination/pagination_state.dart';

class NotificationAction extends Equatable {
  const NotificationAction({required this.notification});

  final NotificationItem notification;

  @override
  List<Object?> get props => [notification];
}

class NotificationState extends Equatable {
  const NotificationState({
    this.paginationState = const PaginationState(),
    this.unreadCount = 0,
    this.pendingAction,
  });

  final PaginationState<NotificationItem> paginationState;
  final int unreadCount;
  final NotificationAction? pendingAction;

  bool get isLoading => paginationState.isLoading;
  bool get isLoadingMore => paginationState.isLoadingMore;
  bool get isRefreshing => paginationState.isRefreshing;
  PaginationStatus get status => paginationState.status;
  List<NotificationItem> get notifications => paginationState.items;
  bool get hasMore => paginationState.hasMore;
  String? get errorMessage => paginationState.errorMessage;

  NotificationState copyWith({
    PaginationState<NotificationItem>? paginationState,
    int? unreadCount,
    NotificationAction? pendingAction,
    bool clearPendingAction = false,
  }) {
    return NotificationState(
      paginationState: paginationState ?? this.paginationState,
      unreadCount: unreadCount ?? this.unreadCount,
      pendingAction:
          clearPendingAction ? null : (pendingAction ?? this.pendingAction),
    );
  }

  @override
  List<Object?> get props => [
        paginationState,
        unreadCount,
        pendingAction,
      ];
}
