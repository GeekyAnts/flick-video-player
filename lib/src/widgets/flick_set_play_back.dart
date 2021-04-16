import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Show a widget based on the full-screen state of the player and toggle the same.
class FlickSetPlayBack extends StatelessWidget {
  const FlickSetPlayBack(
      {Key? key,
      this.playBackChild,
      this.setPlayBack,
      this.speed = 1.0,
      this.size,
      this.color,
      this.padding,
      this.decoration})
      : super(key: key);

  /// Widget shown when player is not in full-screen.
  ///
  /// Default - [Icon(Icons.fullscreen)]
  final Widget? playBackChild;

  /// Function called onTap of the visible child.
  ///
  /// Default action -
  /// ```dart
  ///     controlManager.toggleFullscreen();
  /// ```
  final Function? setPlayBack;

  /// Speed value of 2.0, your video will play at 2x the regular playback speed and so on.
  final double speed;

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
    Widget playBackWidget = playBackChild ??
        Icon(
          Icons.play_circle_outline_sharp,
          size: size,
          color: color,
        );

    Widget child = playBackWidget;

    return GestureDetector(
      key: key,
      onTap: () {
        if (setPlayBack != null) {
          setPlayBack!();
        } else {
          if (speed != 1.0) controlManager.setPlaybackSpeed(speed);
        }
      },
      child: Container(
        padding: padding,
        decoration: decoration,
        child: child,
      ),
    );
  }
}
