import 'dart:async';

import 'package:flick_video_player/flick_video_player.dart';
import 'package:video_player/video_player.dart';

class AnimationPlayerDataManager {
  bool inAnimation = false;
  final FlickManager flickManager;
  final List items;
  int currentIndex = 0;
  late Timer videoChangeTimer;

  AnimationPlayerDataManager(this.flickManager, this.items);

  playNextVideo([Duration? duration]) {
    if (currentIndex >= items.length - 1) {
      currentIndex = -1;
    }

    String nextVideoUrl = items[currentIndex + 1]['trailer_url'];

    if (currentIndex != items.length - 1) {
      if (duration != null) {
        videoChangeTimer = Timer(duration, () {
          currentIndex++;
        });
      } else {
        currentIndex++;
      }

      flickManager.handleChangeVideo(
          VideoPlayerController.networkUrl(Uri.parse(nextVideoUrl)),
          videoChangeDuration: duration, timerCancelCallback: (bool playNext) {
        videoChangeTimer.cancel();
        if (playNext) {
          currentIndex++;
        }
      });
    }
  }

  String getCurrentVideoTitle() {
    if (currentIndex != -1) {
      return items[currentIndex]['title'];
    } else {
      return items[items.length - 1]['title'];
    }
  }

  String getNextVideoTitle() {
    if (currentIndex != items.length - 1) {
      return items[currentIndex + 1]['title'];
    } else {
      return items[0]['title'];
    }
  }

  String getCurrentPoster() {
    if (currentIndex != -1) {
      return items[currentIndex]['image'];
    } else {
      return items[items.length - 1]['image'];
    }
  }
}
