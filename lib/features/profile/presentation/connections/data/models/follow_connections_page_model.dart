import 'package:kuemele/features/profile/presentation/connections/data/models/follow_connection_model.dart';
import 'package:kuemele/features/profile/presentation/connections/domain/entities/follow_connections_page.dart';
import 'package:kuemele/shared/services/api_service/api_service.dart';

class FollowConnectionsPageModel {
  const FollowConnectionsPageModel({
    required this.users,
    required this.total,
    required this.page,
    required this.limit,
    this.hasNext = false,
  });

  final List<FollowConnectionModel> users;
  final int total;
  final int page;
  final int limit;
  final bool hasNext;

  factory FollowConnectionsPageModel.empty({
    required int page,
    required int limit,
  }) {
    return FollowConnectionsPageModel(
      users: const [],
      total: 0,
      page: page,
      limit: limit,
    );
  }

  factory FollowConnectionsPageModel.fromResponse(
    dynamic response, {
    int fallbackPage = 1,
    int fallbackLimit = 20,
  }) {
    final json = _asJsonMap(response);
    final payload = _unwrapPagePayload(json);
    final usersJson = _resolveUsersJson(payload, json, response);
    final users = _parseUsers(usersJson);
    final meta = _readMeta(payload, json);

    final page = _parseInt(meta['page'], fallback: fallbackPage);
    final limit = _parseInt(meta['limit'], fallback: fallbackLimit);
    final total = _parseInt(
      meta['total'] ??
          meta['totalCount'] ??
          meta['total_count'] ??
          payload['total'] ??
          json['total'],
      fallback: users.length,
    );
    final totalPages = _parseInt(
      meta['totalPages'] ?? meta['total_pages'],
      fallback: total == 0 ? 0 : ((total + limit - 1) / limit).ceil(),
    );
    final hasNext = meta['hasNext'] == true ||
        meta['has_next'] == true ||
        (totalPages > 0 && page < totalPages) ||
        (page * limit < total);

    return FollowConnectionsPageModel(
      users: users,
      total: total,
      page: page,
      limit: limit,
      hasNext: hasNext,
    );
  }

  FollowConnectionsPage toEntity() {
    return FollowConnectionsPage(
      users: users.map((user) => user.toEntity()).toList(),
      total: total,
      page: page,
      limit: limit,
      hasNext: hasNext,
    );
  }

  static Map<String, dynamic> _asJsonMap(dynamic response) {
    if (response is Map<String, dynamic>) return response;
    if (response is Map) return Map<String, dynamic>.from(response);
    return {};
  }

  static Map<String, dynamic> _unwrapPagePayload(Map<String, dynamic> json) {
    final data = json['data'];
    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }
    return json;
  }

  static Map<String, dynamic> _readMeta(
    Map<String, dynamic> payload,
    Map<String, dynamic> root,
  ) {
    final meta = payload['meta'] ?? root['meta'] ?? payload['pagination'];
    if (meta is Map<String, dynamic>) return meta;
    if (meta is Map) return Map<String, dynamic>.from(meta);
    return const {};
  }

  static dynamic _resolveUsersJson(
    Map<String, dynamic> payload,
    Map<String, dynamic> root,
    dynamic response,
  ) {
    for (final key in const [
      'data',
      'items',
      'users',
      'followers',
      'following',
      'results',
    ]) {
      final candidate = payload[key] ?? root[key];
      if (candidate is List) return candidate;
    }

    return ApiService.extractList(response);
  }

  static List<FollowConnectionModel> _parseUsers(dynamic usersJson) {
    if (usersJson is! List) return const [];

    return usersJson
        .whereType<Map>()
        .map(
          (item) => FollowConnectionModel.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
        .where((user) => user.id.isNotEmpty)
        .toList();
  }

  static int _parseInt(dynamic value, {required int fallback}) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? fallback;
  }
}
