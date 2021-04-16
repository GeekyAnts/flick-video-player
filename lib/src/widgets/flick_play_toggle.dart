import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Show a widget based on play/pause state of the player and toggle the same.
class FlickPlayToggle extends StatelessWidget {
  const FlickPlayToggle({
    Key? key,
    this.playChild,
    this.pauseChild,
    this.replayChild,
    this.togglePlay,
    this.color,
    this.size,
    this.padding,
    this.decoration,
  }) : super(key: key);

  /// Widget shown when the video is paused.
  ///
  /// Default - Icon(Icons.play_arrow)
  final Widget? playChild;

  /// Widget shown when the video is playing.
  ///
  /// Default - Icon(Icons.pause)
  final Widget? pauseChild;

  /// Widget shown when the video is ended.
  ///
  /// Default - Icon(Icons.replay)
  final Widget? replayChild;

  /// Function called onTap of visible child.
  ///
  /// Default action -
  /// ``` dart
  ///     videoManager.isVideoEnded
  ///     ? controlManager.replay()
  ///     : controlManager.togglePlay();
  /// ```
  final Function? togglePlay;

  /// Size for the default icons.
  final double? size;

  /// Color for the default icons.
  final Color? color;

  /// Padding around the visible child.
  final EdgeInsetsGeometry? padding;

  /// Decoration around the visible child.
  final Decoration? decoration;

  @override
  Widget build(BuildContext context) {
    FlickControlManager controlManager =
        Provider.of<FlickControlManager>(context);
    FlickVideoManager videoManager = Provider.of<FlickVideoManager>(context);

    Widget playWidget = playChild ??
        Icon(
          Icons.play_arrow,
          size: size,
          color: color,
        );
    Widget pauseWidget = pauseChild ??
        Icon(
          Icons.pause,
          size: size,
          color: color,
        );
    Widget replayWidget = replayChild ??
        Icon(
          Icons.replay,
          size: size,
          color: color,
        );

    Widget child = videoManager.isVideoEnded
        ? replayWidget
        : videoManager.isPlaying
            ? pauseWidget
            : playWidget;

    return GestureDetector(
        key: key,
        onTap: () {
          if (togglePlay != null) {
            togglePlay!();
          } else {
            videoManager.isVideoEnded
                ? controlManager.replay()
                : controlManager.togglePlay();
          }
        },
        child: Container(
          padding: padding,
          decoration: decoration,
          child: child,
        ));
  }
}
