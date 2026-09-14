import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/core/responsive/responsive.dart';
import 'package:kuemele/features/profile/presentation/card/cart_checkout_page.dart';
import 'package:kuemele/features/shop/presentation/nfts/nft_card_deck.dart';
import 'package:kuemele/features/shop/presentation/nfts/nft_tablet_detail_dialog.dart';
import 'package:kuemele/features/shop/presentation/nfts/wallet_signature_sheet.dart';
import 'package:kuemele/l10n/app_localizations.dart';
import 'package:kuemele/navigation/app_routes.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/icons.dart';
import 'package:kuemele/shared/models/web3_models.dart';
import 'package:kuemele/shared/modals/dialog/app_dialog.dart';
import 'package:kuemele/shared/services/api_service/api_exception.dart';
import 'package:kuemele/shared/services/api_service/web3/web3_repo.dart';
import 'package:kuemele/shared/widgets/app_svg_image.dart';
import 'package:kuemele/shared/widgets/kumele_asset_widget.dart';
import 'package:kuemele/shared/widgets/kumele_video_player.dart';
import 'package:lottie/lottie.dart';

const _innerTabs = ['Rewards', 'Claimed', 'Market Place'];

const _emptyMessages = {
  'Rewards': 'No reward NFTs yet.',
  'Claimed': "You haven't claimed any NFTs yet.",
  'Market Place': 'No NFTs in the marketplace right now.',
};

/// Shop → NFTs segment (see AI/14_NFTModulePixelPerfectUIGuide.md §3).
/// Inner Rewards/Claimed/Market Place tabs, each backed by the real
/// `/nfts/*` endpoints via [Web3Repo], rendered as a swipeable card deck.
class NftTabView extends StatefulWidget {
  const NftTabView({super.key});

  @override
  State<NftTabView> createState() => _NftTabViewState();
}

class _NftTabViewState extends State<NftTabView> {
  String _innerTab = 'Rewards';
  final Map<String, List<NftItem>> _data = {};
  final Map<String, bool> _loading = {};
  final Map<String, String?> _error = {};
  final Set<String> _pendingIds = {};
  bool _loadedTabletSections = false;

  @override
  void initState() {
    super.initState();
    _load('Rewards');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.sizeOf(context).shortestSide < 600 ||
        _loadedTabletSections) {
      return;
    }

    _loadedTabletSections = true;
    for (final tab in _innerTabs) {
      if (!_data.containsKey(tab) && _loading[tab] != true) {
        unawaited(_load(tab));
      }
    }
  }

  Future<void> _load(String tab) async {
    setState(() {
      _loading[tab] = true;
      _error[tab] = null;
    });
    try {
      final items = switch (tab) {
        'Rewards' => await Web3Repo.getRewardNfts(),
        'Claimed' => await Web3Repo.getMyNfts(),
        _ => await Web3Repo.getMarketplaceNfts(),
      };
      if (!mounted) return;
      setState(() {
        _data[tab] = items;
        _loading[tab] = false;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _error[tab] = e.error ?? ApiErrorMessage.APP_API_ERROR;
        _loading[tab] = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error[tab] = ApiErrorMessage.APP_UNKNOWN_ERROR;
        _loading[tab] = false;
      });
    }
  }

  void _selectTab(String tab) {
    if (tab == _innerTab) return;
    setState(() => _innerTab = tab);
    if (!_data.containsKey(tab) && _loading[tab] != true) {
      _load(tab);
    }
  }

  Future<void> _handleClaim(NftItem item) async {
    final l10n = AppLocalizations.of(context)!;
    setState(() => _pendingIds.add(item.id));
    try {
      final result = await Web3Repo.claimNft(item.id);
      if (result?.pendingTransactionBase64 != null) {
        _showWalletSheet(result!.message);
      } else {
        InjectionHelper.snackBar.showSuccess(l10n.nftClaimedMessage);
      }
      await _load('Rewards');
      await _load('Claimed');
    } on ApiException catch (e) {
      InjectionHelper.snackBar.showError(e.error ?? l10n.nftClaimFailedError);
    } catch (_) {
      InjectionHelper.snackBar.showError(l10n.nftClaimFailedError);
    } finally {
      if (mounted) setState(() => _pendingIds.remove(item.id));
    }
  }

  Future<void> _handleBuy(NftItem item) async {
    final l10n = AppLocalizations.of(context)!;
    if (!item.isFree) {
      // Tablet: popup card matching iPad's PaymentView_iPad, instead of a
      // full pushed page.
      final purchased = context.responsive.isTablet
          ? await AppDialog.show<bool>(
              context: context,
              width: AppDialogSize.cartWidthFor(context),
              dialog: CartCheckoutPage(nft: item, isPopup: true),
            )
          : await context.push<bool>(AppRoutes.cart, extra: item);
      if (purchased == true) {
        await _load('Market Place');
        await _load('Claimed');
      }
      return;
    }

    setState(() => _pendingIds.add(item.id));
    try {
      final result = await Web3Repo.purchaseNft(item.id);
      if (result?.pendingTransactionBase64 != null) {
        _showWalletSheet(result!.message);
      } else {
        InjectionHelper.snackBar.showSuccess(l10n.nftPurchasedMessage);
      }
      await _load('Market Place');
      await _load('Claimed');
    } on ApiException catch (e) {
      InjectionHelper.snackBar.showError(
        e.error ?? l10n.nftPurchaseFailedError,
      );
    } catch (_) {
      InjectionHelper.snackBar.showError(l10n.nftPurchaseFailedError);
    } finally {
      if (mounted) setState(() => _pendingIds.remove(item.id));
    }
  }

  void _showWalletSheet(String? message) {
    if (!mounted) return;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => WalletSignatureSheet(message: message),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.sizeOf(context).shortestSide >= 600) {
      return _buildTabletView(context);
    }

    final loading = _loading[_innerTab] ?? false;
    final error = _error[_innerTab];
    final items = _data[_innerTab];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildInnerTabBar(),
        const Gap(12),
        if (loading)
          Center(
            child: Lottie.asset(IconSet.jsonLoading, width: 98, height: 98),
          )
        else if (error != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Center(
              child: Text(
                error,
                style: context.textTheme.bodyMedium.copyWith(
                  fontSize: 14,
                  color: ColorSet.textColor,
                ),
              ),
            ),
          )
        else if (items == null || items.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Center(
              child: Text(
                _emptyMessages[_innerTab]!,
                style: context.textTheme.bodyMedium.copyWith(
                  fontSize: 14,
                  color: ColorSet.textColor,
                ),
              ),
            ),
          )
        else
          NftCardDeck(
            items: items,
            tabKey: _innerTab,
            height: math.min(MediaQuery.sizeOf(context).height * 0.62, 560.0),
            pendingIds: _pendingIds,
            onClaim: _handleClaim,
            onBuy: _handleBuy,
          ),
      ],
    );
  }

  Widget _buildTabletView(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final tab in _innerTabs) ...[
          _TabletNftSection(
            title: tab == 'Market Place' ? 'Marketplace' : tab,
            tabKey: tab,
            items: _data[tab] ?? const [],
            loading: _loading[tab] ?? false,
            error: _error[tab],
            emptyMessage: _emptyMessages[tab]!,
            onClaim: _handleClaim,
            onBuy: _handleBuy,
          ),
          if (tab != _innerTabs.last) const Gap(50),
        ],
      ],
    );
  }

  Widget _buildInnerTabBar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            for (final tab in _innerTabs)
              Expanded(
                child: GestureDetector(
                  onTap: () => _selectTab(tab),
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Text(
                          tab,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            fontSize: 16,
                            fontWeight: tab == _innerTab
                                ? FontWeight.w700
                                : FontWeight.w400,
                            color: tab == _innerTab
                                ? ColorSet.textColor
                                : ColorSet.profileSubTextColor,
                          ),
                        ),
                      ),
                      const Gap(8),
                      Center(
                        child: Container(
                          height: 3,
                          width: tab == _innerTab
                              ? _tabTextWidth(context, tab)
                              : 0,
                          decoration: BoxDecoration(
                            color: ColorSet.textColor,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  double _tabTextWidth(BuildContext context, String tab) {
    final painter = TextPainter(
      text: TextSpan(
        text: tab,
        style: const TextStyle(
          fontFamily: 'PlusJakartaSans',
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
      maxLines: 1,
      textDirection: Directionality.of(context),
    )..layout();
    return painter.width;
  }
}

class _TabletNftSection extends StatefulWidget {
  const _TabletNftSection({
    required this.title,
    required this.tabKey,
    required this.items,
    required this.loading,
    required this.error,
    required this.emptyMessage,
    required this.onClaim,
    required this.onBuy,
  });

  final String title;
  final String tabKey;
  final List<NftItem> items;
  final bool loading;
  final String? error;
  final String emptyMessage;
  final Future<void> Function(NftItem item) onClaim;
  final Future<void> Function(NftItem item) onBuy;

  @override
  State<_TabletNftSection> createState() => _TabletNftSectionState();
}

class _TabletNftSectionState extends State<_TabletNftSection> {
  final _controller = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _scroll(double direction) {
    if (!_controller.hasClients) return;
    final next = (_controller.offset + direction * 300).clamp(
      0.0,
      _controller.position.maxScrollExtent,
    );
    _controller.animateTo(
      next,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 345,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: ColorSet.bg2Color,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 20,
            top: 22,
            child: Text(
              widget.title,
              style: context.textTheme.bodyLargeBold.copyWith(
                color: ColorSet.textColor,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Positioned.fill(
            top: 78,
            left: 74,
            right: 74,
            bottom: 42,
            child: _body(context),
          ),
          if (widget.items.length > 1) ...[
            Positioned(
              left: 10,
              top: 154,
              child: _SectionArrow(
                icon: Icons.chevron_left,
                onTap: () => _scroll(-1),
              ),
            ),
            Positioned(
              right: 10,
              top: 154,
              child: _SectionArrow(
                icon: Icons.chevron_right,
                onTap: () => _scroll(1),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _body(BuildContext context) {
    if (widget.loading) {
      return Center(
        child: Lottie.asset(IconSet.jsonLoading, width: 72, height: 72),
      );
    }

    final error = widget.error;
    if (error != null) {
      return Center(
        child: Text(
          error,
          style: context.textTheme.bodyMedium.copyWith(
            color: ColorSet.textColor,
          ),
        ),
      );
    }

    if (widget.items.isEmpty) {
      return Center(
        child: Text(
          widget.emptyMessage,
          style: context.textTheme.bodyMedium.copyWith(
            color: ColorSet.textColor,
          ),
        ),
      );
    }

    return SingleChildScrollView(
      controller: _controller,
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (var i = 0; i < widget.items.length; i++) ...[
            if (i > 0) const Gap(58),
            _TabletNftCard(
              item: widget.items[i],
              onTap: () => _openDetail(context, widget.items[i]),
            ),
          ],
        ],
      ),
    );
  }

  void _openDetail(BuildContext context, NftItem item) {
    final responsive = context.responsive;
    final width = (responsive.screenSize.width * 0.62).clamp(480.0, 760.0);
    AppDialog.show(
      context: context,
      width: width,
      dialog: NftTabletDetailDialog(
        items: widget.items,
        initialItem: item,
        tabKey: widget.tabKey,
        onClaim: widget.onClaim,
        onBuy: widget.onBuy,
      ),
    );
  }
}

class _TabletNftCard extends StatelessWidget {
  const _TabletNftCard({required this.item, required this.onTap});

  final NftItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 240,
        height: 226,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: ColorSet.isDarkMode
              ? ColorSet.tileFillColor
              : ColorSet.bg2Color,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(
                alpha: ColorSet.isDarkMode ? 0.2 : 0.08,
              ),
              blurRadius: 36,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 134,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Full-bleed — a Padding here used to leave a visible
                  // margin of the card's own background on three sides
                  // around the artwork instead of filling the tile.
                  _media(),
                  if ((item.nftType ?? item.category ?? '').isNotEmpty)
                    Positioned(
                      top: 20,
                      right: 22,
                      child: _typeBadge(item.nftType ?? item.category!),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 8, 14, 0),
              child: Text(
                item.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.bodyLargeBold.copyWith(
                  color: ColorSet.textColor,
                  fontSize: 15,
                  height: 1.1,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const Gap(8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                children: [
                  AppSvgImage(
                    assetName: IconSet.ticketsIcon,
                    width: 12,
                    height: 12,
                    color: ColorSet.profileSubTextColor,
                  ),
                  const Gap(2),
                  Expanded(
                    child: Text(
                      nftPriceStatusText(item),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.bodySmall.copyWith(
                        color: ColorSet.profileSubTextColor,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _media() {
    final stillAsset = item.thumbnailUrl ?? item.imageUrl;
    if (item.animationUrl?.isNotEmpty == true && item.animationIsVideo) {
      // The NFT artwork has black pillarbox bars baked into the media
      // itself (see nftArtworkCrop's doc comment in nft_card_deck.dart) —
      // BoxFit.contain here was only letterboxing an already-letterboxed
      // asset. Same zoom-and-clip treatment the phone card deck uses.
      return nftArtworkCrop(
        child: KumeleVideoPlayer(
          key: ValueKey(item.animationUrl),
          videoPath: item.animationUrl!,
          isNetwork: true,
          fit: BoxFit.fill,
          muted: true,
          loop: true,
          errorFallback: stillAsset?.isNotEmpty == true
              ? KumeleAssetWidget(
                  key: ValueKey(stillAsset),
                  assetPath: stillAsset!,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.fill,
                )
              : null,
        ),
      );
    }

    final asset = item.animationUrl?.isNotEmpty == true
        ? item
              .animationUrl // gif/webp — the video player can't decode these.
        : stillAsset;

    if (asset == null || asset.isEmpty) {
      return Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          color: ColorSet.textColor.withValues(alpha: 0.3),
          size: 42,
        ),
      );
    }

    return nftArtworkCrop(
      child: KumeleAssetWidget(
        key: ValueKey(asset),
        assetPath: asset,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.fill,
      ),
    );
  }

  Widget _typeBadge(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: ColorSet.revbg3Color.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'PlusJakartaSans',
          fontWeight: FontWeight.w600,
          fontSize: 11,
          color: ColorSet.bg2Color,
        ),
      ),
    );
  }
}

class _SectionArrow extends StatelessWidget {
  const _SectionArrow({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 46,
        height: 46,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: ColorSet.bg2Color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(icon, color: ColorSet.textColor, size: 32),
      ),
    );
  }
}
