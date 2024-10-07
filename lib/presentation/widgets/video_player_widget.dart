import 'package:flutter/material.dart';
import 'package:reels/helper/conatants.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final VideoPlayerController controller;

  VideoPlayerWidget({required this.controller});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_updateState);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateState);
    super.dispose();
  }

  void _updateState() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Fullscreen video player
        GestureDetector(
          onTap: () {
            if (widget.controller.value.isPlaying) {
              widget.controller.pause();
            } else {
              widget.controller.play();
            }
          },
          child: SizedBox.expand(
            child: VideoPlayer(widget.controller),
          ),
        ),
        Positioned(
          bottom: 10,
          left: 16,
          right: 16,
          child: LinearProgressIndicator(
            value: widget.controller.value.isInitialized
                ? widget.controller.value.position.inMilliseconds /
                    widget.controller.value.duration.inMilliseconds
                : 0,
            backgroundColor: Colors.grey,
            valueColor: const  AlwaysStoppedAnimation<Color>(primarycolor),
          ),
        ),
      ],
    );
  }
}
