import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:kuemele/shared/components/app_colors.dart';

import 'ad_consent_service.dart';

/// Drop-in placement widget for an approved Kumele ad slot (Local Events or
/// Notifications). Loads a Google AdMob native ad for [adUnitId] and renders
/// it via [factoryId] — a native ad factory registered in MainActivity.kt
/// that draws the ad using Kumele's own card layout — once loaded. Renders
/// [fallback] — the Kumele first-party ad — whenever consent hasn't been
/// granted, no unit ID exists yet for this placement (e.g. Blog), or the
/// AdMob request fails, so the placement always looks the same either way.
class KumeleNativeAdWidget extends StatefulWidget {
  const KumeleNativeAdWidget({
    super.key,
    required this.adUnitId,
    required this.factoryId,
    required this.fallback,
    this.height,
  });

  final String? adUnitId;
  final String factoryId;
  final Widget fallback;

  /// Fixed height to give the ad, needed whenever the parent (e.g. a
  /// ListView item) doesn't already provide bounded constraints. Leave null
  /// when the parent already constrains both dimensions.
  final double? height;

  @override
  State<KumeleNativeAdWidget> createState() => _KumeleNativeAdWidgetState();
}

class _KumeleNativeAdWidgetState extends State<KumeleNativeAdWidget> {
  NativeAd? _ad;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _maybeLoad();
  }

  Future<void> _maybeLoad() async {
    final adUnitId = widget.adUnitId;
    if (adUnitId == null) return;

    final allowed = await AdConsentService.instance.canRequestAds;
    if (!allowed || !mounted) return;

    final ad = NativeAd(
      adUnitId: adUnitId,
      request: AdRequest(),
      factoryId: widget.factoryId,
      customOptions: {'isDark': ColorSet.isDarkMode},
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          if (!mounted) {
            ad.dispose();
            return;
          }
          setState(() => _loaded = true);
        },
        onAdFailedToLoad: (ad, error) => ad.dispose(),
      ),
    );
    _ad = ad;
    ad.load();
  }

  @override
  void dispose() {
    _ad?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ad = _ad;
    if (ad == null || !_loaded) return widget.fallback;

    final adWidget = AdWidget(ad: ad);
    return widget.height == null
        ? adWidget
        : SizedBox(height: widget.height, child: adWidget);
  }
}
