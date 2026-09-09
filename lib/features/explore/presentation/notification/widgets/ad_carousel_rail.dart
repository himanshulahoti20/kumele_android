import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/modals/dialog/ad_tap_through_dialog.dart';
import 'package:kuemele/shared/modals/dialog/app_dialog.dart';
import 'package:kuemele/shared/models/ads.dart';
import 'package:kuemele/shared/services/api_service/ads/ads_repo.dart';
import 'package:kuemele/shared/widgets/kumele_asset_widget.dart';
import 'package:kuemele/shared/widgets/kumele_video_player.dart';

/// Auto-scrolling ad carousel. Lays out ads in rows (max 2 rows × 3 cols),
/// sweeping continuously left until fully off-screen, then reversing to sweep
/// right, and repeating — exactly matching the iOS AdCarouselRail per-frame
/// motion model. All rows share one offset and move together.
///
/// Tiles aren't a fixed size: exactly 2 columns are sized to span the
/// container width at the design's 144.2:120.4 proportions, whatever that
/// width is — matching iOS, which can't know its width ahead of time either.
class AdCarouselRail extends StatefulWidget {
  const AdCarouselRail({
    super.key,
    required this.ads,
    this.placement = 'NOTIFICATIONS',
  });

  final List<AdItem> ads;
  final String placement;

  @override
  State<AdCarouselRail> createState() => _AdCarouselRailState();
}

class _AdCarouselRailState extends State<AdCarouselRail>
    with SingleTickerProviderStateMixin {
  static const double _itemAspectRatio = 144.2 / 120.4;
  static const double _visibleColumns = 2;
  static const double _spacing = 10;
  static const double _containerPadding = 12;
  static const double _containerRadius = 16;
  static const double _tileRadius = 12;
  static const int _tilesPerRow = 3;
  static const int _maxRows = 2;
  static const double _pxPerMs = 1 / 20; // 1px per 20ms, 50px/sec

  Ticker? _ticker;
  Duration _lastElapsed = Duration.zero;
  double _offset = 0;
  double _direction = -1; // -1 = left, 1 = right
  double _trackWidth = 0;

  double get _tileWidth => _trackWidth <= 0
      ? 0
      : ((_trackWidth - _spacing * (_visibleColumns - 1)) / _visibleColumns)
          .clamp(1, double.infinity);
  double get _tileHeight => _tileWidth / _itemAspectRatio;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick)..start();
  }

  @override
  void didUpdateWidget(covariant AdCarouselRail oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Ads can finish loading after this rail already mounted and started
    // ticking against an empty/short list — restart the sweep from the left
    // edge against the new content, matching iOS's `onChange(of: ads.count)`.
    if (widget.ads.length != oldWidget.ads.length) {
      _offset = 0;
      _direction = -1;
    }
  }

  @override
  void dispose() {
    _ticker?.dispose();
    super.dispose();
  }

  List<List<AdItem>> get _rows {
    final ads = widget.ads.take(_tilesPerRow * _maxRows).toList();
    final rows = <List<AdItem>>[];
    for (var i = 0;
        i < ads.length && rows.length < _maxRows;
        i += _tilesPerRow) {
      final end = (i + _tilesPerRow).clamp(0, ads.length);
      rows.add(ads.sublist(i, end));
    }
    return rows;
  }

  double _rowWidth(int tileCount) =>
      tileCount * _tileWidth + (tileCount - 1) * _spacing;

  /// Widest row's width — all rows sweep together, so use the longest.
  double get _contentWidth {
    final rows = _rows;
    if (rows.isEmpty) return 0;
    return rows
        .map((row) => _rowWidth(row.length))
        .reduce((a, b) => a > b ? a : b);
  }

  /// Per-frame tick (20ms). Sweeps continuously left (direction=-1) until
  /// content fully exits left edge (offset <= -contentWidth), then reverses
  /// to sweep right (direction=1) until content fully exits right edge
  /// (offset >= trackWidth), then reverses again. No pauses, continuous
  /// smooth motion — exact iOS AdCarouselRail behavior.
  void _onTick(Duration elapsed) {
    final deltaMs = (elapsed - _lastElapsed).inMicroseconds / 1000.0;
    _lastElapsed = elapsed;
    if (_trackWidth <= 0) return;

    final contentWidth = _contentWidth;
    if (contentWidth <= 0) return;

    final exitedLeft = -contentWidth;
    final exitedRight = _trackWidth;
    var nextDirection = _direction;
    var next = _offset + deltaMs * _pxPerMs * _direction;

    if (next <= exitedLeft) {
      next = exitedLeft;
      nextDirection = 1;
    } else if (next >= exitedRight) {
      next = exitedRight;
      nextDirection = -1;
    }

    if (next != _offset || nextDirection != _direction) {
      setState(() {
        _offset = next;
        _direction = nextDirection;
      });
    }
  }

  Future<void> _openAd(AdItem ad) async {
    try {
      final hobbyContext =
          await InjectionHelper.profileCubit.loadHobbyContext();
      await AdsRepo.trackAd(
        TrackAdRequest(
          adId: ad.id,
          campaignId: ad.campaignId,
          impressionId: ad.impressionId,
          eventType: 'click',
          placement: widget.placement,
          hobbyContext: hobbyContext,
        ),
      );
    } catch (_) {}

    if (!mounted) return;
    await AppDialog.show(
      context: context,
      width: AppDialogSize.notificationModalWidthFor(context),
      dialog: AdTapThroughDialog(ad: ad),
    );
  }

  Widget _adTile(AdItem ad) {
    return SizedBox(
      width: _tileWidth,
      height: _tileHeight,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(_tileRadius),
          onTap: () => _openAd(ad),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(_tileRadius),
            child: ad.mediaUrl?.isNotEmpty == true
                ? (ad.mediaType.toLowerCase() == 'video'
                    ? KumeleVideoPlayer(
                        videoPath: ad.mediaUrl!,
                        isNetwork: true,
                        fit: BoxFit.cover,
                        muted: true,
                        loop: true,
                      )
                    : KumeleAssetWidget(
                        assetPath: ad.mediaUrl!,
                        fit: BoxFit.cover,
                      ))
                : ColoredBox(
                    color: ColorSet.bg3Color,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          ad.title,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: ColorSet.textColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _rowContent(List<AdItem> row) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final ad in row) ...[
          _adTile(ad),
          if (ad != row.last) const SizedBox(width: _spacing),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final rows = _rows;
    if (rows.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(_containerPadding),
      decoration: BoxDecoration(
        color: ColorSet.bg2Color,
        borderRadius: BorderRadius.circular(_containerRadius),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // A width change (rotation, split-screen resize) invalidates the
          // in-flight offset against the old bounds — restart the sweep from
          // the left edge, matching iOS's `updateWidth`.
          if ((constraints.maxWidth - _trackWidth).abs() > 0.5) {
            _offset = 0;
            _direction = -1;
          }
          _trackWidth = constraints.maxWidth;
          return SizedBox(
            width: constraints.maxWidth,
            height: rows.length * _tileHeight + (rows.length - 1) * _spacing,
            child: ClipRect(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final row in rows) ...[
                    SizedBox(
                      height: _tileHeight,
                      child: Transform.translate(
                        offset: Offset(_offset, 0),
                        child: UnconstrainedBox(
                          alignment: Alignment.centerLeft,
                          constrainedAxis: Axis.vertical,
                          clipBehavior: Clip.hardEdge,
                          child: _rowContent(row),
                        ),
                      ),
                    ),
                    if (row != rows.last) const SizedBox(height: _spacing),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
