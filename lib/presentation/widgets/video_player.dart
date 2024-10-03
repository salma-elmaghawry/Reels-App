import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reels/business_logic/cubit/video_cubit.dart';
import 'package:reels/business_logic/cubit/video_state.dart';
import 'package:reels/helper/conatants.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  const VideoPlayerWidget(
      {super.key, required this.videoUrl, required this.onVideoEnd});

  final String videoUrl;
  final VoidCallback onVideoEnd;

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  Timer? _timer;
  double _progress = 0.0;
  bool _showControlIcon = false;

  @override
  void initState() {
    super.initState();
    context.read<VideoCubit>().loadVideo(widget.videoUrl);
    _startProgressTracking();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startProgressTracking() {
    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      final controller = context.read<VideoCubit>().videoRepository.controller;
      if (controller != null && controller.value.isInitialized) {
        setState(() {
          _progress = (controller.value.position.inSeconds.toDouble() /
              (controller.value.duration.inSeconds.toDouble() + 0.001));
          if (controller.value.position >= controller.value.duration) {
            widget.onVideoEnd();
          }
        });
      }
    });
  }

  void _togglePlayPause() {
    final cubit = context.read<VideoCubit>();
    if (cubit.videoRepository.controller?.value.isPlaying ?? false) {
      cubit.pauseVideo();
    } else {
      cubit.playVideo();
    }
    setState(() {
      _showControlIcon = true;
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          _showControlIcon = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VideoCubit, VideoState>(
      builder: (context, state) {
        if (state is VideoLoading) {
          return const Center(child: CircularProgressIndicator(color: primarycolor,));
        } else if (state is VideoPlaying || state is VideoPaused) {
          final controller =
              context.read<VideoCubit>().videoRepository.controller;
          if (controller == null || !controller.value.isInitialized) {
            return const Center(child: CircularProgressIndicator(color: primarycolor,));
          }

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
                          child: AspectRatio(
                            aspectRatio: controller.value.aspectRatio,
                            child: VideoPlayer(controller),
                          ),
                        ),
                      ),
                      LinearProgressIndicator(
                        value: _progress,
                        backgroundColor: Colors.white.withOpacity(0.3),
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(primarycolor),
                      ),
                    ],
                  ),
                  if (_showControlIcon)
                    Center(
                      child: Icon(
                        controller.value.isPlaying
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
        } else if (state is VideoError) {
          return Center(child: Text('Error: ${state.message}'));
        }
        return const Center(child: Text('No video loaded'));
      },
    );
  }
}
