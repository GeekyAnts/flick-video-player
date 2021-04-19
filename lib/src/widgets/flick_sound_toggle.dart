import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Show a widget based on the mute/unmute state of the player and toggle the same.
class FlickSoundToggle extends StatelessWidget {
  const FlickSoundToggle({
    Key? key,
    this.muteChild,
    this.unmuteChild,
    this.toggleMute,
    this.size,
    this.color,
    this.padding,
    this.decoration,
  }) : super(key: key);

  /// Widget shown when the video is not muted.
  ///
  /// Default - Icon(Icons.volume_off)
  final Widget? muteChild;

  /// Widget shown when the video is muted.
  ///
  /// Default - Icon(Icons.volume_up)
  final Widget? unmuteChild;

  /// Function called onTap of visible child.
  ///
  /// Default action -
  /// ``` dart
  ///    controlManager.toggleMute();
  /// ```
  final Function? toggleMute;

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

    Widget muteWidget = muteChild ??
        Icon(
          Icons.volume_off,
          size: size,
          color: color,
        );
    Widget unmuteWidget = unmuteChild ??
        Icon(
          Icons.volume_up,
          size: size,
          color: color,
        );

    Widget child = controlManager.isMute ? muteWidget : unmuteWidget;

    return GestureDetector(
        key: key,
        onTap: () {
          if (toggleMute != null) {
            toggleMute!();
          } else {
            controlManager.toggleMute();
          }
        },
        child: Container(
          padding: padding,
          decoration: decoration,
          child: child,
        ));
  }
}
