import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reels/data/repostitory/repository_video.dart';
import 'video_state.dart';

class VideoCubit extends Cubit<VideoState> {
  final VideoRepository videoRepository;
  
  VideoCubit(  this.videoRepository) : super(VideoInitial());

  void loadVideo(String videoUrl) async {
    emit(VideoLoading());
    try {
      await videoRepository.initializeVideo(videoUrl);
      playVideo();
      emit(VideoPlaying(videoUrl));
    } catch (e) {
      emit(VideoError("Error loading video: $e"));
    }
  }

  void playVideo() {
    videoRepository.playVideo();
    emit(VideoPlaying(videoRepository.currentVideoUrl));
  }

  void pauseVideo() {
    videoRepository.pauseVideo();
    emit(VideoPaused(videoRepository.currentVideoUrl));
  }

  void videoEnded() {
    emit(VideoEnded());
  }
}
