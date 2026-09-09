import 'package:kuemele/features/explore/domain/entities/explore_host_profile.dart';
import 'package:kuemele/shared/models/web3_models.dart';

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
    this.featuredNft,
    this.overallHostRating,
    this.eventCompletionRate,
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

  /// Set via `PUT /users/me/featured-nft` — the NFT this host has chosen
  /// to show on their public-facing profile/host card. Comes back nested
  /// inside an event's host info under the same `featuredNft` key.
  final NftItem? featuredNft;

  final double? overallHostRating;
  final double? eventCompletionRate;

  factory ExploreHostProfileModel.fromJson(Map<String, dynamic> json) {
    final highestMedal = _resolveHighestMedal(json);
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
      medalTier: highestMedal?.$1 ??
          (json['medalTier'] ??
                  json['medal_tier'] ??
                  json['rewardTier'] ??
                  json['reward_tier'])
              ?.toString(),
      medalCount: highestMedal?.$2 ??
          _parseInt(json['medalCount'] ?? json['medal_count']),
      featuredNft: json['featuredNft'] is Map
          ? NftItem.fromJson((json['featuredNft'] as Map).cast<String, dynamic>())
          : null,
      overallHostRating: _parseDouble(
        json['overallHostRating'] ?? json['overall_host_rating'],
      ),
      eventCompletionRate: _parseDouble(
        json['eventCompletionRate'] ?? json['event_completion_rate'],
      ),
    );
  }

  /// The live API nests per-tier counts under `medalCounts` (e.g.
  /// `{gold: 3, silver: 1, bronze: 0}`) rather than a single flat count.
  /// Returns the highest tier actually held (gold beats silver beats
  /// bronze) — never the sum of all three — or null if `medalCounts` is
  /// absent/empty so callers fall back to the flat legacy fields.
  static (String, int)? _resolveHighestMedal(Map<String, dynamic> json) {
    final raw = json['medalCounts'] ?? json['medal_counts'];
    if (raw is! Map) return null;
    final counts = Map<String, dynamic>.from(raw);

    for (final tier in const ['gold', 'silver', 'bronze']) {
      final count = _parseInt(counts[tier]) ?? 0;
      if (count > 0) return (tier, count);
    }
    return null;
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
      featuredNft: featuredNft,
      overallHostRating: overallHostRating,
      eventCompletionRate: eventCompletionRate,
    );
  }

  static int? _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '');
  }

  static double? _parseDouble(dynamic value) {
    if (value is double) return value;
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '');
  }
}
