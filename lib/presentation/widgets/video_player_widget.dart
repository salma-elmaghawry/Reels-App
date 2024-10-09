import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:reels/helper/conatants.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({
    required this.videoUrl,
    required this.onVideoEnd,
    required this.cacheManager,
    super.key,
  });

  final String videoUrl;
  final VoidCallback onVideoEnd;
  final CacheManager cacheManager;

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController? _controller;
  Timer? _timer;
  double _progress = 0.0;
  bool _showControlIcon = false;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  Future<void> _initializeVideoPlayer() async {
    try {
      final fileInfo =
          await widget.cacheManager.getFileFromCache(widget.videoUrl);
      final videoFile = fileInfo?.file;

      if (videoFile != null) {
        _controller = VideoPlayerController.file(videoFile);
      } else {
        _controller = VideoPlayerController.network(widget.videoUrl);
      }

      await _controller!.initialize();
      setState(() {});
      _controller!.play();
      _startProgressTracking();

      _controller!.addListener(_onVideoEnd);
    } catch (e) {
      setState(() {
        _controller = null;
      });
      print('Error initializing video player: $e');
    }
  }

  void _onVideoEnd() {
    if (_controller != null &&
        _controller!.value.isInitialized &&
        _controller!.value.position >= _controller!.value.duration) {
      widget.onVideoEnd();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller?.removeListener(_onVideoEnd); // Remove listener when disposing
    _controller?.dispose();
    super.dispose();
  }

  void _startProgressTracking() {
    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (_controller != null && _controller!.value.isInitialized) {
        setState(() {
          _progress = _controller!.value.position.inSeconds /
              _controller!.value.duration.inSeconds;
        });
      }
    });
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller != null) {
        if (_controller!.value.isPlaying) {
          _controller!.pause();
        } else {
          _controller!.play();
        }
        _showControlIcon = true;

        // Hide the control icon after a delay
        Future.delayed(const Duration(seconds: 2), () {
          setState(() {
            _showControlIcon = false;
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _togglePlayPause,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: Center(
                    child: _controller != null &&
                            _controller!.value.isInitialized
                        ? AspectRatio(
                            aspectRatio: _controller!.value.aspectRatio,
                            child: VideoPlayer(_controller!),
                          )
                        : const CircularProgressIndicator(color: primarycolor),
                  ),
                ),
                LinearProgressIndicator(
                  color: primarycolor,
                  value: _progress,
                ),
              ],
            ),
            if (_showControlIcon)
              Center(
                child: Icon(
                  _controller != null && _controller!.value.isPlaying
                      ? Icons.pause_circle_filled
                      : Icons.play_circle_filled,
                  size: 80,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
