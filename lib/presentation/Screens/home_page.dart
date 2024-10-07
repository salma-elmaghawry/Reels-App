import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:reels/data/Services/api_service.dart';
import 'package:reels/helper/conatants.dart';
import 'package:reels/presentation/widgets/video_player_widget.dart';

class HomePage extends StatefulWidget {
  static String id = "HomePage";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<String>> _reelsFuture;
  int videoIndex = 0;
  VideoPlayerController? _controller;
  late PageController _pageController;
  Future<void>? _initializeVideoPlayerFuture;
  bool _isControllerDisposed = false;

  @override
  void initState() {
    super.initState();
    _reelsFuture = FetchService().getReels();
    _pageController = PageController();
    _reelsFuture.then((reels) {
      if (reels.isNotEmpty) {
        _initializeVideoPlayer(reels);
      }
    });
  }

  Future<void> _initializeVideoPlayer(List<String> reels) async {
    if (_controller != null) {
      _isControllerDisposed = true;
      await _controller!.dispose();
    }

    _controller = VideoPlayerController.network(reels[videoIndex]);
    _isControllerDisposed = false;
    _initializeVideoPlayerFuture = _controller!.initialize();
    await _initializeVideoPlayerFuture;
    _controller!.setLooping(true);
    _controller!.play();
    setState(() {}); // Update the UI
  }

  @override
  void dispose() {
    _isControllerDisposed = true;
    _controller?.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      
      
      body: FutureBuilder<List<String>>(
        future: _reelsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const  Center(child: CircularProgressIndicator(color: primarycolor));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const  Center(child: Text('No Reels Available'));
          }

          return PageView.builder(
            scrollDirection: Axis.vertical,
            
            itemCount: snapshot.data!.length,
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                videoIndex = index;
              });
              _initializeVideoPlayer(snapshot.data!);
            },
            itemBuilder: (context, index) {
              return _controller != null && !_isControllerDisposed
                  ? VideoPlayerWidget(controller: _controller!)
                  : const Center(child: CircularProgressIndicator(color: primarycolor));
            },
          );
        },
      ),
    );
  }
}
