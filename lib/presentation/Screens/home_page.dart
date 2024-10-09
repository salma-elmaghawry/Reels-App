import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:reels/data/Services/api_service.dart';
import 'package:reels/helper/conatants.dart';
import 'package:reels/presentation/widgets/video_player_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static String id = "HomePage";
  @override
  State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  late Future<List<dynamic>> _reelsFuture;
  int _currentIndex = 0;
  PageController _pageController = PageController();
  final CacheManager _cacheManager = DefaultCacheManager();
  final int _cacheBatchSize = 5;  
  
  @override
  void initState() {
    super.initState();
    _reelsFuture = FetchService().getReels();
    _reelsFuture.then((reels) {
      _cacheVideos(0, _cacheBatchSize, reels);
    });

  }
  Future<void> _cacheVideos(int startIndex, int count, List<dynamic> reels) async {
    final endIndex = (startIndex + count) > reels.length ? reels.length : (startIndex + count);
    for (int i = startIndex; i < endIndex; i++) {
      final videoUrl = reels[i]['video'];
      await _cacheManager.downloadFile(videoUrl);
    }
  }

  void _playNextVideo() {
    setState(() {
      _currentIndex = (_currentIndex + 1) ;  
    });
    _pageController.animateToPage(
      _currentIndex,
      duration:const  Duration(milliseconds: 300),
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
            return const  Center(child: CircularProgressIndicator(color: primarycolor,));
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
                if (index % _cacheBatchSize == 0 && index + _cacheBatchSize < reels.length) {
                  _cacheVideos(index, _cacheBatchSize, reels);
                }
              },
              itemCount: reels.length,
              itemBuilder: (context, index) {
                return VideoPlayerScreen(
                  videoUrl: reels[index]['video'],
                  onVideoEnd: _playNextVideo,  
                  cacheManager:_cacheManager,
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
