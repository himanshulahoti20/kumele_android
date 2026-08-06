import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/features/shop/presentation/nfts/nft_preview_content.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/icons.dart';
import 'package:kuemele/shared/models/web3_models.dart';
import 'package:kuemele/shared/widgets/app_svg_image.dart';
import 'package:share_plus/share_plus.dart';

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

    if (_expanded) {
      return LayoutBuilder(builder: (context, constraints) {
        final width = math.min(constraints.maxWidth, _cardWidthCap);
        return Center(
          child: _cardChrome(
            width: width,
            height: math.min(MediaQuery.sizeOf(context).height * 0.72, 680),
            child: _previewMode
                ? NftPreviewContent(
                    item: current,
                    onClose: () => setState(() => _previewMode = false),
                  )
                : _NftCardContent(
                    item: current,
                    expanded: true,
                    tabKey: widget.tabKey,
                    isPending: widget.pendingIds.contains(current.id),
                    onClaim: () => widget.onClaim(current),
                    onBuy: () => widget.onBuy(current),
                    onToggleExpand: () => setState(() => _expanded = false),
                    onTogglePreview: widget.tabKey == 'Claimed'
                        ? () => setState(() => _previewMode = true)
                        : null,
                  ),
          ),
        );
      });
    }

    final showDots = widget.items.length > 1;
    return LayoutBuilder(builder: (context, constraints) {
      final width =
          math.min(constraints.maxWidth - (showDots ? 44 : 0), _cardWidthCap);
      final dotColumnHalfHeight = _dotColumnHalfHeight(widget.items.length);
      return SizedBox(
        height: widget.height,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showDots)
              Padding(
                padding: EdgeInsets.only(
                    top: (widget.height / 2 - dotColumnHalfHeight)
                        .clamp(0, widget.height)),
                child: _DotColumn(
                  count: widget.items.length,
                  activeIndex: _frontIndex,
                  maxDots: _maxDots,
                  onTap: (i) => _advance(toIndex: i),
                ),
              ),
            if (showDots) const Gap(12),
            Expanded(
              child: Center(
                child: SizedBox(
                  width: width,
                  height: widget.height,
                  child: _buildStack(width, widget.height),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  double _dotColumnHalfHeight(int count) {
    final visible = math.min(count, _maxDots);
    return (visible * 12 + (visible - 1) * 8) / 2;
  }

  Widget _buildStack(double width, double height) {
    final dragProgress =
        (_dragOffset.distance / _dismissThreshold).clamp(0.0, 1.0);
    final total = widget.items.length;
    final slot2Index = total > 2 ? (_frontIndex + 2) % total : null;
    final slot1Index = total > 1 ? (_frontIndex + 1) % total : null;

    return Stack(
      alignment: Alignment.topCenter,
      clipBehavior: Clip.none,
      children: [
        if (slot2Index != null)
          _peekCard(
            item: widget.items[slot2Index],
            width: width,
            height: height,
            scale: 0.86,
            translateY: height * 0.124,
            color: ColorSet.swipeCardNext,
            opacity: math.max(0.7, 1 - dragProgress),
          ),
        if (slot1Index != null)
          _peekCard(
            item: widget.items[slot1Index],
            width: width,
            height: height,
            scale: 0.93,
            translateY: height * 0.062,
            color: ColorSet.swipeCard,
            opacity: 1 - dragProgress,
          ),
        _topCard(item: widget.items[_frontIndex], width: width, height: height),
      ],
    );
  }

  Widget _peekCard({
    required NftItem item,
    required double width,
    required double height,
    required double scale,
    required double translateY,
    required Color color,
    required double opacity,
  }) {
    return IgnorePointer(
      child: Transform.translate(
        offset: Offset(0, translateY),
        child: Transform.scale(
          scale: scale,
          alignment: Alignment.topCenter,
          child: _cardChrome(
            width: width,
            height: height,
            child: Stack(
              fit: StackFit.expand,
              children: [
                _NftCardContent(
                    item: item,
                    expanded: false,
                    tabKey: widget.tabKey,
                    isPending: false),
                Container(color: color.withValues(alpha: opacity)),
              ],
            ),
          ),
        ),
      ),
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

Widget _cardChrome(
    {required Widget child,
    required double width,
    double? height,
    bool showShadow = false}) {
  return Container(
    width: width,
    height: height,
    clipBehavior: Clip.antiAlias,
    decoration: BoxDecoration(
      color: ColorSet.bg2Color,
      borderRadius: BorderRadius.circular(26),
      border: ColorSet.isDarkMode
          ? null
          : Border.all(color: ColorSet.border, width: 1),
      boxShadow: showShadow
          ? [
              BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 20,
                  offset: const Offset(0, -4))
            ]
          : null,
    ),
    child: child,
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
          if (i != indices.first) const Gap(8),
          GestureDetector(
            onTap: () => onTap(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              width: i == activeIndex ? 12 : 7,
              height: i == activeIndex ? 12 : 7,
              decoration: BoxDecoration(
                  color: ColorSet.textColor, shape: BoxShape.circle),
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
  final VoidCallback? onClaim;
  final VoidCallback? onBuy;
  final VoidCallback? onToggleExpand;
  final VoidCallback? onTogglePreview;

  const _NftCardContent({
    required this.item,
    required this.expanded,
    required this.tabKey,
    required this.isPending,
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
          Padding(padding: const EdgeInsets.all(16), child: _body(context))
        else
          Expanded(
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
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
          Container(color: ColorSet.tileFillColor),
          if (item.imageUrl != null && item.imageUrl!.isNotEmpty)
            Image.network(
              item.imageUrl!,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => Icon(
                  Icons.image_not_supported_outlined,
                  color: ColorSet.textColor.withValues(alpha: 0.3),
                  size: 48),
            )
          else
            Center(
                child: Icon(Icons.image_not_supported_outlined,
                    color: ColorSet.textColor.withValues(alpha: 0.3),
                    size: 48)),
          if ((item.nftType ?? item.category ?? '').isNotEmpty)
            Positioned(
                top: 12,
                right: 12,
                child: _typeBadge(item.nftType ?? item.category!)),
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
                style: context.textTheme.bodyLargeBold.copyWith(
                    fontSize: expanded ? 30 : 25, fontWeight: FontWeight.w700),
              ),
            ),
            _iconCircleButton(
              icon: Icons.ios_share_outlined,
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
                icon: expanded ? Icons.expand_less : Icons.expand_more,
                onTap: onToggleExpand,
              ),
          ],
        ),
        if (expanded) ...[
          const Gap(18),
          Divider(color: ColorSet.border),
          const Gap(18),
          if (item.description.isNotEmpty) ...[
            Text('Description',
                style: context.textTheme.headlineSmallBold
                    .copyWith(fontSize: 28, fontWeight: FontWeight.w700)),
            const Gap(8),
            Text(item.description,
                style: context.textTheme.bodyLarge.copyWith(
                    fontSize: 15,
                    color: ColorSet.textColor.withValues(alpha: 0.7))),
            const Gap(18),
          ],
          if (_hasDetails) ...[
            Text('NFT Details',
                style: context.textTheme.headlineSmallBold
                    .copyWith(fontSize: 28, fontWeight: FontWeight.w700)),
            const Gap(8),
            _detailRow('Token ID', item.tokenId),
            _detailRow('Token Standard', item.tokenStandard),
            _detailRow('Blockchain', item.blockchain),
            _detailRow('Creator', item.creator),
          ],
          if (tabKey == 'Claimed' && onTogglePreview != null) ...[
            const Gap(18),
            _previewToggleRow(context),
          ],
        ],
        const Gap(18),
        if (_actionButton(context) != null)
          Center(child: _actionButton(context)!),
      ],
    );
  }

  Widget _previewToggleRow(BuildContext context) {
    return Row(
      children: [
        Text(
          'NFT Preview',
          style: context.textTheme.bodyLargeBold
              .copyWith(fontWeight: FontWeight.w700, fontSize: 17),
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

  bool get _hasDetails => [
        item.tokenId,
        item.tokenStandard,
        item.blockchain,
        item.creator
      ].any((v) => v != null && v.isNotEmpty);

  Widget _detailRow(String label, String? value) {
    if (value == null || value.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Text('$label: ',
              style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 15,
                  color: ColorSet.textColor)),
          Text(value,
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

  Widget _iconCircleButton({required IconData icon, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: ColorSet.revbg3Color,
            borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, size: 18, color: ColorSet.bg2Color),
      ),
    );
  }
}
