import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/core/responsive/responsive.dart';
import 'package:kuemele/features/shop/presentation/nfts/nft_card_deck.dart'
    show nftPriceStatusText, nftArtworkCrop;
import 'package:kuemele/features/shop/presentation/nfts/nft_details_rows.dart';
import 'package:kuemele/features/shop/presentation/nfts/nft_preview_content.dart';
import 'package:kuemele/l10n/app_localizations.dart';
import 'package:kuemele/shared/components/app_button.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/icons.dart';
import 'package:kuemele/shared/models/web3_models.dart';
import 'package:kuemele/shared/widgets/app_svg_image.dart';
import 'package:kuemele/shared/widgets/kumele_asset_widget.dart';
import 'package:kuemele/shared/widgets/kumele_video_player.dart';
import 'package:share_plus/share_plus.dart';

/// Tablet-only NFT claim/detail dialog. `_TabletNftCard` (nft_tab_view.dart)
/// has no phone equivalent of this popup — on phone the same content lives in
/// `NftCardDeck`'s expanded card, which stays untouched. Elements here (media
/// area, title/price/description/details, the Claimed-tab preview toggle) are
/// copied from `_NftCardContent`/`NftPreviewContent` and resized for tablet;
/// the Decline/Claim footer and "Other NFTs" carousel are new.
class NftTabletDetailDialog extends StatefulWidget {
  const NftTabletDetailDialog({
    super.key,
    required this.items,
    required this.initialItem,
    required this.tabKey,
    required this.onClaim,
    required this.onBuy,
  });

  final List<NftItem> items;
  final NftItem initialItem;
  final String tabKey; // 'Rewards' | 'Claimed' | 'Market Place'
  final Future<void> Function(NftItem item) onClaim;
  final Future<void> Function(NftItem item) onBuy;

  @override
  State<NftTabletDetailDialog> createState() => _NftTabletDetailDialogState();
}

class _NftTabletDetailDialogState extends State<NftTabletDetailDialog> {
  late NftItem _current = widget.initialItem;
  bool _previewMode = false;
  bool _actionPending = false;
  final ScrollController _otherNftsController = ScrollController();

  @override
  void dispose() {
    _otherNftsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final height = math.min(responsive.screenSize.height * 0.88, 900.0);

    return Container(
      height: height,
      // Shadow lives on this outer, unclipped box — putting it on the same
      // Container as clipBehavior would clip it away, since it extends
      // past the rounded-rect bounds.
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Container(
          decoration: BoxDecoration(
            color: ColorSet.bg2Color,
            border: ColorSet.isDarkMode
                ? null
                : Border.all(color: ColorSet.border, width: 1),
          ),
          child: _previewMode
              // Unlike the phone card (which grows to fit this content),
              // this dialog has a fixed overall height — so, unlike
              // NftPreviewContent's own no-scroll design (meant for the
              // phone card, which grows instead), this call site needs its
              // own scroll wrapper to handle content taller than the
              // dialog.
              ? SingleChildScrollView(
                  child: NftPreviewContent(
                    item: _current,
                    onClose: () => setState(() => _previewMode = false),
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.zero,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _mediaArea(context),
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(40, 40, 40, 36),
                              child: _body(context),
                            ),
                          ],
                        ),
                      ),
                    ),
                    _footer(context),
                  ],
                ),
        ),
      ),
    );
  }

  /// iPad reference music/album covers only — every other NFT (the actual
  /// bulk of the catalog: badges, medals, ...) skips the type/category
  /// chip on the banner entirely on tablet. Phone always shows it; this is
  /// a deliberate per-platform difference in the source, not an oversight.
  bool get _usesFullBleedImage {
    final item = _current;
    final type = item.nftType?.toLowerCase() ?? '';
    return type.contains('music') || item.title.toLowerCase().contains('album');
  }

  Widget _mediaArea(BuildContext context) {
    final item = _current;
    return Padding(
      padding: const EdgeInsets.fromLTRB(40, 40, 40, 0),
      child: LayoutBuilder(builder: (context, constraints) {
        final bannerWidth =
            constraints.maxWidth.isFinite ? constraints.maxWidth : 600.0;
        final bannerHeight = bannerWidth * 9 / 16;
        return ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: SizedBox(
            width: bannerWidth,
            height: bannerHeight,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(color: ColorSet.tileFillColor),
                if (item.animationUrl?.isNotEmpty == true &&
                    item.animationIsVideo)
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
                              height: bannerHeight,
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
                      height: bannerHeight,
                      fit: BoxFit.fill,
                    ),
                  )
                else if ((item.imageUrl ?? item.thumbnailUrl)
                        ?.isNotEmpty ==
                    true)
                  nftArtworkCrop(
                    child: KumeleAssetWidget(
                      assetPath: item.imageUrl ?? item.thumbnailUrl!,
                      width: double.infinity,
                      height: bannerHeight,
                      fit: BoxFit.fill,
                    ),
                  )
                else
                  Center(
                    child: Icon(
                      Icons.image_not_supported_outlined,
                      color: ColorSet.textColor.withValues(alpha: 0.3),
                      size: 64,
                    ),
                  ),
                if (_usesFullBleedImage &&
                    (item.nftType ?? '').isNotEmpty)
                  Positioned(
                    top: 16,
                    right: 16,
                    child: _pillBadge(item.nftType!),
                  ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _body(BuildContext context) {
    final item = _current;
    final others = widget.items.where((i) => i.id != item.id).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                item.title,
                style: context.textTheme.bodyLargeBold.copyWith(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            _iconCircleButton(
              assetPath: IconSet.shareIcon,
              onTap: () => SharePlus.instance.share(
                ShareParams(text: '${item.title}\n${item.description}'),
              ),
            ),
          ],
        ),
        const Gap(16),
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
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        // Description and NFT Details always show, with a placeholder
        // fallback — not conditional on the fields being populated.
        const Gap(20),
        Text(
          AppLocalizations.of(context)!.nftDescriptionLabel,
          style: context.textTheme.headlineSmallBold.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Gap(8),
        Text(
          item.description.isNotEmpty
              ? item.description
              : 'A Unique Digital Collectible that represents ownership and '
                  'authenticity on the blockchain. Each NFT is one-of-a-kind '
                  'and comes with a verifiable proof of ownership.',
          style: context.textTheme.bodyLarge.copyWith(
            fontSize: 15,
            height: 1.3,
            color: ColorSet.textColor.withValues(alpha: 0.7),
          ),
        ),
        const Gap(20),
        Text(
          AppLocalizations.of(context)!.nftDetailsLabel,
          style: context.textTheme.headlineSmallBold.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Gap(8),
        NftDetailsRows(item: item, rowBuilder: _detailRow, qrSize: 180),
        if (widget.tabKey == 'Claimed') ...[
          const Gap(20),
          _previewToggleRow(context),
        ],
        if (others.isNotEmpty) ...[
          const Gap(28),
          _otherNftsSection(context, others),
        ],
        const Gap(24),
      ],
    );
  }

  Widget _previewToggleRow(BuildContext context) {
    return Row(
      children: [
        Text(
          AppLocalizations.of(context)!.nftPreviewTitle,
          style: context.textTheme.bodyLargeBold.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 17,
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: () => setState(() => _previewMode = true),
          child: Container(
            width: 44,
            height: 26,
            padding: const EdgeInsets.all(4),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: ColorSet.textColor.withValues(alpha: 0.35),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: ColorSet.textColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _otherNftsSection(BuildContext context, List<NftItem> others) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Other NFTs',
          style: context.textTheme.headlineSmallBold.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Gap(14),
        SizedBox(
          height: 168,
          child: Stack(
            alignment: Alignment.center,
            children: [
              ListView.separated(
                controller: _otherNftsController,
                scrollDirection: Axis.horizontal,
                itemCount: others.length,
                separatorBuilder: (_, __) => const Gap(16),
                itemBuilder: (context, i) => _OtherNftTile(
                  item: others[i],
                  onTap: () => setState(() {
                    _current = others[i];
                    _previewMode = false;
                  }),
                ),
              ),
              if (others.length > 2) ...[
                Positioned(
                  left: 0,
                  child: _scrollArrow(Icons.chevron_left, -1),
                ),
                Positioned(
                  right: 0,
                  child: _scrollArrow(Icons.chevron_right, 1),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _scrollArrow(IconData icon, double direction) {
    return GestureDetector(
      onTap: () {
        if (!_otherNftsController.hasClients) return;
        final next = (_otherNftsController.offset + direction * 260).clamp(
          0.0,
          _otherNftsController.position.maxScrollExtent,
        );
        _otherNftsController.animateTo(
          next,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      },
      child: Container(
        width: 36,
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: ColorSet.bg2Color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, color: ColorSet.textColor, size: 24),
      ),
    );
  }

  Widget _footer(BuildContext context) {
    final item = _current;
    final label = _actionLabel(item);

    return Container(
      padding: const EdgeInsets.fromLTRB(28, 16, 28, 20),
      decoration: BoxDecoration(
        color: ColorSet.tileFillColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.09),
            blurRadius: 22,
            offset: const Offset(0, -2.5),
          ),
        ],
      ),
      child: label == null
          ? AppButton.primary(
              label: AppLocalizations.of(context)!.close,
              onPressed: () => Navigator.of(context).pop(),
            )
          : Row(
              children: [
                Expanded(
                  child: AppButton.outline(
                    label: AppLocalizations.of(
                      context,
                    )!.exploreDiscountDeclineMessage,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                const Gap(16),
                Expanded(
                  child: AppButton.primary(
                    label: label,
                    isLoading: _actionPending,
                    onPressed: _actionPending
                        ? null
                        : () => _handleAction(item),
                  ),
                ),
              ],
            ),
    );
  }

  String? _actionLabel(NftItem item) {
    return switch (widget.tabKey) {
      'Rewards' =>
        item.isOwned ? null : (_actionPending ? 'Claiming…' : 'Claim'),
      'Market Place' =>
        (item.isOwned || item.isComingSoon)
            ? null
            : (_actionPending ? 'Buying…' : 'Buy'),
      _ => null,
    };
  }

  Future<void> _handleAction(NftItem item) async {
    setState(() => _actionPending = true);
    final action = widget.tabKey == 'Rewards' ? widget.onClaim : widget.onBuy;
    await action(item);
    if (mounted) setState(() => _actionPending = false);
  }

  Widget _detailRow(String label, String? value) {
    final displayValue = (value == null || value.isEmpty) ? '—' : value;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 15,
              color: ColorSet.textColor.withValues(alpha: 0.5),
            ),
          ),
          const Spacer(),
          Text(
            displayValue,
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: ColorSet.textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _pillBadge(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: ColorSet.revbg3Color.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'PlusJakartaSans',
          fontWeight: FontWeight.w600,
          fontSize: 13,
          color: ColorSet.bg2Color,
        ),
      ),
    );
  }

  Widget _iconCircleButton({
    required String assetPath,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: ColorSet.revbg3Color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: KumeleAssetWidget.square(assetPath: assetPath, size: 20),
      ),
    );
  }
}

class _OtherNftTile extends StatelessWidget {
  const _OtherNftTile({required this.item, required this.onTap});

  final NftItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final hasVideo =
        item.animationUrl?.isNotEmpty == true && item.animationIsVideo;
    final hasGifAnimation =
        item.animationUrl?.isNotEmpty == true && !item.animationIsVideo;
    final staticAsset = item.thumbnailUrl ?? item.imageUrl;
    final badge = item.nftType ?? item.category;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 132,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: ColorSet.tileFillColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 96,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (hasVideo)
                    nftArtworkCrop(
                      child: KumeleVideoPlayer(
                        key: ValueKey(item.animationUrl),
                        videoPath: item.animationUrl!,
                        isNetwork: true,
                        fit: BoxFit.fill,
                        muted: true,
                        loop: true,
                        errorFallback: staticAsset?.isNotEmpty == true
                            ? KumeleAssetWidget(
                                assetPath: staticAsset!,
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.fill,
                              )
                            : null,
                      ),
                    )
                  else if (hasGifAnimation)
                    // gif/webp — the video player can't decode these.
                    nftArtworkCrop(
                      child: KumeleAssetWidget(
                        key: ValueKey(item.animationUrl),
                        assetPath: item.animationUrl!,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.fill,
                      ),
                    )
                  else if (staticAsset != null && staticAsset.isNotEmpty)
                    nftArtworkCrop(
                      child: KumeleAssetWidget(
                        assetPath: staticAsset,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.fill,
                      ),
                    )
                  else
                    Center(
                      child: Icon(
                        Icons.image_not_supported_outlined,
                        color: ColorSet.textColor.withValues(alpha: 0.3),
                        size: 28,
                      ),
                    ),
                  if (badge != null && badge.isNotEmpty)
                    Positioned(
                      top: 6,
                      left: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: ColorSet.revbg3Color,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          badge,
                          style: TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            fontWeight: FontWeight.w600,
                            fontSize: 9,
                            color: ColorSet.bg2Color,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 2),
              child: Text(
                item.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.bodyLargeBold.copyWith(
                  color: ColorSet.textColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: Text(
                nftPriceStatusText(item),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.bodySmall.copyWith(
                  color: ColorSet.profileSubTextColor,
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
