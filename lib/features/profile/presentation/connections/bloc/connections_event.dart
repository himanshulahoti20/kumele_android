sealed class ConnectionsEvent {
  const ConnectionsEvent();
}

class ConnectionsInit extends ConnectionsEvent {
  const ConnectionsInit({this.selectedTab});

  final String? selectedTab;
}

class ConnectionsTabChanged extends ConnectionsEvent {
  const ConnectionsTabChanged(this.tab);

  final ConnectionsTab tab;
}

class ConnectionsRetry extends ConnectionsEvent {
  const ConnectionsRetry();
}

/// Long-press on a row: enters selection mode with that row pre-selected.
class ConnectionsSelectionStarted extends ConnectionsEvent {
  const ConnectionsSelectionStarted(this.userId);

  final String userId;
}

class ConnectionsSelectionToggled extends ConnectionsEvent {
  const ConnectionsSelectionToggled(this.userId);

  final String userId;
}

class ConnectionsSelectAllToggled extends ConnectionsEvent {
  const ConnectionsSelectAllToggled();
}

class ConnectionsSelectionCancelled extends ConnectionsEvent {
  const ConnectionsSelectionCancelled();
}

/// Fired after the "Are you sure you want to unfollow?" dialog is confirmed.
class ConnectionsRemoveSelectedConfirmed extends ConnectionsEvent {
  const ConnectionsRemoveSelectedConfirmed();
}

enum ConnectionsTab {
  followers,
  following,
}
