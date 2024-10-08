import 'package:flutter/material.dart';
import 'package:reels/data/Services/api_service.dart';
import 'package:reels/data/repostitory/repo.dart';
import 'package:reels/presentation/widgets/video_player_widget.dart';


class HomePage extends StatefulWidget {
  static String id = "HomePage";
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiService _apiService = ApiService();
  final VideoRepository _videoRepository = VideoRepository();
  late Future<List<String>> _videos;

  @override
  void initState() {
    super.initState();
    _videos = _apiService.getReels(); 
  }

  @override
  void dispose() {
    _videoRepository.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: FutureBuilder<List<String>>(
        future: _videos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final videos = snapshot.data!;
            return ListView.builder(
              itemCount: videos.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Video ${index + 1}'),
                  onTap: () async {
                    await _videoRepository.initializePlayer(videos[index]);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VideoPlayerWidget(videoRepository: _videoRepository),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
