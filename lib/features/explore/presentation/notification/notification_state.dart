import 'package:equatable/equatable.dart';
import 'package:kuemele/features/explore/presentation/notification/notification_data.dart';
import 'package:kuemele/shared/services/pagination/pagination_state.dart';

class NotificationState extends Equatable {
  const NotificationState({
    this.paginationState = const PaginationState(),
    this.unreadCount = 0,
  });

  final PaginationState<NotificationItem> paginationState;
  final int unreadCount;

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
  }) {
    return NotificationState(
      paginationState: paginationState ?? this.paginationState,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }

  @override
  List<Object?> get props => [paginationState, unreadCount];
}
