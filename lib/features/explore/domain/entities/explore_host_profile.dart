class ExploreHostProfile {
  const ExploreHostProfile({
    required this.id,
    required this.displayName,
    this.firstName,
    this.lastName,
    this.avatarUrl,
    this.bio,
  });

  final String id;
  final String displayName;
  final String? firstName;
  final String? lastName;
  final String? avatarUrl;
  final String? bio;
}
