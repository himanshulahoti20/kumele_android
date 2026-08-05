class FollowConnection {
  const FollowConnection({
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

  String? get location {
    final parts = [
      if (city != null && city!.trim().isNotEmpty) city!.trim(),
      if (country != null && country!.trim().isNotEmpty) country!.trim(),
    ];
    if (parts.isEmpty) return null;
    return parts.join(', ');
  }

  String? get subtitle {
    final trimmedBio = bio?.trim();
    if (trimmedBio != null && trimmedBio.isNotEmpty) return trimmedBio;

    final trimmedLocation = location;
    if (trimmedLocation != null && trimmedLocation.isNotEmpty) {
      return trimmedLocation;
    }

    final trimmedUsername = username?.trim();
    if (trimmedUsername != null && trimmedUsername.isNotEmpty) {
      return '@$trimmedUsername';
    }

    return null;
  }
}
