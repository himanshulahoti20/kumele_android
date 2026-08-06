import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/features/shop/presentation/nfts/nft_card_deck.dart'
    show nftPriceStatusText;
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/icons.dart';
import 'package:kuemele/shared/models/web3_models.dart';
import 'package:kuemele/shared/widgets/app_avatar.dart';
import 'package:kuemele/shared/widgets/app_svg_image.dart';
import 'package:kuemele/shared/widgets/kumele_asset_widget.dart';
import 'package:share_plus/share_plus.dart';

/// "How this NFT looks on your profile" mock preview — see
/// AI/14_NFTModulePixelPerfectUIGuide.md §3.8. Reachable only from the
/// Claimed tab in expanded mode via the NFT Preview toggle; replaces the
/// card's normal content entirely, inside the same card chrome.
class NftPreviewContent extends StatelessWidget {
  const NftPreviewContent({
    super.key,
    required this.item,
    required this.onClose,
  });

  final NftItem item;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final userData = InjectionHelper.profileCubit.userData;
    final profileState = InjectionHelper.profilePageBloc.state;
    final hostName = (userData?.fullname?.trim().isNotEmpty ?? false)
        ? userData!.fullname!.trim()
        : (userData?.username?.trim().isNotEmpty ?? false)
            ? userData!.username!.trim()
            : 'You';
    final bio = userData?.aboutMe?.trim() ?? '';

    return SingleChildScrollView(
      padding: EdgeInsets.zero,
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
                      'NFT Preview',
                      style: context.textTheme.bodyLargeBold.copyWith(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  _iconButton(
                    icon: Icons.ios_share_outlined,
                    onTap: () => SharePlus.instance.share(
                      ShareParams(text: '${item.title}\n${item.description}'),
                    ),
                  ),
                ],
              ),
              const Gap(20),
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
                    nftPriceStatusText(item),
                    style: context.textTheme.bodyLarge.copyWith(
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
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
            item: item,
            followers: profileState.followersCount,
            goldStatus: profileState.goldStatus,
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
                  'Close Preview',
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
          if ((item.imageUrl ?? item.thumbnailUrl)?.isNotEmpty == true)
            KumeleAssetWidget(
              assetPath: item.imageUrl ?? item.thumbnailUrl!,
              width: double.infinity,
              height: 260,
              fit: BoxFit.cover,
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

  Widget _iconButton({required IconData icon, required VoidCallback onTap}) {
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
        child: Icon(icon, size: 18, color: ColorSet.bg2Color),
      ),
    );
  }
}

class _ProfilePreviewCard extends StatelessWidget {
  const _ProfilePreviewCard({
    required this.hostName,
    required this.bio,
    required this.avatarUrl,
    required this.item,
    required this.followers,
    required this.goldStatus,
  });

  final String hostName;
  final String bio;
  final String? avatarUrl;
  final NftItem item;
  final int followers;
  final String goldStatus;

  static const double _avatarSize = 96;

  @override
  Widget build(BuildContext context) {
    final firstSentence = _firstSentence(bio.isNotEmpty ? bio : hostName);
    final hasMoreBio = bio.isNotEmpty && bio.trim() != firstSentence.trim();
    final badgeText = item.nftType ?? item.category ?? item.title;

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
                      'Host',
                      style: context.textTheme.bodyLargeBold.copyWith(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Gap(10),
                    if ((item.imageUrl ?? item.thumbnailUrl)?.isNotEmpty ==
                        true)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: KumeleAssetWidget.square(
                          assetPath: item.imageUrl ?? item.thumbnailUrl!,
                          size: 36,
                          fit: BoxFit.cover,
                        ),
                      ),
                    const Gap(6),
                    if (badgeText.isNotEmpty)
                      Expanded(
                        child: Text(
                          badgeText,
                          style: context.textTheme.bodyLarge.copyWith(
                            fontSize: 17,
                            fontWeight: FontWeight.w400,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                ),
                const Gap(10),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'About $hostName: ',
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
          padding: const EdgeInsets.only(left: 16),
          child: SizedBox(
            height: _avatarSize,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                AppAvatar(
                    imageUrl: avatarUrl, name: hostName, size: _avatarSize),
                Positioned(
                  left: _avatarSize - 10,
                  top: 18,
                  child: _StatChip(
                    followers: followers,
                    goldStatus: goldStatus,
                  ),
                ),
              ],
            ),
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

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.followers,
    required this.goldStatus,
  });

  final int followers;
  final String goldStatus;

  @override
  Widget build(BuildContext context) {
    // This chip is deliberately not theme-aware — matches the source spec's
    // fixed yellow-chip-with-black-text treatment in both light and dark mode.
    return Container(
      constraints: const BoxConstraints(minWidth: 174),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFFC72E),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$followers followers',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          Text(
            '$goldStatus Gold',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
