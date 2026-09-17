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

/// Marks the notification read (locally and on the server). Opening its
/// action is the tapping view's job — see `handleNotificationAction` — not a
/// bloc side-effect, so a tap only ever runs once no matter how many
/// screens share this bloc (the tablet keeps the Explore panel mounted
/// under the full Notifications page).
final class NotificationTapped extends NotificationEvent {
  const NotificationTapped(this.notificationId);

  final String notificationId;

  @override
  List<Object?> get props => [notificationId];
}

final class NotificationsMarkAllReadRequested extends NotificationEvent {
  const NotificationsMarkAllReadRequested();

  @override
  List<Object?> get props => [];
}
