import 'package:kuemele/features/profile/presentation/connections/data/datasources/connections_remote_data_source.dart';
import 'package:kuemele/features/profile/presentation/connections/domain/entities/follow_connections_page.dart';
import 'package:kuemele/features/profile/presentation/connections/domain/repositories/connections_repository.dart';
import 'package:kuemele/shared/models/follow_stats.dart';

class ConnectionsRepositoryImpl implements ConnectionsRepository {
  ConnectionsRepositoryImpl({ConnectionsRemoteDataSource? remoteDataSource})
      : _remoteDataSource = remoteDataSource ?? ConnectionsRemoteDataSource();

  final ConnectionsRemoteDataSource _remoteDataSource;

  @override
  Future<FollowConnectionsPage> getFollowers({
    required String userId,
    int page = 1,
    int limit = 10,
  }) async {
    final pageModel = await _remoteDataSource.fetchFollowers(
      userId: userId,
      page: page,
      limit: limit,
    );

    return pageModel.toEntity();
  }

  @override
  Future<FollowConnectionsPage> getFollowing({
    required String userId,
    int page = 1,
    int limit = 10,
  }) async {
    final pageModel = await _remoteDataSource.fetchFollowing(
      userId: userId,
      page: page,
      limit: limit,
    );

    return pageModel.toEntity();
  }

  @override
  Future<FollowStats> getFollowStats({required String userId}) {
    return _remoteDataSource.fetchFollowStats(userId: userId);
  }

  @override
  Future<void> follow({required String userId}) {
    return _remoteDataSource.follow(userId: userId);
  }

  @override
  Future<void> unfollow({required String userId}) {
    return _remoteDataSource.unfollow(userId: userId);
  }
}
