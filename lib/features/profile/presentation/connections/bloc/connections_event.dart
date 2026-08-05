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

enum ConnectionsTab {
  followers,
  following,
}
