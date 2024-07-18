# Flick Video Player

Flick Video Player is a video player for flutter.
The [video_player](https://pub.dev/packages/video_player) plugin gives low level access for the video playback. Flick Player wraps `video_player` under the hood and provides base architecture for developers to create their own set of UI and functionalities.

# Features

- Double tap to seek video.
- On video tap play/pause, mute/unmute, or perform any action on video.
- Auto hide controls.
- Custom animations.
- Custom controls for normal and fullscreen.
- Auto-play list of videos.
- Change playback speed.
- Keyboard shortcuts for web.

# Demo Mobile

|                                                              ![](https://github.com/GeekyAnts/flick-video-player-demo-videos/blob/master/demo/default_player.gif?raw=true)                                                              |                                                                ![](https://github.com/GeekyAnts/flick-video-player-demo-videos/blob/master/demo/animation_player.gif?raw=true)                                                                |                                                           ![](https://github.com/GeekyAnts/flick-video-player-demo-videos/blob/master/demo/feed_player.gif?raw=true)                                                           |
| :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------: | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------: | :----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------: |
| Default player <br>[Video](https://github.com/GeekyAnts/flick-video-player-demo-videos/blob/master/demo/default_player.mp4?raw=true) <br>[Code](https://github.com/GeekyAnts/flick-video-player/tree/master/example/lib/default_player) | Animation player <br>[Video](https://github.com/GeekyAnts/flick-video-player-demo-videos/blob/master/demo/animation_player.mp4?raw=true) <br>[Code](https://github.com/GeekyAnts/flick-video-player/tree/master/example/lib/animation_player) | Feed player <br>[Video](https://github.com/GeekyAnts/flick-video-player-demo-videos/blob/master/demo/feed_player.mp4?raw=true) <br>[Code](https://github.com/GeekyAnts/flick-video-player/tree/master/example/lib/feed_player) |

|                                                                     ![](https://github.com/GeekyAnts/flick-video-player-demo-videos/blob/master/demo/custom_orientation.gif?raw=true)                                                                      |                                                                ![](https://github.com/GeekyAnts/flick-video-player-demo-videos/blob/master/demo/landscape_player.gif?raw=true)                                                                |                                                                      ![](https://github.com/rohitprajapatii/assets/blob/main/short_video_player.gif)                                                                       |
| :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------: | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------: | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------: |
| Orientation player <br>[Video](https://github.com/GeekyAnts/flick-video-player-demo-videos/blob/master/demo/custom_orientation.mp4?raw=true) <br>[Code](https://github.com/GeekyAnts/flick-video-player/tree/master/example/lib/custom_orientation_player) | Landscape player <br>[Video](https://github.com/GeekyAnts/flick-video-player-demo-videos/blob/master/demo/landscape_player.mp4?raw=true) <br>[Code](https://github.com/GeekyAnts/flick-video-player/tree/master/example/lib/landscape_player) | Short Video player <br>[Video](https://github.com/rohitprajapatii/assets/blob/main/short_video_player.mp4?raw=true) <br>[Code](https://github.com/GeekyAnts/flick-video-player/tree/master/example/lib/short_video_player) |

# Demo Web

|                                                             ![](https://github.com/GeekyAnts/flick-video-player-demo-videos/blob/master/demo/web_player.gif?raw=true)                                                             |
| :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------: |
| Web player <br>[Video](https://github.com/GeekyAnts/flick-video-player-demo-videos/blob/master/demo/web_player.mp4?raw=true) <br>[Code](https://github.com/GeekyAnts/flick-video-player/tree/master/example/lib/web_video_player) |

### Example

Please run the app in the example/ folder to start playing!

Refer to this [article](https://geekyants.com/blog/creating-a-customisable-video-player-in-flutter-283) to understand how things are working under the hood.

### Installation

Add the following dependencies in your pubspec.yaml file of your flutter project.

```dart
    flick_video_player: <latest_version>
    video_player: <latest_version>
```

### How to use

Create a `FlickManager` and pass the manager to `FlickVideoPlayer`, make sure to dispose `FlickManager` after use.

```dart
import 'package:flutter/material.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:video_player/video_player.dart';

class SamplePlayer extends StatefulWidget {
  SamplePlayer({Key key}) : super(key: key);

  @override
  _SamplePlayerState createState() => _SamplePlayerState();
}

class _SamplePlayerState extends State<SamplePlayer> {
  late FlickManager flickManager;
  @override
  void initState() {
    super.initState();
    flickManager = FlickManager(
      videoPlayerController:
          VideoPlayerController.networkUrl(Uri.parse("url"),
    );
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FlickVideoPlayer(
        flickManager: flickManager
      ),
    );
  }
}
```

### Public Classes Summary

| Class                           | Summary                                                                                                                                                                                                                                                                                                                                                                                                                              |
| ------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `FlickVideoPlayer`              | Main entry point, takes a `FlickManager` and a widget `flickVideoWithControls` as one of the arguments.                                                                                                                                                                                                                                                                                                                              |
| `FlickManager`                  | Manages all the video related operations with the help of different managers. <br>`FlickVideoManager` is responsible to maintain life-cycle of a video, change a video and listen to state changes on the video. <br>`FlickControlManager` is responsible to perform action on the video such as play, mute, seek, toggle full-screen etc. <br>`FlickDisplayManager` is responsible to show/hide controls when player state changes. |
| `FlickVideoWithControls`        | A helper widget to render `video_player` using `FlickNativeVideoPlayer` and Custom player controls. To create video player with custom controls you have to use this widget and pass this to `FlickVideoPlayer` in the argument `flickVideoWithControls`. `closedCaptionTextStyle` argument added to style video subtitles.                                                                                                          |
| `FlickPlayToggle`               | A UI helper widget to create play/pause/replay button for the video player. You can either pass your custom play, pause and replay widgets or change settings for the default icons.                                                                                                                                                                                                                                                 |
| `FlickSoundToggle`              | A UI helper widget to create mute/unmute button for the video player. You can either pass your custom mute and unmute widgets or change settings for the default icons.                                                                                                                                                                                                                                                              |
| `FlickFullscreenToggle`         | A UI helper widget to create fullscreen/fullscreen_exit button for the video player. You can either pass your custom fullscreen and fullscreen_exit widgets or change settings for the default icons.                                                                                                                                                                                                                                |
| `FlickVideoProgressBar`         | A UI helper widget to create progress bar for your video player. It takes `FlickProgressBarSettings` as one of the arguments so that user can create a custom progress bar. This is highly customizable, user can almost change all the properties of the progress bar like `height`, `handleRadius`, provide custom `Color` or custom `Paint`.                                                                                      |
| `FlickTotalDuration`            | A text UI helper widget to show total duration of the video.                                                                                                                                                                                                                                                                                                                                                                         |
| `FlickCurrentPosition`          | A text UI helper widget to show current position of the video.                                                                                                                                                                                                                                                                                                                                                                       |
| `FlickLeftDuration`             | A text UI helper widget to show left duration of the video.                                                                                                                                                                                                                                                                                                                                                                          |
| `FlickSetPlayBack`              | A text UI helper widget to change the playback speed of the video.                                                                                                                                                                                                                                                                                                                                                                   |
| `FlickVideoBuffer`              | A UI helper widget to show `CircularProgressIndicator` or your custom widget when the video is buffering.                                                                                                                                                                                                                                                                                                                            |
| `FlickAutoPlayCircularProgress` | A UI helper widget to show circular progress bar with timer to switch to the next video.                                                                                                                                                                                                                                                                                                                                             |
| `FlickSeekVideoAction`          | An Action helper to seek video forward/backward by custom `Duration` on double tap of screen. Takes `child` as one of the arguments to nest other actions or widgets.                                                                                                                                                                                                                                                                |
| `FlickShowControlsAction`       | An Action helper to toggle between show/hide of controls on tap of the screen. Takes `child` as one of the arguments to nest other actions or widgets.                                                                                                                                                                                                                                                                               |
| `FlickTogglePlayAction`         | An action helper to toggle between play/pause on tap of the screen. Takes `child` as one of the arguments to nest other actions or widgets.                                                                                                                                                                                                                                                                                          |
| `FlickToggleSoundAction`        | An action helper to toggle between mute/unmute on tap of the screen. Takes `child` as one of the arguments to nest other actions or widgets.                                                                                                                                                                                                                                                                                         |
| `FlickSubtitleToggle`           | An action helper to toggle between display subtitle/no-subtitle on tap of the screen. Takes `child` as one of the arguments to nest other actions or widgets.                                                                                                                                                                                                                                                                        |

To play a list of videos you have to create your custom `DataManager`, You can find some of the implementations in /example folder.

UI Helper and Action helpers are widgets which interacts with `FlickDisplayManager`, `FlickControlManager` and `FlickVideoManager` you can easily create your custom widgets/actions, [Provider](https://pub.dev/packages/provider) package is used for state management.

### Web

Guideline for web: As we are using `video_player_web` under-hood please follow [video_player_web](https://pub.dev/packages/video_player_web) doc before you start.

#### Default shortcuts

| Key                 | Behavior           |
| ------------------- | ------------------ |
| `f`                 | Toggle full-screen |
| `m`                 | Toggle mute        |
| `ArrowRight`        | Seek forward       |
| `ArrowLeft`         | Seek backward      |
| `(Space character)` | Toggle play        |
| `ArrowUp`           | Increase volume    |
| `ArrowDown`         | Decrease volume    |

- You can pass `webKeyDownHandler` argument to `FlickVideoPlayer` and manage the keyboard shortcuts yourself.

#### Notes

- `Esc` shortcut to exit from full-screen is in development.

### Origin of third party content

Videos

- 9th May & Fireworks - https://mazwai.com/video/9th-May-&amp;-Fireworks/455089
- Iceland | Land of Fire and Ice - https://mazwai.com/video/iceland-%7C-land-of-fire-and-ice/455108
- Rio from Above - https://mazwai.com/video/rio-from-above/455099
- The Valley - https://mazwai.com/video/the-valley/455101

Pictures

- Woman on rock - Photo by [Engin Akyurt](https://www.pexels.com/@enginakyurt?utm_content=attributionCopyText&utm_medium=referral&utm_source=pexels) from [Pexels](https://www.pexels.com/photo/woman-on-rock-formation-holding-a-flag-1493210/?utm_content=attributionCopyText&utm_medium=referral&utm_source=pexels)
- Person waiting - Photo by [Leo Cardelli](https://www.pexels.com/@cardellimedia?utm_content=attributionCopyText&utm_medium=referral&utm_source=pexels) from [Pexels](https://www.pexels.com/photo/photography-of-person-walking-on-road-1236701/?utm_content=attributionCopyText&utm_medium=referral&utm_source=pexels)
- Scenic view of mountain - Photo by [Johannes Rapprich](https://www.pexels.com/@jrapprich?utm_content=attributionCopyText&utm_medium=referral&utm_source=pexels) from [Pexels](https://www.pexels.com/photo/scenic-view-of-mountain-during-daytime-1482927/?utm_content=attributionCopyText&utm_medium=referral&utm_source=pexels)
- Black and white silhouette - Photo by [Athenafrom](https://www.pexels.com/@pedro?utm_content=attributionCopyText&utm_medium=referral&utm_source=pexels) [Pexels](https://www.pexels.com/photo/black-and-white-silhouette-of-christ-the-redeemer-1804177/?utm_content=attributionCopyText&utm_medium=referral&utm_source=pexels)
