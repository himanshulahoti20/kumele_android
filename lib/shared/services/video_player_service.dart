import 'package:video_player/video_player.dart';

class VideoPlayerService {
  VideoPlayerController getAssetController(String path) {
    return VideoPlayerController.asset(path);
  }

  VideoPlayerController getNetworkController(String url) {
    return VideoPlayerController.networkUrl(Uri.parse(url));
  }
}
