import 'package:equatable/equatable.dart';

sealed class NotificationEvent extends Equatable {
  const NotificationEvent();
}

final class NotificationsRequested extends NotificationEvent {
  const NotificationsRequested({this.refresh = false});

  final bool refresh;

  @override
  List<Object?> get props => [refresh];
}

final class NotificationsLoadMoreRequested extends NotificationEvent {
  const NotificationsLoadMoreRequested();

  @override
  List<Object?> get props => [];
}

final class NotificationsRetryRequested extends NotificationEvent {
  const NotificationsRetryRequested();

  @override
  List<Object?> get props => [];
}

final class NotificationTapped extends NotificationEvent {
  const NotificationTapped(this.notificationId);

  final String notificationId;

  @override
  List<Object?> get props => [notificationId];
}

final class NotificationActionCleared extends NotificationEvent {
  const NotificationActionCleared();

  @override
  List<Object?> get props => [];
}
