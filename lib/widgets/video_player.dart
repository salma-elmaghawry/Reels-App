import 'dart:async';
import 'package:flutter/material.dart';
import 'package:reels/widgets/conatants.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({
    required this.videoUrl,
    required this.onVideoEnd,
    super.key,
  });

  final String videoUrl;
  final VoidCallback onVideoEnd; // Callback for when the video ends

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
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
        _startProgressTracking(); // Start tracking progress after initialization
      });

    // Add listener to detect when the video ends
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

      // Show play/pause icon when toggled
      _showControlIcon = true;

      // Hide the play/pause icon after 2 seconds for a cleaner UI
      Future.delayed(Duration(seconds: 2), () {
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
            // Full-Screen Video Player
            Column(
              children: [
                Expanded(
                  child: Center(
                    child: _controller.value.isInitialized
                        ? AspectRatio(
                            aspectRatio: _controller.value.aspectRatio,
                            child: VideoPlayer(_controller),
                          )
                        : CircularProgressIndicator(color: primarycolor,),
                  ),
                ),
                // Progress Bar
                LinearProgressIndicator(
                  value: _progress,
                  backgroundColor: Colors.white.withOpacity(0.3),
                  valueColor: AlwaysStoppedAnimation<Color>(primarycolor),
                ),
              ],
            ),
            // Play/Pause Icon
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
