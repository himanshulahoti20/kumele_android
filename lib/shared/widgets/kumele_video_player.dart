import 'package:flutter/material.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:video_player/video_player.dart';

class KumeleVideoPlayer extends StatefulWidget {
  final String videoPath;
  final BoxFit fit;
  final bool autoPlay;
  final bool loop;

  const KumeleVideoPlayer({
    super.key,
    required this.videoPath,
    this.fit = BoxFit.cover,
    this.autoPlay = true,
    this.loop = false,
  });

  @override
  State<KumeleVideoPlayer> createState() => _KumeleVideoPlayerState();
}

class _KumeleVideoPlayerState extends State<KumeleVideoPlayer> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    _controller =
        InjectionHelper.videoPlayerService.getAssetController(widget.videoPath);
    try {
      await _controller.initialize();
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
        if (widget.autoPlay) {
          _controller.play();
        }
        if (widget.loop) {
          _controller.setLooping(true);
        }
      }
    } catch (e) {
      debugPrint("Error initializing video: $e");
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return FittedBox(
      fit: widget.fit,
      child: SizedBox(
        width: _controller.value.size.width,
        height: _controller.value.size.height,
        child: VideoPlayer(_controller),
      ),
    );
  }
}
