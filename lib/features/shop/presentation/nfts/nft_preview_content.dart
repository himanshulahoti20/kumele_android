import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/features/explore/domain/entities/explore_host_profile.dart';
import 'package:kuemele/features/explore/presentation/swipe_card/widgets/swipe_card_host_section.dart'
    show HostAvatarStatsRow, HostMedalBadge;
import 'package:kuemele/features/shop/presentation/nfts/nft_card_deck.dart'
    show nftArtworkCrop;
import 'package:kuemele/gen/assets.gen.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/icons.dart';
import 'package:kuemele/shared/models/history_statistics_models.dart';
import 'package:kuemele/shared/models/web3_models.dart';
import 'package:kuemele/shared/services/api_service/profile/profile_repo.dart';
import 'package:kuemele/shared/services/api_service/statistics/statistics_repo.dart';
import 'package:kuemele/shared/widgets/app_svg_image.dart';
import 'package:kuemele/shared/widgets/kumele_asset_widget.dart';
import 'package:kuemele/shared/widgets/kumele_video_player.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:kuemele/l10n/app_localizations.dart';

/// This preview's own price rule — not the shared `nftPriceStatusText`
/// (which checks isOwned/isComingSoon first and can return blank). Matches
/// the real iOS `nftPriceText` exactly: this screen is reached from the
/// Claimed tab, where the item is already owned, so ownership status isn't
/// shown here at all — it's just "Free" or the price, and it always falls
/// back to "Free" rather than ever going blank.
String _previewPriceText(NftItem item) {
  if (item.isFree) return 'Free';
  if (item.price != null) {
    final formatter = NumberFormat.currency(
      name: (item.currency == null || item.currency!.isEmpty)
          ? 'EUR'
          : item.currency,
      symbol: '${item.currency ?? 'EUR'} ',
    );
    return formatter.format(item.price);
  }
  return 'Free';
}

/// NFT Preview overlay — see AI/14_NFTModulePixelPerfectUIGuide.md §3.8 and
/// the real iOS source (`NFTPreviewContentView.swift`, shared by iPhone and
/// iPad). Reachable only from the Claimed tab in expanded mode via the NFT
/// Preview toggle; replaces the card's normal content entirely, inside the
/// same card chrome.
///
/// Always a mock of "how this NFT looks on your profile" — every field is
/// either the NFT's own (title/description/price/image) or the signed-in
/// user's own profile/stats (avatar, bio, followers, host rating, event-
/// completion rate, city/country, total events attended). There is no
/// concept of a linked "event" here on iOS — an earlier version of this
/// file incorrectly fetched one via a (nonexistent-on-iOS) `eventId`.
class NftPreviewContent extends StatefulWidget {
  const NftPreviewContent({
    super.key,
    required this.item,
    required this.onClose,
  });

  final NftItem item;
  final VoidCallback onClose;

  @override
  State<NftPreviewContent> createState() => _NftPreviewContentState();
}

class _NftPreviewContentState extends State<NftPreviewContent> {
  NftItem get item => widget.item;
  VoidCallback get onClose => widget.onClose;

  ExploreHostProfile? _hostProfile;
  UserActivityStats? _stats;

  @override
  void initState() {
    super.initState();
    // Opening the preview *is* the "set as featured" action — no button,
    // no confirmation. Fire-and-forget; silent on failure too.
    _setAsFeatured();
    _loadHostProfileIfNeeded();
    _loadStatsIfNeeded();
    _loadUserDataIfNeeded();
  }

  // The preview shows the real signed-in user's avatar/bio — if this
  // screen is reached before the profile tab has ever loaded them,
  // InjectionHelper.profileCubit.userData is still null, so fetch it here.
  Future<void> _loadUserDataIfNeeded() async {
    if (InjectionHelper.profileCubit.userData != null) return;
    await InjectionHelper.profileCubit.loadUserData();
    if (mounted) setState(() {});
  }

  Future<void> _setAsFeatured() async {
    if (InjectionHelper.profileCubit.userData?.featuredNft?.id == item.id) {
      return;
    }
    try {
      final response = await ProfileRepo.setFeaturedNft(item.id);
      // The endpoint's response body only contains `{ featuredNft: {...} }`
      // — every other field comes back null/default. `UserModel.fromJson`
      // on it produces an almost-empty user, and assigning that wholesale
      // wiped out the real name/avatar/bio already loaded from the profile
      // API, so the preview (and anything else reading userData) briefly
      // showed correct content, then "trashed" once this landed. Only take
      // the one field this call actually updated.
      final updatedFeaturedNft = response?.data?.featuredNft;
      final currentUser = InjectionHelper.profileCubit.userData;
      if (updatedFeaturedNft != null && currentUser != null) {
        InjectionHelper.profileCubit.userData =
            currentUser.copyWith(featuredNft: updatedFeaturedNft);
      }
    } catch (_) {}
  }

  // Rating + event-completion for the yellow stats banner both come from
  // GET /users/{id}/host-profile. No fallback for eventCompletionRate if
  // this hasn't loaded (matches iOS: shows 0% while pending, no error UI).
  Future<void> _loadHostProfileIfNeeded() async {
    final userId = InjectionHelper.profileCubit.userData?.id;
    if (userId == null || userId.isEmpty) return;
    try {
      final profile =
          await InjectionHelper.exploreRepository.getHostProfile(userId);
      if (mounted) setState(() => _hostProfile = profile);
    } catch (_) {}
  }

  // Fallback source for overallHostRating only, fetched in parallel with
  // the host profile — GET /users/me/stats has no completion-rate field.
  Future<void> _loadStatsIfNeeded() async {
    try {
      final stats = await StatisticsRepo.getMyStats();
      if (mounted) setState(() => _stats = stats);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final userData = InjectionHelper.profileCubit.userData;
    final profileState = InjectionHelper.profilePageBloc.state;
    final hostName = (userData?.fullname?.trim().isNotEmpty ?? false)
        ? userData!.fullname!.trim()
        : (userData?.username?.trim().isNotEmpty ?? false)
            ? userData!.username!.trim()
            : AppLocalizations.of(context)!.blogCommentAuthorYou;
    final bio = userData?.aboutMe?.trim() ?? '';

    // No scrolling here — the expanded card grows to fit this instead;
    // the page around the deck already scrolls.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _imageArea(),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 24, 18, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        AppLocalizations.of(context)!.nftPreviewTitle,
                        style: context.textTheme.bodyLargeBold.copyWith(
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    _iconButton(
                      assetPath: IconSet.shareIcon,
                      onTap: () => SharePlus.instance.share(
                        ShareParams(text: '${item.title}\n${item.description}'),
                      ),
                    ),
                  ],
                ),
                const Gap(20),
                _metaSection(context, userData?.city, userData?.country),
                if (item.title.isNotEmpty || item.description.isNotEmpty) ...[
                  const Gap(20),
                  Text(
                    '🌟 ${item.title}',
                    style: context.textTheme.bodyLargeBold.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (item.description.isNotEmpty) ...[
                    const Gap(4),
                    Text(
                      item.description,
                      style: context.textTheme.bodyLarge.copyWith(
                        fontSize: 15,
                        height: 1.2,
                        color: ColorSet.textColor.withValues(alpha: 0.85),
                      ),
                    ),
                  ],
                ],
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: _ProfilePreviewCard(
              hostName: hostName,
              bio: bio,
              avatarUrl: userData?.profilePicture,
              followers: profileState.followersCount,
              medalTier: profileState.topMedalTier,
              medalCount: profileState.topMedalCount,
              featuredNftImage: item.imageUrl ?? item.thumbnailUrl,
              hostRating:
                  _hostProfile?.overallHostRating ?? _stats?.hostRatingAverage ?? 0,
              eventCompletionPercent:
                  (_hostProfile?.eventCompletionRate ?? 0).round(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 28, 18, 18),
            child: Center(
              child: GestureDetector(
                onTap: onClose,
                child: Container(
                  width: 194,
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: ColorSet.revbg3Color,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.nftClosePreviewLabel,
                    style: context.textTheme.bodyLarge.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: ColorSet.bg2Color,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
    );
  }

  Widget _imageArea() {
    return SizedBox(
      height: 260,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(color: ColorSet.tileFillColor),
          if (item.animationUrl?.isNotEmpty == true && item.animationIsVideo)
            nftArtworkCrop(
              child: KumeleVideoPlayer(
                key: ValueKey(item.animationUrl),
                videoPath: item.animationUrl!,
                isNetwork: true,
                fit: BoxFit.fill,
                muted: true,
                loop: true,
                errorFallback: (item.imageUrl ?? item.thumbnailUrl)
                            ?.isNotEmpty ==
                        true
                    ? KumeleAssetWidget(
                        assetPath: item.imageUrl ?? item.thumbnailUrl!,
                        width: double.infinity,
                        height: 260,
                        fit: BoxFit.fill,
                      )
                    : null,
              ),
            )
          else if (item.animationUrl?.isNotEmpty == true)
            // gif/webp — the video player can't decode these.
            nftArtworkCrop(
              child: KumeleAssetWidget(
                key: ValueKey(item.animationUrl),
                assetPath: item.animationUrl!,
                width: double.infinity,
                height: 260,
                fit: BoxFit.fill,
              ),
            )
          else if ((item.imageUrl ?? item.thumbnailUrl)?.isNotEmpty == true)
            nftArtworkCrop(
              child: KumeleAssetWidget(
                assetPath: item.imageUrl ?? item.thumbnailUrl!,
                width: double.infinity,
                height: 260,
                fit: BoxFit.fill,
              ),
            )
          else
            Center(
              child: Icon(
                Icons.image_not_supported_outlined,
                color: ColorSet.textColor.withValues(alpha: 0.3),
                size: 48,
              ),
            ),
          if ((item.nftType ?? item.category ?? '').isNotEmpty)
            Positioned(
              top: 12,
              right: 12,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: ColorSet.revbg3Color.withValues(alpha: 0.75),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  item.nftType ?? item.category!,
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    color: ColorSet.bg2Color,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Matches the real iOS `metaSection`: ticket+price and guests side by
  // side (guests = the signed-in user's own total events attended, not
  // any event's attendee count — there's no "event" concept here), then a
  // location row below (signed-in user's own city/country) that opens a
  // maps app on tap.
  Widget _metaSection(BuildContext context, String? city, String? country) {
    final guestCount = _stats?.eventsAttended;
    final location =
        [city, country].where((v) => (v ?? '').trim().isNotEmpty).join(', ');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            AppSvgImage(
              assetName: IconSet.ticketsIcon,
              width: 20,
              height: 20,
              color: ColorSet.textColor,
            ),
            const Gap(8),
            Text(
              _previewPriceText(item),
              style: context.textTheme.bodyLarge
                  .copyWith(fontSize: 17, fontWeight: FontWeight.w400),
            ),
            if (guestCount != null) ...[
              const Gap(10),
              KumeleAssetWidget.square(
                assetPath: Assets.icons.guests.path,
                size: 20,
                color: ColorSet.textColor.withValues(alpha: 0.35),
              ),
              const Gap(4),
              Text(
                '$guestCount guest${guestCount == 1 ? '' : 's'}',
                style: context.textTheme.bodyLarge
                    .copyWith(fontSize: 17, fontWeight: FontWeight.w400),
              ),
            ],
          ],
        ),
        if (location.isNotEmpty) ...[
          const Gap(9),
          _locationRow(context, location),
        ],
      ],
    );
  }

  Widget _locationRow(BuildContext context, String location) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        KumeleAssetWidget(
          assetPath: Assets.svg.iconLocation.path,
          height: 20,
          width: 20,
          color: ColorSet.textColor,
        ),
        const Gap(6),
        Expanded(
          child: Text(
            location,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style:
                context.textTheme.bodyLarge.copyWith(color: ColorSet.textColor),
          ),
        ),
        GestureDetector(
          onTap: () => _openInMaps(location),
          child: Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: ColorSet.hostTileColor,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.chevron_right, color: ColorSet.textColor),
          ),
        ),
      ],
    );
  }

  Future<void> _openInMaps(String location) async {
    final query = Uri.encodeComponent(location);
    final uri =
        Uri.parse('https://www.google.com/maps/search/?api=1&query=$query');
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {}
  }

  Widget _iconButton({required String assetPath, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 39,
        height: 39,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: ColorSet.revbg3Color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: KumeleAssetWidget.square(assetPath: assetPath, size: 18),
      ),
    );
  }
}

class _ProfilePreviewCard extends StatelessWidget {
  const _ProfilePreviewCard({
    required this.hostName,
    required this.bio,
    required this.avatarUrl,
    required this.followers,
    required this.medalTier,
    required this.medalCount,
    required this.featuredNftImage,
    required this.hostRating,
    required this.eventCompletionPercent,
  });

  final String hostName;
  final String bio;
  final String? avatarUrl;
  final int followers;
  final String medalTier;
  final String medalCount;
  final String? featuredNftImage;
  final double? hostRating;
  final int? eventCompletionPercent;

  static const double _avatarSize = 88;

  /// Smaller than the default so the banner stays short even though the
  /// avatar it tucks behind is large (its padding is avatar-proportional).
  static const double _bannerVerticalPadding = 0.07;

  @override
  Widget build(BuildContext context) {
    final firstSentence = _firstSentence(bio);
    final hasMoreBio = bio.isNotEmpty && bio.trim() != firstSentence.trim();
    final medalCountValue = int.tryParse(medalCount);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 56),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: ColorSet.hostTileColor,
              borderRadius: BorderRadius.circular(18),
            ),
            padding:
                const EdgeInsets.fromLTRB(22, _avatarSize - 56 + 12, 22, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.exploreSwipeCardHostLabel,
                      style: context.textTheme.bodyLargeBold.copyWith(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Gap(12),
                    if (medalTier.isNotEmpty || medalCountValue != null) ...[
                      HostMedalBadge(
                        count: medalCountValue,
                        imageOverride: featuredNftImage,
                      ),
                      const Gap(6),
                      Text(
                        medalTier,
                        style: context.textTheme.bodyLargeLight.copyWith(
                          fontSize: 17,
                          color: ColorSet.textColor,
                        ),
                      ),
                    ],
                  ],
                ),
                const Gap(10),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: AppLocalizations.of(context)!
                            .aboutHostPrefix(hostName),
                        style: context.textTheme.bodyLargeBold.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      TextSpan(
                        text: firstSentence,
                        style: context.textTheme.bodyLarge.copyWith(
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
                if (hasMoreBio) ...[
                  const Gap(14),
                  Text(
                    bio,
                    style: context.textTheme.bodyLarge.copyWith(
                      fontSize: 15,
                      height: 1.2,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 22),
          child: HostAvatarStatsRow(
            avatarUrl: avatarUrl,
            hostName: hostName,
            avatarSize: _avatarSize,
            followersCount: followers,
            hostRating: hostRating,
            eventCompletionPercent: eventCompletionPercent,
            bannerVerticalPaddingFactor: _bannerVerticalPadding,
          ),
        ),
      ],
    );
  }

  String _firstSentence(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return '';
    final periodIndex = trimmed.indexOf('.');
    if (periodIndex == -1) return trimmed;
    return trimmed.substring(0, periodIndex + 1);
  }
}
