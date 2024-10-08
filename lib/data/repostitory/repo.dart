import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:video_player/video_player.dart';

class VideoRepository {
  VideoPlayerController? _controller;
  final List<String> _cachedVideos = [];

  Future<void> initializePlayer(String videoUrl) async {
    final fileInfo = await DefaultCacheManager().getFileFromCache(videoUrl);
    
    if (fileInfo == null) {
      _controller = VideoPlayerController.network(videoUrl);
      await _controller!.initialize();
      await cacheVideo(videoUrl);
    } else {
      final file = fileInfo.file;
      _controller = VideoPlayerController.file(file);
      await _controller!.initialize();
    }
    
    _controller!.play(); 
  }

  Future<void> cacheVideo(String videoUrl) async {
    await DefaultCacheManager().downloadFile(videoUrl); 
    _cachedVideos.add(videoUrl); 
  }

  Future<void> preloadVideos(List<String> videoUrls) async {
    for (String url in videoUrls) {
      if (!_cachedVideos.contains(url)) {
        await cacheVideo(url); 
      }
    }
  }

  VideoPlayerController? get controller => _controller;

  void dispose() {
    _controller?.dispose();
  }
}
