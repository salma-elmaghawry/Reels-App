import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reels/business_logic/cubit/video_cubit.dart';
import 'package:reels/data/Services/api_service.dart';
import 'package:reels/data/repostitory/repository_video.dart';
import 'package:reels/helper/conatants.dart';
import 'package:reels/presentation/widgets/video_player.dart';

class HomePage extends StatefulWidget {
  static String id = "HomePage";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<dynamic>> _reelsFuture;
  int _currentIndex = 0;
  late PageController _pageController;
  

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _reelsFuture = FetchService().getReels();
  }

  @override
  void dispose() {
    _pageController.dispose(); 
    super.dispose();
  }

  void _playNextVideo(List<dynamic> reels) {
    setState(() {
      _currentIndex = ((_currentIndex + 1) % reels.length).toInt();
    });
    _pageController.animateToPage(
      _currentIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
    create: (context) => VideoCubit( VideoRepository()),
      child: Scaffold(
        body: FutureBuilder<List<dynamic>>(
          future: _reelsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: primarycolor,));
            } else 
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              final reels = snapshot.data!;
              if (reels.isEmpty) {
                return const Center(child: Text('No videos available'));
              }

              return PageView.builder(
                controller: _pageController,
                scrollDirection: Axis.vertical,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemCount: reels.length,
                itemBuilder: (context, index) {
                  final videoUrl = reels[index]['video'];
                  if (videoUrl == null || videoUrl.isEmpty) {
                    return const Center(child: Text('Invalid video URL'));
                  }

                  return Container(
                    color: Colors.black, 
                    child: VideoPlayerWidget(
                      videoUrl: videoUrl,
                      onVideoEnd: () => _playNextVideo(reels),
                    ),
                  );
                },
              );
            } else {
              return const Center(child: Text('No videos available'));
            }
          },
        ),
      ),
    );
  }
}
