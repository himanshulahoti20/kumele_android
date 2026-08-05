import 'package:kuemele/features/profile/presentation/connections/domain/entities/follow_connection.dart';

class FollowConnectionsPage {
  const FollowConnectionsPage({
    required this.users,
    required this.total,
    required this.page,
    required this.limit,
    this.hasNext = false,
  });

  final List<FollowConnection> users;
  final int total;
  final int page;
  final int limit;
  final bool hasNext;
}
