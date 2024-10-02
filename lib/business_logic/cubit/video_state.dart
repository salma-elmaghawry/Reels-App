abstract class VideoState {}

class VideoInitial extends VideoState {}

class VideoLoading extends VideoState {}

class VideoPlaying extends VideoState {
  final String videoUrl;
  VideoPlaying(this.videoUrl);
}

class VideoPaused extends VideoState {
  final String videoUrl;
  VideoPaused(this.videoUrl);
}

class VideoEnded extends VideoState {}

class VideoError extends VideoState {
  final String message;
  VideoError(this.message);
}
