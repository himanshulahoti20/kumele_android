import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/models/ads.dart';
import 'package:kuemele/shared/widgets/kumele_asset_widget.dart';
import 'package:kuemele/shared/widgets/kumele_video_player.dart';

/// Media region of an ad. A single slide renders directly; several rotate every
/// 5 seconds and can also be swiped (a manual change restarts the timer). Video
/// slides autoplay muted and loop inline with no controls.
class AdMediaCarousel extends StatefulWidget {
  const AdMediaCarousel({super.key, required this.ad});

  final AdItem ad;

  @override
  State<AdMediaCarousel> createState() => _AdMediaCarouselState();
}

class _AdMediaCarouselState extends State<AdMediaCarousel> {
  static const _interval = Duration(seconds: 5);
  final _controller = PageController();
  Timer? _timer;
  int _index = 0;

  List<AdSlide> get _slides => widget.ad.slides;

  @override
  void initState() {
    super.initState();
    _restartTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _restartTimer() {
    _timer?.cancel();
    if (_slides.length < 2) return;
    _timer = Timer.periodic(_interval, (_) {
      if (!mounted || !_controller.hasClients) return;
      final next = (_index + 1) % _slides.length;
      _controller.animateToPage(
        next,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  Widget _slide(AdSlide slide) {
    if (slide.isVideo) {
      return KumeleVideoPlayer(
        key: ValueKey(slide.url),
        videoPath: slide.url,
        isNetwork: true,
        fit: BoxFit.cover,
        muted: true,
        loop: true,
      );
    }
    return KumeleAssetWidget(
      assetPath: slide.url,
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.cover,
    );
  }

  @override
  Widget build(BuildContext context) {
    final slides = _slides;
    if (slides.isEmpty) return ColoredBox(color: ColorSet.tileFillColor);
    if (slides.length == 1) return _slide(slides.first);
    return PageView.builder(
      controller: _controller,
      itemCount: slides.length,
      // Any page change, automatic or manual, restarts the 5 s wait.
      onPageChanged: (page) {
        _index = page;
        _restartTimer();
      },
      itemBuilder: (_, i) => _slide(slides[i]),
    );
  }
}
