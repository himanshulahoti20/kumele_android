import 'package:flutter/material.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:video_player/video_player.dart';

class KumeleVideoPlayer extends StatefulWidget {
  final String videoPath;
  final BoxFit fit;
  final bool autoPlay;
  final bool loop;
  final bool isNetwork;
  final bool muted;

  /// Shown instead of the video whenever it can't load or play — a bad
  /// URL, an unsupported codec, or a decoder that fails after init (e.g. no
  /// hardware h264 support). Pass the item's still image here so callers
  /// fall back to that instead of a bare "video unavailable" icon.
  final Widget? errorFallback;

  const KumeleVideoPlayer({
    super.key,
    required this.videoPath,
    this.fit = BoxFit.cover,
    this.autoPlay = true,
    this.loop = false,
    this.isNetwork = false,
    this.muted = false,
    this.errorFallback,
  });

  @override
  State<KumeleVideoPlayer> createState() => _KumeleVideoPlayerState();
}

class _KumeleVideoPlayerState extends State<KumeleVideoPlayer> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  // Without this, a failed initialize() (bad URL, unsupported codec,
  // network error) left `_isInitialized` false forever — build() kept
  // returning the spinner with no terminal state, so the tile looked
  // stuck "constantly loading" instead of showing that it failed.
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    _controller = widget.isNetwork
        ? InjectionHelper.videoPlayerService
            .getNetworkController(widget.videoPath)
        : InjectionHelper.videoPlayerService
            .getAssetController(widget.videoPath);
    try {
      await _controller.initialize();
      await _controller.setVolume(0.0);
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
        if (widget.muted) {
          _controller.setVolume(0);
        }
        if (widget.autoPlay) {
          _controller.play();
        }
        if (widget.loop) {
          _controller.setLooping(true);
        }
        // initialize() only fetches metadata — a decoder that fails to
        // actually start (e.g. an emulator/device without hardware h264
        // support) errors out *after* this resolves, so this is the only
        // place that catches it. Without this listener the widget kept
        // rendering the (blank/glitched) VideoPlayer surface forever —
        // looked fine for a moment, then "trash" once decoding broke.
        _controller.addListener(_onControllerUpdate);
      }
    } catch (e) {
      debugPrint("Error initializing video: $e");
      if (mounted) setState(() => _hasError = true);
    }
  }

  void _onControllerUpdate() {
    if (_hasError || !mounted) return;
    if (_controller.value.hasError) {
      debugPrint("Video playback error: ${_controller.value.errorDescription}");
      setState(() => _hasError = true);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerUpdate);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return widget.errorFallback ??
          const Center(
            child: Icon(Icons.videocam_off_outlined, color: Colors.white38),
          );
    }
    if (!_isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return ClipRect(
      child: SizedBox.expand(
        child: FittedBox(
          fit: widget.fit,
          child: SizedBox(
            width: _controller.value.size.width,
            height: _controller.value.size.height,
            child: VideoPlayer(_controller),
          ),
        ),
      ),
    );
  }
}
