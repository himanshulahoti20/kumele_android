import 'package:kuemele/features/explore/domain/entities/explore_host_profile.dart';

class ExploreHostProfileModel {
  const ExploreHostProfileModel({
    required this.id,
    required this.displayName,
    this.firstName,
    this.lastName,
    this.avatarUrl,
    this.bio,
    this.followersCount,
    this.medalTier,
    this.medalCount,
  });

  final String id;
  final String displayName;
  final String? firstName;
  final String? lastName;
  final String? avatarUrl;
  final String? bio;
  final int? followersCount;
  final String? medalTier;
  final int? medalCount;

  factory ExploreHostProfileModel.fromJson(Map<String, dynamic> json) {
    return ExploreHostProfileModel(
      id: json['id']?.toString() ?? '',
      displayName: _resolveDisplayName(json),
      firstName: (json['firstName'] ?? json['first_name'])?.toString(),
      lastName: (json['lastName'] ?? json['last_name'])?.toString(),
      avatarUrl: (json['avatar'] ?? json['avatarUrl'] ?? json['profilePicture'])
          ?.toString(),
      bio: (json['bio'] ?? json['aboutMe'] ?? json['about_me'])?.toString(),
      followersCount:
          _parseInt(json['followersCount'] ?? json['followers_count']),
      medalTier: (json['medalTier'] ??
              json['medal_tier'] ??
              json['rewardTier'] ??
              json['reward_tier'])
          ?.toString(),
      medalCount:
          _parseInt(json['medalCount'] ?? json['medal_count'] ?? json['gold']),
    );
  }

  static String _resolveDisplayName(Map<String, dynamic> json) {
    final displayName =
        json['displayName'] as String? ?? json['display_name'] as String?;
    if (displayName != null && displayName.trim().isNotEmpty) {
      return displayName.trim();
    }

    final firstName =
        json['firstName'] as String? ?? json['first_name'] as String? ?? '';
    final lastName =
        json['lastName'] as String? ?? json['last_name'] as String? ?? '';
    return '$firstName $lastName'.trim();
  }

  ExploreHostProfile toEntity() {
    return ExploreHostProfile(
      id: id,
      displayName: displayName,
      firstName: firstName,
      lastName: lastName,
      avatarUrl: avatarUrl,
      bio: bio,
      followersCount: followersCount,
      medalTier: medalTier,
      medalCount: medalCount,
    );
  }

  static int? _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '');
  }
}
