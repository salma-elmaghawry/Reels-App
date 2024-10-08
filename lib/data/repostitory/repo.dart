// import 'package:flutter_cache_manager/flutter_cache_manager.dart';
// import 'package:video_player/video_player.dart';

// class VideoRepository {
//   VideoPlayerController? _controller;

//   VideoPlayerController get controller {
//     if (_controller == null) {
//       throw Exception('VideoPlayerController is not initialized. Call initializePlayer first.');
//     }
//     return _controller!;
//   }

//   void initializePlayer(String videoUrl) {
//     if (_controller != null) {
//       _controller!.dispose(); 
//     }

//     final cacheManager = DefaultCacheManager();
//     _controller = VideoPlayerController.network(videoUrl)
//       ..initialize().then((_) {
//         _controller!.setLooping(false); 
//         _controller!.play(); 
//       });
//   }

//   void dispose() {
//     _controller?.dispose();
//   }
// }
