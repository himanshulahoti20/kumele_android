class ExploreHostProfile {
  const ExploreHostProfile({
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
}
