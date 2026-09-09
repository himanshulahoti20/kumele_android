import 'package:kuemele/shared/models/web3_models.dart';

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

  /// The NFT this host has chosen to show on their public-facing
  /// profile/host card, distinct from [medalTier] (their reward tier).
  final NftItem? featuredNft;

  final double? overallHostRating;
  final double? eventCompletionRate;

  /// Merges the dedicated `/users/hostProfile/:id` response ([full]) over
  /// this event-embedded profile, preferring [full]'s fields but falling
  /// back to this one's wherever [full] doesn't have a value — the embedded
  /// profile is often missing followers/medal/bio entirely.
  ExploreHostProfile mergedWith(ExploreHostProfile full) {
    return ExploreHostProfile(
      id: full.id.isNotEmpty ? full.id : id,
      displayName: full.displayName.isNotEmpty ? full.displayName : displayName,
      firstName: full.firstName ?? firstName,
      lastName: full.lastName ?? lastName,
      avatarUrl: full.avatarUrl ?? avatarUrl,
      bio: full.bio ?? bio,
      followersCount: full.followersCount ?? followersCount,
      medalTier: full.medalTier ?? medalTier,
      medalCount: full.medalCount ?? medalCount,
      featuredNft: full.featuredNft ?? featuredNft,
      overallHostRating: full.overallHostRating ?? overallHostRating,
      eventCompletionRate: full.eventCompletionRate ?? eventCompletionRate,
    );
  }
}
