import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/core/responsive/responsive.dart';
import 'package:kuemele/features/shop/presentation/nfts/nft_details_rows.dart';
import 'package:kuemele/features/shop/presentation/nfts/nft_preview_content.dart';
import 'package:kuemele/l10n/app_localizations.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/icons.dart';
import 'package:kuemele/shared/models/web3_models.dart';
import 'package:kuemele/shared/widgets/app_svg_image.dart';
import 'package:kuemele/shared/widgets/kumele_asset_widget.dart';
import 'package:kuemele/shared/widgets/kumele_video_player.dart';
import 'package:share_plus/share_plus.dart';

/// The NFT artwork the API serves has black pillarbox bars baked into the
/// image files themselves — roughly 22% of the width on each side, leaving
/// the real content at ~56% of the frame. No BoxFit can remove them:
/// `fill`/`cover` both stretch the bars along with the content, so they
/// stay proportionally identical (proven by the bars rendering black even
/// in light mode, where the backdrop behind the image is white).
///
/// So the media gets zoomed and clipped instead, pushing the bars outside
/// the frame. 1.78 (1/0.56) fully removes them but crops ~22% off the top
/// and bottom; 1.6 leaves a thin sliver of bar (~3% per side) in exchange
/// for less vertical cropping — the better tradeoff in practice.
///
/// Drop this back to 1.0 (or delete the wrapper) if the backend ever
/// starts serving the artwork without the baked-in bars.
const double kNftArtworkZoom = 1.75;

/// Wraps NFT artwork so the baked-in bars described on [kNftArtworkZoom]
/// fall outside the visible frame.
Widget nftArtworkCrop({required Widget child}) {
  return ClipRect(
    child: Transform.scale(scale: kNftArtworkZoom, child: child),
  );
}

/// "Owned" / "Coming Soon" / "Free" / formatted price / "" — in that priority order.
String nftPriceStatusText(NftItem item) {
  if (item.isOwned) return 'Owned';
  if (item.isComingSoon) return 'Coming Soon';
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
  return '';
}

/// Pixel-perfect port of the iOS ShopNFTsView_iPhone card deck (see
/// AI/14_NFTModulePixelPerfectUIGuide.md §3.3-3.6). Renders up to 3 stacked
/// cards with a vertical drag-to-dismiss gesture, tap-to-advance zones and a
/// capped/windowed dot indicator.
class NftCardDeck extends StatefulWidget {
  final List<NftItem> items;
  final String tabKey; // 'Rewards' | 'Claimed' | 'Market Place'
  final double height;
  final Set<String> pendingIds;
  final Future<void> Function(NftItem item) onClaim;
  final Future<void> Function(NftItem item) onBuy;

  const NftCardDeck({
    super.key,
    required this.items,
    required this.tabKey,
    required this.height,
    required this.pendingIds,
    required this.onClaim,
    required this.onBuy,
  });

  @override
  State<NftCardDeck> createState() => _NftCardDeckState();
}

class _NftCardDeckState extends State<NftCardDeck>
    with SingleTickerProviderStateMixin {
  static const double _cardWidthCap = 329;

  /// Reserved on BOTH sides of the card so its left/right margins match,
  /// even though the dot column only sits on the left. The dots are
  /// overlaid (not a Row cell) for the same reason iOS overlays them in a
  /// ZStack — a Row cell consumes width on one side only and shoves the
  /// card off-centre. Matches iOS's `cardHorizontalInset` of 34.
  static const double _dotsSideInset = 34;

  /// Dot column's distance from the deck's leading edge — iOS's
  /// `.padding(.leading, 10)`.
  static const double _dotsLeadingInset = 10;
  static const double _dismissThreshold = 120;
  static const double _flyDistance = 700;
  static const int _maxDots = 12;

  int _frontIndex = 0;
  bool _expanded = false;
  bool _previewMode = false;
  Offset _dragOffset = Offset.zero;
  late final AnimationController _animController;
  Animation<Offset>? _offsetAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
  }

  @override
  void didUpdateWidget(covariant NftCardDeck oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.items.isEmpty) {
      _frontIndex = 0;
    } else if (_frontIndex >= widget.items.length) {
      _frontIndex = 0;
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _springBack() {
    _offsetAnim = Tween<Offset>(begin: _dragOffset, end: Offset.zero).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    )..addListener(() => setState(() => _dragOffset = _offsetAnim!.value));
    _animController.duration = const Duration(milliseconds: 400);
    _animController.forward(from: 0);
  }

  Future<void> _advance(
      {Offset direction = const Offset(0, -1), int? toIndex}) async {
    if (widget.items.length <= 1) return;
    final normalized = direction.distance == 0
        ? const Offset(0, -1)
        : direction / direction.distance;
    _offsetAnim =
        Tween<Offset>(begin: _dragOffset, end: normalized * _flyDistance)
            .animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeIn),
    )..addListener(() => setState(() => _dragOffset = _offsetAnim!.value));
    _animController.duration = const Duration(milliseconds: 320);
    await _animController.forward(from: 0);
    await Future.delayed(const Duration(milliseconds: 100));
    if (!mounted) return;
    // Unanimated index swap — animating this too makes the promoted card
    // visibly inherit the dismissed card's flight motion (see guide §6.2).
    setState(() {
      _frontIndex = toIndex ?? (_frontIndex + 1) % widget.items.length;
      _dragOffset = Offset.zero;
      _expanded = false;
      _previewMode = false;
    });
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (_expanded || widget.items.length <= 1) return;
    setState(() => _dragOffset += details.delta);
  }

  void _onDragEnd(DragEndDetails details) {
    if (_expanded || widget.items.length <= 1) return;
    if (_dragOffset.dy.abs() > _dismissThreshold) {
      _advance(direction: _dragOffset);
    } else {
      _springBack();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) return const SizedBox.shrink();
    final current = widget.items[_frontIndex];
    final isPhone = context.responsive.isPhone;
    final showDots = widget.items.length > 1;

    // Phone: card sits 10px from the screen edge instead of the ambient
    // 20px screen padding, so it needs to reach 10px into that padding on
    // each side — parent constraints can't be widened with a negative
    // Padding/margin, so OverflowBox is used below (deferToChild — sized
    // off the child, never unbounded, regardless of the folded branch's
    // fixed height or the expanded branch's content-driven height).
    final extraWidth = isPhone ? 20.0 : 0.0;

    if (_expanded) {
      return LayoutBuilder(builder: (context, constraints) {
        // Same width formula as the folded deck below — the card must not
        // resize when expanding, only its height grows.
        final deckWidth = constraints.maxWidth + extraWidth;
        final sideInset = showDots ? _dotsSideInset : 0.0;
        final width = isPhone
            ? deckWidth - sideInset * 2
            : math.min(deckWidth - sideInset * 2, _cardWidthCap);
        final content = _previewMode
            ? NftPreviewContent(
                item: current,
                onClose: () => setState(() => _previewMode = false),
              )
            : _NftCardContent(
                item: current,
                expanded: true,
                tabKey: widget.tabKey,
                isPending: widget.pendingIds.contains(current.id),
                isFront: true,
                onClaim: () => widget.onClaim(current),
                onBuy: () => widget.onBuy(current),
                onToggleExpand: () => setState(() => _expanded = false),
                onTogglePreview: widget.tabKey == 'Claimed'
                    ? () => setState(() => _previewMode = true)
                    : null,
              );
        return OverflowBox(
          fit: OverflowBoxFit.deferToChild,
          maxWidth: deckWidth,
          // No fixed height — the card grows to fit its content instead of
          // scrolling internally; the page around this deck already
          // scrolls. The outer Stack sizes to the card (its only
          // non-positioned child), so the overlaid dots can't stretch it.
          child: SizedBox(
            width: deckWidth,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: [
                Center(
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.topCenter,
                    children: [
                      ..._peekLayers(width, widget.items.length),
                      _cardChrome(width: width, child: content),
                    ],
                  ),
                ),
                if (showDots)
                  Positioned(
                    left: _dotsLeadingInset,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: _DotColumn(
                        count: widget.items.length,
                        activeIndex: _frontIndex,
                        maxDots: _maxDots,
                        onTap: (i) => _advance(toIndex: i),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      });
    }

    return LayoutBuilder(builder: (context, constraints) {
      final deckWidth = constraints.maxWidth + extraWidth;
      final sideInset = showDots ? _dotsSideInset : 0.0;
      // Phone: full width cards, Tablet: capped width
      final width = isPhone
          ? deckWidth - sideInset * 2
          : math.min(deckWidth - sideInset * 2, _cardWidthCap);
      // Reserve room for the peek layers below the card so the deck's
      // total footprint stays widget.height — same as iOS's
      // `rearPeekHeight` bottom padding (14pt per rear card, max 2).
      final rearPeekHeight =
          math.min(math.max(widget.items.length - 1, 0), 2) * 14.0;
      final cardHeight = widget.height - rearPeekHeight;
      return OverflowBox(
        fit: OverflowBoxFit.deferToChild,
        maxWidth: deckWidth,
        child: SizedBox(
          height: widget.height,
          width: deckWidth,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                // Loose height here (not a tight SizedBox) so the Stack
                // sizes to the front card, letting the peek layers'
                // Positioned bottom:-offset resolve against the card's
                // height and protrude into the reserved space below.
                child: SizedBox(
                  width: width,
                  child: _buildStack(width, cardHeight),
                ),
              ),
              if (showDots)
                Positioned(
                  left: _dotsLeadingInset,
                  top: 0,
                  // Centre against the card only, not the peek space below.
                  bottom: rearPeekHeight,
                  child: Center(
                    child: _DotColumn(
                      count: widget.items.length,
                      activeIndex: _frontIndex,
                      maxDots: _maxDots,
                      onTap: (i) => _advance(toIndex: i),
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildStack(double width, double height) {
    // Flat peek layers, same as the expanded card. The previous approach
    // scaled a duplicate card down (0.93/0.86 from a topCenter anchor,
    // shrinking its height by 7%/14%) and then translated it down by only
    // 6.2%/12.4% — the two cancelled out, leaving both peeks a few px
    // ABOVE the front card's bottom edge, i.e. completely hidden behind
    // it. iOS never scales the height at all (`scaleEffect(x:)` is
    // X-only), so its peeks always protrude.
    return Stack(
      alignment: Alignment.topCenter,
      clipBehavior: Clip.none,
      children: [
        ..._peekLayers(width, widget.items.length),
        _topCard(item: widget.items[_frontIndex], width: width, height: height),
      ],
    );
  }

  Widget _topCard(
      {required NftItem item, required double width, required double height}) {
    final angle = _dragOffset.dx / 20 * math.pi / 180;
    return GestureDetector(
      onVerticalDragUpdate: _onDragUpdate,
      onVerticalDragEnd: _onDragEnd,
      child: Transform.translate(
        offset: _dragOffset,
        child: Transform.rotate(
          angle: angle,
          alignment: Alignment.center,
          child: _cardChrome(
            width: width,
            height: height,
            showShadow: true,
            child: Stack(
              fit: StackFit.expand,
              children: [
                _NftCardContent(
                  item: item,
                  expanded: false,
                  tabKey: widget.tabKey,
                  isPending: widget.pendingIds.contains(item.id),
                  isFront: true,
                  onClaim: () => widget.onClaim(item),
                  onBuy: () => widget.onBuy(item),
                  onToggleExpand: () => setState(() => _expanded = true),
                ),
                // Tap-to-advance zones MUST sit in front of the content, not
                // behind it — an opaque catcher behind real content is
                // unreachable to touches (guide §6.1).
                Positioned(
                  top: 0,
                  left: 0,
                  bottom: height - 260,
                  width: width / 3,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => _advance(),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  bottom: height - 260,
                  width: width / 3,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => _advance(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Matches the NFT card mock exactly — `ColorSet.bg2Color` is shared by too
/// many other widgets to repoint globally.
const Color _nftCardDarkBg = Color(0xFF2C2C2C);

/// Exact peek-layer colors from the real iOS source (`NFTPagedCarousel`'s
/// `mediumPeekColor`/`smallPeekColor` in ShopNFTsView_iPhone.swift) — not
/// the app-wide ColorSet.swipeCard/swipeCardNext, which iOS only happens
/// to match in light mode; its dark-mode values are dedicated to this
/// carousel and are lighter than the app-wide dark swipeCard/swipeCardNext.
Color get _mediumPeekColor =>
    ColorSet.isDarkMode ? const Color(0xFF808080) : const Color(0xFFD6D4D4);
Color get _smallPeekColor =>
    ColorSet.isDarkMode ? const Color(0xFF4D4A4A) : const Color(0xFFA9A9A9);

/// The two flat rounded-rect "peek" layers iOS renders as `.background()`
/// behind the card — in BOTH the folded deck and the expanded detail view
/// (a detail missed on the first port: only the folded card had a peek
/// effect here before). Narrower and offset further down per layer, so
/// each one's bottom edge peeks out below the card by a bit more than the
/// last. `Positioned` with all four sides set lets each layer's height
/// come from the Stack's own size (driven by the card, its only
/// non-positioned child) — no need to know the card's height up front,
/// which matters for the expanded card since its height is content-driven.
List<Widget> _peekLayers(double width, int itemCount) {
  Widget layer(double widthScale, double offset, Color color) {
    final inset = width * (1 - widthScale) / 2;
    return Positioned(
      left: inset,
      right: inset,
      top: offset,
      bottom: -offset,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(26),
        ),
      ),
    );
  }

  return [
    if (itemCount > 2) layer(0.79, 28, _smallPeekColor),
    if (itemCount > 1) layer(0.88, 14, _mediumPeekColor),
  ];
}

Widget _cardChrome(
    {required Widget child,
    required double width,
    double? height,
    bool showShadow = false}) {
  // The shadow lives on this outer, unclipped Container — putting it on
  // the same Container that clips (via clipBehavior) would clip the
  // shadow away too, since it extends past the rounded-rect bounds.
  return Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(26),
      boxShadow: showShadow
          ? [
              BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  blurRadius: 16,
                  offset: const Offset(0, 6)),
              BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 32,
                  offset: const Offset(0, 16)),
            ]
          : null,
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(26),
      child: Container(
        decoration: BoxDecoration(
          color: ColorSet.isDarkMode ? _nftCardDarkBg : ColorSet.bg2Color,
          border: ColorSet.isDarkMode
              ? null
              : Border.all(color: ColorSet.border, width: 1),
        ),
        child: child,
      ),
    ),
  );
}

class _DotColumn extends StatelessWidget {
  final int count;
  final int activeIndex;
  final int maxDots;
  final void Function(int index) onTap;

  const _DotColumn({
    required this.count,
    required this.activeIndex,
    required this.maxDots,
    required this.onTap,
  });

  // The visual dot is only 7-12px — practically impossible to hit
  // reliably on a phone. Each dot gets a bigger invisible tap target
  // while staying visually unchanged; kept tight (small size, near-zero
  // gap) so the column doesn't look sparse.
  static const double tapTargetSize = 20;
  static const double tapTargetGap = 2;

  @override
  Widget build(BuildContext context) {
    final visible = math.min(count, maxDots);
    final half = visible ~/ 2;
    final start =
        (activeIndex - half).clamp(0, math.max(0, count - visible)).toInt();
    final indices = List.generate(visible, (i) => start + i);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final i in indices) ...[
          if (i != indices.first) const Gap(tapTargetGap),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => onTap(i),
            child: SizedBox(
              width: tapTargetSize,
              height: tapTargetSize,
              child: Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOut,
                  width: i == activeIndex ? 12 : 7,
                  height: i == activeIndex ? 12 : 7,
                  decoration: BoxDecoration(
                      color: ColorSet.textColor, shape: BoxShape.circle),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _NftCardContent extends StatelessWidget {
  final NftItem item;
  final bool expanded;
  final String tabKey;
  final bool isPending;
  final bool isFront;
  final VoidCallback? onClaim;
  final VoidCallback? onBuy;
  final VoidCallback? onToggleExpand;
  final VoidCallback? onTogglePreview;

  const _NftCardContent({
    required this.item,
    required this.expanded,
    required this.tabKey,
    required this.isPending,
    this.isFront = false,
    this.onClaim,
    this.onBuy,
    this.onToggleExpand,
    this.onTogglePreview,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: expanded ? MainAxisSize.min : MainAxisSize.max,
      children: [
        _imageArea(),
        if (expanded)
          // The expanded card grows to fit this instead of scrolling
          // internally — the page around the deck already scrolls.
          Padding(
            padding: const EdgeInsets.all(16),
            child: _body(context),
          )
        else
          // Folded/peek cards sit in a fixed-height slot in the stack, so
          // content taller than that budget still needs to scroll here.
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: _body(context),
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
          Container(
              color: ColorSet.isDarkMode ? _nftCardDarkBg : ColorSet.bg2Color),
          if (isFront &&
              item.animationUrl != null &&
              item.animationUrl!.isNotEmpty &&
              item.animationIsVideo)
            nftArtworkCrop(
              child: KumeleVideoPlayer(
                key: ValueKey(item.animationUrl),
                videoPath: item.animationUrl!,
                isNetwork: true,
                fit: BoxFit.fill,
                muted: true,
                loop: true,
                errorFallback: item.imageUrl?.isNotEmpty == true
                    ? Image.network(
                        item.imageUrl!,
                        fit: BoxFit.fill,
                        width: double.infinity,
                        height: double.infinity,
                      )
                    : null,
              ),
            )
          else if (isFront &&
              item.animationUrl != null &&
              item.animationUrl!.isNotEmpty)
            // gif/webp — the video player can't decode these.
            nftArtworkCrop(
              child: Image.network(
                item.animationUrl!,
                key: ValueKey(item.animationUrl),
                fit: BoxFit.fill,
                width: double.infinity,
                height: double.infinity,
                errorBuilder: (_, __, ___) => Icon(
                    Icons.image_not_supported_outlined,
                    color: ColorSet.textColor.withValues(alpha: 0.3),
                    size: 48),
              ),
            )
          else if (item.imageUrl != null && item.imageUrl!.isNotEmpty)
            nftArtworkCrop(
              child: Image.network(
                item.imageUrl!,
                fit: BoxFit.fill,
                width: double.infinity,
                height: double.infinity,
                errorBuilder: (_, __, ___) => Icon(
                    Icons.image_not_supported_outlined,
                    color: ColorSet.textColor.withValues(alpha: 0.3),
                    size: 48),
              ),
            )
          else
            Center(
                child: Icon(Icons.image_not_supported_outlined,
                    color: ColorSet.textColor.withValues(alpha: 0.3),
                    size: 48)),
          Positioned(
              top: 12,
              right: 12,
              child: _typeBadge(item.nftType ?? item.category ?? 'NFT')),
        ],
      ),
    );
  }

  Widget _typeBadge(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
          color: ColorSet.revbg3Color,
          borderRadius: BorderRadius.circular(999)),
      child: Text(label,
          style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontWeight: FontWeight.w600,
              fontSize: 12,
              color: ColorSet.bg2Color)),
    );
  }

  Widget _body(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                item.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.bodyLargeBold.copyWith(
                    fontSize: expanded ? 30 : 25, fontWeight: FontWeight.w700),
              ),
            ),
            _iconCircleButton(
              assetPath: IconSet.shareIcon,
              onTap: () => SharePlus.instance.share(
                  ShareParams(text: '${item.title}\n${item.description}')),
            ),
          ],
        ),
        const Gap(18),
        Row(
          children: [
            AppSvgImage(
                assetName: IconSet.ticketsIcon,
                width: 20,
                height: 20,
                color: ColorSet.textColor),
            const Gap(8),
            Expanded(
              child: Text(
                nftPriceStatusText(item),
                style: context.textTheme.bodyLarge
                    .copyWith(fontSize: 16, fontWeight: FontWeight.w400),
              ),
            ),
            if (onToggleExpand != null)
              _iconCircleButton(
                // This button's circle sits on ColorSet.revbg3Color, which
                // is inverted relative to the theme (white in dark mode,
                // near-black in light mode) — so the glyph needs the
                // opposite of IconSet's normal theme-matched variant, or
                // it disappears (white-on-white / black-on-black).
                assetPath: ColorSet.isDarkMode
                    ? 'assets/icons/drop_down.png'
                    : 'assets/icons/drop_down_dark.png',
                flipVertically: expanded,
                onTap: onToggleExpand,
              ),
          ],
        ),
        if (expanded) ...[
          const Gap(18),
          Divider(color: ColorSet.border),
          const Gap(18),
          // Description and NFT Details always show, with a placeholder
          // fallback — not conditional on the fields being populated.
          Text(AppLocalizations.of(context)!.nftDescriptionLabel,
              style: context.textTheme.headlineSmallBold
                  .copyWith(fontSize: 28, fontWeight: FontWeight.w700)),
          const Gap(8),
          Text(
              item.description.isNotEmpty
                  ? item.description
                  : 'A Unique Digital Collectible that represents ownership and authenticity on the blockchain.',
              style: context.textTheme.bodyLarge.copyWith(
                  fontSize: 15,
                  color: ColorSet.textColor.withValues(alpha: 0.7))),
          const Gap(18),
          Text(AppLocalizations.of(context)!.nftDetailsLabel,
              style: context.textTheme.headlineSmallBold
                  .copyWith(fontSize: 28, fontWeight: FontWeight.w700)),
          const Gap(8),
          NftDetailsRows(item: item, rowBuilder: _detailRow, qrSize: 140),
          if (tabKey == 'Claimed' && onTogglePreview != null) ...[
            const Gap(18),
            _previewToggleRow(context),
          ],
        ] else ...[
          const Gap(18),
          if (_actionButton(context) != null)
            Center(child: _actionButton(context)!),
        ],
      ],
    );
  }

  Widget _previewToggleRow(BuildContext context) {
    return Row(
      children: [
        Text(
          AppLocalizations.of(context)!.nftPreviewTitle,
          style: context.textTheme.headlineSmallBold
              .copyWith(fontWeight: FontWeight.w700, fontSize: 28),
        ),
        const Spacer(),
        GestureDetector(
          onTap: onTogglePreview,
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
                  color: ColorSet.textColor, shape: BoxShape.circle),
            ),
          ),
        ),
      ],
    );
  }

  Widget _detailRow(String label, String? value) {
    final displayValue = (value == null || value.isEmpty) ? '—' : value;
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Text(label,
              style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 15,
                  color: ColorSet.textColor.withValues(alpha: 0.5))),
          const Spacer(),
          Text(displayValue,
              style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: ColorSet.textColor)),
        ],
      ),
    );
  }

  Widget? _actionButton(BuildContext context) {
    final label = switch (tabKey) {
      'Rewards' => item.isOwned ? null : (isPending ? 'Claiming…' : 'Claim'),
      'Market Place' => (item.isOwned || item.isComingSoon)
          ? null
          : (isPending ? 'Buying…' : 'Buy'),
      _ => null,
    };
    if (label == null) return null;
    final onTap = tabKey == 'Rewards' ? onClaim : onBuy;
    return GestureDetector(
      onTap: isPending ? null : onTap,
      child: Container(
        width: 124,
        height: 42,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: ColorSet.revbg3Color.withValues(alpha: isPending ? 0.6 : 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(label,
            style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: ColorSet.bg2Color)),
      ),
    );
  }

  Widget _iconCircleButton({
    required String assetPath,
    VoidCallback? onTap,
    bool flipVertically = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: ColorSet.revbg3Color,
            borderRadius: BorderRadius.circular(8)),
        child: Transform.flip(
          flipY: flipVertically,
          child: KumeleAssetWidget.square(
            assetPath: assetPath,
            size: 18,
          ),
        ),
      ),
    );
  }
}
