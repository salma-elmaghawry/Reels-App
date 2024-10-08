import 'package:flutter/material.dart';
import 'package:reels/data/repostitory/repo.dart';
import 'package:video_player/video_player.dart';
class VideoPlayerWidget extends StatefulWidget {
  final VideoRepository videoRepository;

  const VideoPlayerWidget({Key? key, required this.videoRepository}) : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    widget.videoRepository.dispose(); // Dispose of the video controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      body: Center(
        child: FutureBuilder(
          future: widget.videoRepository.controller?.initialize(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return AspectRatio(
                aspectRatio: 16 / 9,
                child: VideoPlayer(widget.videoRepository.controller!),
              );
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            widget.videoRepository.controller!.value.isPlaying
                ? widget.videoRepository.controller!.pause()
                : widget.videoRepository.controller!.play();
          });
        },
        child: Icon(
          widget.videoRepository.controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }
}
