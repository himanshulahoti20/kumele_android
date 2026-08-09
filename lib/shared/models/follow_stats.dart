class FollowStats {
  const FollowStats({required this.followers, required this.following});

  final int followers;
  final int following;

  factory FollowStats.fromJson(Map<String, dynamic> json) {
    return FollowStats(
      followers: _parseInt(
        json['followers'] ??
            json['followerCount'] ??
            json['followersCount'] ??
            json['totalFollowers'],
      ),
      following: _parseInt(
        json['following'] ??
            json['followingCount'] ??
            json['totalFollowing'],
      ),
    );
  }

  static const empty = FollowStats(followers: 0, following: 0);

  static int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}
