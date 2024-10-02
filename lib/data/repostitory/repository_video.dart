import 'package:video_player/video_player.dart';

class VideoRepository {
  VideoPlayerController? _controller;
  String currentVideoUrl = '';

  Future<void> initializeVideo(String videoUrl) async {
    _controller = VideoPlayerController.network(videoUrl);
    currentVideoUrl = videoUrl;
    await _controller!.initialize();
  }

  void playVideo() {
    _controller?.play();
  }

  void pauseVideo() {
    _controller?.pause();
  }

  VideoPlayerController? get controller => _controller;

  bool isVideoFinished() {
    return _controller != null && _controller!.value.position >= _controller!.value.duration;
  }
}
