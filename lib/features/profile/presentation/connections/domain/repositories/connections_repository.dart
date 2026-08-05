import 'package:kuemele/features/profile/presentation/connections/domain/entities/follow_connections_page.dart';

abstract class ConnectionsRepository {
  Future<FollowConnectionsPage> getFollowers({
    required String userId,
    int page = 1,
    int limit = 10,
  });

  Future<FollowConnectionsPage> getFollowing({
    required String userId,
    int page = 1,
    int limit = 10,
  });
}
