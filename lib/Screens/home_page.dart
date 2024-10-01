import 'package:flutter/material.dart';
import 'package:reels/widgets/conatants.dart';
import 'package:reels/widgets/video_player.dart';
import 'package:reels/Services/api_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static String id = "HomePage";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<dynamic>> _reelsFuture;
  int _currentIndex = 0;
  PageController _pageController = PageController();  // Controller for scrolling

  @override
  void initState() {
    super.initState();
    _reelsFuture = FetchService().getReels();
  }

  void _playNextVideo() {
    setState(() {
      _currentIndex = (_currentIndex + 1) ;  // Assuming 10 videos per page
    });
    // Scroll to the next video
    _pageController.animateToPage(
      _currentIndex,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<dynamic>>(
        future: _reelsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: primarycolor,));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final reels = snapshot.data!;
            return PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.vertical,  // For vertical scroll
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemCount: reels.length,
              itemBuilder: (context, index) {
                return VideoPlayerScreen(
                  videoUrl: reels[index]['video'],
                  onVideoEnd: _playNextVideo,  // Trigger next video on video end
                );
              },
            );
          } else {
            return Center(child: Text('No videos available'));
          }
        },
      ),
    );
  }
}
