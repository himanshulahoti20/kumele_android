import 'package:kuemele/features/profile/presentation/connections/domain/entities/follow_connection.dart';

class FollowConnectionModel {
  const FollowConnectionModel({
    required this.id,
    required this.displayName,
    this.username,
    this.profilePicture,
    this.bio,
    this.city,
    this.country,
    this.followedAt,
  });

  final String id;
  final String displayName;
  final String? username;
  final String? profilePicture;
  final String? bio;
  final String? city;
  final String? country;
  final DateTime? followedAt;

  factory FollowConnectionModel.fromJson(Map<String, dynamic> json) {
    final source = _resolveUserPayload(json);

    return FollowConnectionModel(
      id: _resolveId(source, json),
      displayName: _resolveDisplayName(source),
      username: source['username']?.toString(),
      profilePicture: (source['profilePicture'] ??
              source['profilepicture'] ??
              source['avatar'] ??
              source['avatarUrl'] ??
              source['profile_picture'])
          ?.toString(),
      bio: source['bio']?.toString(),
      city: source['city']?.toString(),
      country: source['country']?.toString(),
      followedAt: _parseDateTime(
        source['followedAt'] ?? source['followed_at'],
      ),
    );
  }

  FollowConnection toEntity() {
    return FollowConnection(
      id: id,
      displayName: displayName,
      username: username,
      profilePicture: profilePicture,
      bio: bio,
      city: city,
      country: country,
      followedAt: followedAt,
    );
  }

  static Map<String, dynamic> _resolveUserPayload(Map<String, dynamic> json) {
    for (final key in const [
      'user',
      'follower',
      'following',
      'followedUser',
      'followed',
    ]) {
      final nested = json[key];
      if (nested is Map) {
        return Map<String, dynamic>.from(nested);
      }
    }

    return json;
  }

  static String _resolveId(
    Map<String, dynamic> source,
    Map<String, dynamic> root,
  ) {
    final directId = source['id']?.toString();
    if (directId != null && directId.isNotEmpty) {
      return directId;
    }

    return root['userId']?.toString() ??
        root['followerId']?.toString() ??
        root['followingId']?.toString() ??
        '';
  }

  static String _resolveDisplayName(Map<String, dynamic> json) {
    final displayName =
        json['displayName'] as String? ?? json['display_name'] as String?;
    if (displayName != null && displayName.trim().isNotEmpty) {
      return displayName.trim();
    }

    final fullName = json['fullname'] as String? ?? json['fullName'] as String?;
    if (fullName != null && fullName.trim().isNotEmpty) {
      return fullName.trim();
    }

    final firstName =
        json['firstName'] as String? ?? json['first_name'] as String? ?? '';
    final lastName =
        json['lastName'] as String? ?? json['last_name'] as String? ?? '';
    final combined = '$firstName $lastName'.trim();
    if (combined.isNotEmpty) return combined;

    final username = json['username']?.toString().trim();
    if (username != null && username.isNotEmpty) return username;

    return 'User';
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }
}
