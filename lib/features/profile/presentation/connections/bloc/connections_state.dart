import 'package:kuemele/features/profile/presentation/connections/bloc/connections_event.dart';
import 'package:kuemele/features/profile/presentation/connections/domain/entities/follow_connection.dart';

enum ConnectionsStatus {
  initial,
  loading,
  loaded,
  failure,
}

class ConnectionsState {
  const ConnectionsState({
    this.selectedTab = ConnectionsTab.followers,
    this.followersStatus = ConnectionsStatus.initial,
    this.followingStatus = ConnectionsStatus.initial,
    this.followers = const [],
    this.following = const [],
    this.followersTotal = 0,
    this.followingTotal = 0,
    this.errorMessage,
    this.isSelectionMode = false,
    this.selectedIds = const {},
  });

  final ConnectionsTab selectedTab;
  final ConnectionsStatus followersStatus;
  final ConnectionsStatus followingStatus;
  final List<FollowConnection> followers;
  final List<FollowConnection> following;
  final int followersTotal;
  final int followingTotal;
  final String? errorMessage;
  final bool isSelectionMode;
  final Set<String> selectedIds;

  bool get isLoadingFollowers => followersStatus == ConnectionsStatus.loading;

  bool get isLoadingFollowing => followingStatus == ConnectionsStatus.loading;

  bool get isLoading => switch (selectedTab) {
        ConnectionsTab.followers => isLoadingFollowers,
        ConnectionsTab.following => isLoadingFollowing,
      };

  List<FollowConnection> get activeUsers =>
      selectedTab == ConnectionsTab.followers ? followers : following;

  int get activeTotal =>
      selectedTab == ConnectionsTab.followers ? followersTotal : followingTotal;

  ConnectionsStatus get activeStatus => selectedTab == ConnectionsTab.followers
      ? followersStatus
      : followingStatus;

  bool get isAllSelected =>
      activeUsers.isNotEmpty &&
      activeUsers.every((user) => selectedIds.contains(user.id));

  ConnectionsState copyWith({
    ConnectionsTab? selectedTab,
    ConnectionsStatus? followersStatus,
    ConnectionsStatus? followingStatus,
    List<FollowConnection>? followers,
    List<FollowConnection>? following,
    int? followersTotal,
    int? followingTotal,
    String? errorMessage,
    bool clearErrorMessage = false,
    bool? isSelectionMode,
    Set<String>? selectedIds,
  }) {
    return ConnectionsState(
      selectedTab: selectedTab ?? this.selectedTab,
      followersStatus: followersStatus ?? this.followersStatus,
      followingStatus: followingStatus ?? this.followingStatus,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      followersTotal: followersTotal ?? this.followersTotal,
      followingTotal: followingTotal ?? this.followingTotal,
      errorMessage:
          clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
      isSelectionMode: isSelectionMode ?? this.isSelectionMode,
      selectedIds: selectedIds ?? this.selectedIds,
    );
  }
}
