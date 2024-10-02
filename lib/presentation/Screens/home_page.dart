import 'package:flutter/material.dart';
import 'package:reels/helper/conatants.dart';
import 'package:reels/presentation/widgets/video_player.dart';
import 'package:reels/data/Services/api_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static String id = "HomePage";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<dynamic>> _reelsFuture;
  int _currentIndex = 0;
  final PageController _pageController = PageController(); 

  @override
  void initState() {
    super.initState();
    _reelsFuture = FetchService().getReels();
  }

  void _playNextVideo() {
    setState(() {
      _currentIndex = (_currentIndex + 1) ; 
    });
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
            return  const Center(
              child: CircularProgressIndicator(color: primarycolor,));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final reels = snapshot.data!;
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
                return VideoPlayerWidget(
                  videoUrl: reels[index]['video'],
                  onVideoEnd: _playNextVideo,  
                );
              },
            );
          } else {
            return const Center(child: Text('No videos available'));
          }
        },
      ),
    );
  }
}
