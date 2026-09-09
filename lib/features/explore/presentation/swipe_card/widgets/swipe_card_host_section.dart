import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/core/responsive/responsive.dart';
import 'package:kuemele/features/explore/domain/entities/explore_event_detail.dart';
import 'package:kuemele/gen/assets.gen.dart';
import 'package:kuemele/l10n/app_localizations.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/app_shadows.dart';
import 'package:kuemele/shared/widgets/app_avatar.dart';
import 'package:kuemele/shared/widgets/kumele_asset_widget.dart';

class SwipeCardHostSection extends StatelessWidget {
  const SwipeCardHostSection({
    super.key,
    required this.detail,
    this.bannerVerticalPaddingFactor = HostStatsBanner.defaultVerticalPadding,
  });

  final ExploreEventDetail detail;

  /// See [HostStatsBanner.verticalPaddingFactor] — lets a caller shorten
  /// the yellow banner without shrinking the avatar it tucks behind.
  final double bannerVerticalPaddingFactor;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final hostName = detail.hostName;
    final hostBio = detail.hostProfile.bio?.trim() ?? '';
    final avatarPath = detail.hostProfile.avatarUrl;
    final hostRating = detail.averageHostRating ?? detail.averageEventRating;
    final avatarSize = responsive.w(
      responsive.pick(
        mobilePortrait: 96.0,
        tabletPortrait: 108.0,
      ),
    );
    final avatarOverlap = avatarSize * 0.48;
    final followersCount = detail.hostProfile.followersCount;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Padding(
          padding: EdgeInsets.only(top: avatarOverlap),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: ColorSet.hostTileColor,
              borderRadius: BorderRadius.circular(responsive.w(24)),
              boxShadow: AppShadows.primary,
            ),
            padding: EdgeInsets.fromLTRB(
              responsive.w(16),
              avatarOverlap + responsive.h(12),
              responsive.w(16),
              responsive.h(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _HostTitleRow(
                  responsive: responsive,
                  medalTier: detail.hostProfile.medalTier,
                  medalCount: detail.hostProfile.medalCount,
                ),
                if (hostBio.isNotEmpty) ...[
                  Gap(responsive.h(10)),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'About $hostName: ',
                          style: context.textTheme.bodyLargeBold.copyWith(
                            color: ColorSet.textColor,
                            fontSize: responsive.sp(15),
                          ),
                        ),
                        TextSpan(
                          text: hostBio,
                          style: context.textTheme.bodyLargeLight.copyWith(
                            fontSize: responsive.sp(15),
                            color: ColorSet.textColor,
                            height: 1.45,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: HostAvatarStatsRow(
            avatarUrl: avatarPath,
            hostName: hostName,
            avatarSize: avatarSize,
            followersCount: followersCount,
            hostRating: hostRating,
            // Null when the API doesn't supply it, which just omits the
            // line — same three-line banner the NFT preview shows.
            eventCompletionPercent:
                detail.hostProfile.eventCompletionRate?.round(),
            bannerVerticalPaddingFactor: bannerVerticalPaddingFactor,
          ),
        ),
      ],
    );
  }
}

class _HostTitleRow extends StatelessWidget {
  const _HostTitleRow({
    required this.responsive,
    this.medalTier,
    this.medalCount,
  });

  final ResponsiveData responsive;
  final String? medalTier;
  final int? medalCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          AppLocalizations.of(context)!.exploreSwipeCardHostLabel,
          style: context.textTheme.titleLargeBold.copyWith(
            fontSize: responsive.sp(18),
            color: ColorSet.textColor,
          ),
        ),
        Gap(responsive.w(12)),
        if (medalTier?.isNotEmpty == true || medalCount != null) ...[
          HostMedalBadge(count: medalCount),
          Gap(responsive.w(6)),
          Text(
            medalTier ?? '',
            style: context.textTheme.bodyLargeLight.copyWith(
              fontSize: responsive.sp(17),
              color: ColorSet.textColor,
            ),
          ),
        ],
      ],
    );
  }
}

class HostMedalBadge extends StatelessWidget {
  const HostMedalBadge({super.key, this.count, this.imageOverride});

  final int? count;

  /// When set (e.g. the user's featured NFT image), shown instead of the
  /// default medal icon — used on the NFT preview card.
  final String? imageOverride;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final medalSize = responsive.w(25);
    final hasImageOverride = imageOverride?.isNotEmpty == true;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Padding(
          padding: EdgeInsets.only(
            top: responsive.h(8),
            right: responsive.w(10),
          ),
          child: KumeleAssetWidget.square(
            assetPath:
                hasImageOverride ? imageOverride! : Assets.icons.medalPng.path,
            size: medalSize,
            fit: hasImageOverride ? BoxFit.cover : BoxFit.contain,
            borderRadius:
                hasImageOverride ? BorderRadius.circular(medalSize / 2) : null,
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: Container(
            padding: EdgeInsets.all(responsive.w(4)),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ColorSet.specialYellowColor,
            ),
            child: count == null
                ? const SizedBox.shrink()
                : Text(
                    '$count',
                    style: context.textTheme.labelSmallBold.copyWith(
                      fontSize: responsive.sp(12),
                      // Yellow badge doesn't change with theme, so neither
                      // does its text — same rule as the stats banner.
                      color: Colors.black,
                      height: 1,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}

/// Host avatar with the yellow stats banner tucked in behind it: the
/// banner's left edge (and its rounded top-left/bottom-left corners) sit
/// inside the avatar circle, and the rest extends out to the right.
///
/// Every metric is derived from [avatarSize] so the tuck stays correct at
/// any size — the avatar and the overlap math must never be given
/// separately-scaled values, or the banner drifts off the circle.
class HostAvatarStatsRow extends StatelessWidget {
  const HostAvatarStatsRow({
    super.key,
    required this.avatarUrl,
    required this.hostName,
    required this.avatarSize,
    required this.followersCount,
    required this.hostRating,
    this.eventCompletionPercent,
    this.bannerVerticalPaddingFactor = HostStatsBanner.defaultVerticalPadding,
  });

  final String? avatarUrl;
  final String hostName;
  final double avatarSize;
  final int? followersCount;
  final double? hostRating;
  final int? eventCompletionPercent;

  /// Passed through to [HostStatsBanner.verticalPaddingFactor] — lets a
  /// caller keep a large avatar without the banner growing as tall.
  final double bannerVerticalPaddingFactor;

  /// Banner's left edge as a fraction of the avatar's diameter. Sits far
  /// enough right of the circle's centre that the banner's corners stay
  /// inside the circle across its full height.
  static const double _bannerInset = 0.58;

  @override
  Widget build(BuildContext context) {
    // A tight SizedBox(height: avatarSize) overflowed whenever the banner
    // grew a 3rd line (eventCompletionPercent present) — that content can
    // need more height than the avatar's diameter. minHeight keeps the row
    // at least avatarSize tall (so the avatar itself still has room) while
    // letting the banner grow past it when it needs to.
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: avatarSize),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.centerLeft,
        children: [
          if (followersCount != null || hostRating != null)
            Padding(
              padding: EdgeInsets.only(left: avatarSize * _bannerInset),
              child: HostStatsBanner(
                avatarSize: avatarSize,
                followersCount: followersCount,
                hostRating: hostRating,
                eventCompletionPercent: eventCompletionPercent,
                verticalPaddingFactor: bannerVerticalPaddingFactor,
              ),
            ),
          AppAvatar(
            imageUrl: avatarUrl,
            name: hostName,
            size: avatarSize,
          ),
        ],
      ),
    );
  }
}

class HostStatsBanner extends StatelessWidget {
  const HostStatsBanner({
    super.key,
    required this.avatarSize,
    required this.followersCount,
    required this.hostRating,
    this.eventCompletionPercent,
    this.verticalPaddingFactor = defaultVerticalPadding,
  });

  /// Top/bottom padding as a fraction of [avatarSize].
  static const double defaultVerticalPadding = 0.11;

  /// Drives every metric below so the banner stays proportional to the
  /// avatar it tucks behind — see [HostAvatarStatsRow].
  final double avatarSize;
  final int? followersCount;
  final double? hostRating;

  /// Third banner line, e.g. "92% Event Completion" — opt-in, only used
  /// where that stat is actually available.
  final int? eventCompletionPercent;

  /// Lets a caller with a large avatar keep the banner short instead of
  /// having its height scale up with the circle.
  final double verticalPaddingFactor;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final isPhone = context.responsive.isPhone;

    final deviceWidth = MediaQuery.sizeOf(context).width;

    final pill = Container(
      padding: EdgeInsets.fromLTRB(
        // Left stays proportional to the avatar — it's what sets the tuck
        // depth (how far the pill's rounded left edge sits behind the
        // circle), not part of the visible width budget above.
        avatarSize * 0.55,
        avatarSize * verticalPaddingFactor,
        8,
        avatarSize * verticalPaddingFactor,
      ),
      decoration: BoxDecoration(
        color: ColorSet.specialYellowColor,
        borderRadius: BorderRadius.circular(avatarSize * 0.10),
      ),
      // This chip's yellow background doesn't change with theme, so every
      // text/icon color inside it below is hardcoded black regardless of
      // theme too — matches the iOS source (`.foregroundStyle(.black)`,
      // explicitly documented as not following dark mode).
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (followersCount != null)
            Text(
              '$followersCount ${AppLocalizations.of(context)!.exploreSwipeCardFollowersSuffix}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.textTheme.titleLargeBold.copyWith(
                fontSize: responsive.sp(17),
                color: Colors.black,
                height: 1.1,
              ),
            ),
          if (followersCount != null) Gap(responsive.h(2)),
          if (hostRating != null)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                KumeleAssetWidget.square(
                  assetPath: Assets.icons.star.path,
                  size: responsive.w(15),
                  color: Colors.black,
                ),
                Gap(responsive.w(4)),
                Flexible(
                  child: Text(
                    '${hostRating!.toStringAsFixed(1)} ${AppLocalizations.of(context)!.exploreSwipeCardOverallRatingsLabel}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.bodySmallLight.copyWith(
                      fontSize: responsive.sp(12),
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          if (eventCompletionPercent != null) ...[
            Gap(responsive.h(2)),
            Text(
              '$eventCompletionPercent% Event Completion',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.textTheme.bodySmallLight.copyWith(
                fontSize: responsive.sp(12),
                color: Colors.black,
              ),
            ),
          ],
        ],
      ),
    );

    // Tablet: unchanged fixed fraction of the screen width. Phone: size to
    // content instead of guessing a fraction — the follower/rating/
    // completion combination varies too much in length for one magic
    // number to fit every case without either truncating or wasting space.
    // Text still carries maxLines+ellipsis as a fallback for extreme cases.
    if (!isPhone) {
      return SizedBox(width: deviceWidth * 0.18, child: pill);
    }
    return ConstrainedBox(
      // Generous cap so extreme-length text still ellipsizes rather than
      // running off-screen; ordinary content sizes well under this.
      constraints: BoxConstraints(maxWidth: deviceWidth * 0.85),
      child: IntrinsicWidth(child: pill),
    );
  }
}
