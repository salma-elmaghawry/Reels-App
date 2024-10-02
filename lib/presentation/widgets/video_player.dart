import 'dart:async';
import 'package:flutter/material.dart';
import 'package:reels/helper/conatants.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  const VideoPlayerWidget({
    required this.videoUrl,
    required this.onVideoEnd,
    super.key,
  });

  final String videoUrl;
  final VoidCallback onVideoEnd;

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  Timer? _timer;
  double _progress = 0.0;
  bool _isPaused = false;
  bool _showControlIcon = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
        _startProgressTracking();
      });
    _controller.addListener(() {
      if (_controller.value.isInitialized &&
          _controller.value.position >= _controller.value.duration) {
        widget.onVideoEnd(); // Trigger the next video callback
      }
    });
  }
  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }
  void _startProgressTracking() {
    _timer = Timer.periodic(Duration(milliseconds: 500), (timer) {
      if (_controller.value.isInitialized) {
        setState(() {
          _progress = _controller.value.position.inSeconds /
              _controller.value.duration.inSeconds;
        });
      }
    });
  }
  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
        _isPaused = true;
      } else {
        _controller.play();
        _isPaused = false;
      }
      _showControlIcon = true;
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _showControlIcon = false;
        });
      });
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
                    child: _controller.value.isInitialized
                        ? AspectRatio(
                            aspectRatio: _controller.value.aspectRatio,
                            child: VideoPlayer(_controller),
                          )
                        : const CircularProgressIndicator(
                            color: primarycolor,
                          ),
                  ),
                ),
                LinearProgressIndicator(
                  value: _progress,
                  backgroundColor: Colors.white.withOpacity(0.3),
                  valueColor: const AlwaysStoppedAnimation<Color>(primarycolor),
                ),
              ],
            ),
            if (_showControlIcon)
              Center(
                child: Icon(
                  _controller.value.isPlaying
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
