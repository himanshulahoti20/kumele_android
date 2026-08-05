import 'package:kuemele/features/profile/presentation/connections/data/datasources/connections_remote_data_source.dart';
import 'package:kuemele/features/profile/presentation/connections/domain/entities/follow_connections_page.dart';
import 'package:kuemele/features/profile/presentation/connections/domain/repositories/connections_repository.dart';

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
}
