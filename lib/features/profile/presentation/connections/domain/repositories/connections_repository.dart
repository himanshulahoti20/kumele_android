import 'package:kuemele/features/profile/presentation/connections/domain/entities/follow_connections_page.dart';
import 'package:kuemele/shared/models/follow_stats.dart';

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

  Future<FollowStats> getFollowStats({required String userId});

  Future<void> follow({required String userId});

  Future<void> unfollow({required String userId});
}
