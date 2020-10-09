import 'dart:async';
import 'package:cached_flick_video_player/flick_video_player.dart';

class DataManager {
  DataManager({this.flickManager, this.urls});

  int currentPlaying = 0;
  final FlickManager flickManager;
  final List<String> urls;

  Timer videoChangeTimer;

  String getNextVideo() {
    currentPlaying++;
    return urls[currentPlaying];
  }

  bool hasNextVideo() {
    return currentPlaying != urls.length - 1;
  }

  bool hasPreviousVideo() {
    return currentPlaying != 0;
  }

  skipToNextVideo([Duration duration]) {
    if (hasNextVideo()) {
      flickManager.handleChangeVideo(
          CachedVideoPlayerController.network(urls[currentPlaying + 1]),
          videoChangeDuration: duration);

      currentPlaying++;
    }
  }

  skipToPreviousVideo() {
    if (hasPreviousVideo()) {
      currentPlaying--;
      flickManager.handleChangeVideo(
          CachedVideoPlayerController.network(urls[currentPlaying]));
    }
  }

  cancelVideoAutoPlayTimer({bool playNext}) {
    if (playNext != true) {
      currentPlaying--;
    }

    flickManager.flickVideoManager.cancelVideoAutoPlayTimer(playNext: playNext);
  }
}
