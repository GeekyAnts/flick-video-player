import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Show a widget based on the subtitle visivle/invisible state of the player and toggle the same.

class FlickSubtitleToggle extends StatelessWidget {
  const FlickSubtitleToggle({
    Key? key,
    this.activeChild,
    this.inactiveChild,
    this.toggleSubtitleVisibility,
    this.size,
    this.color,
    this.padding,
    this.decoration,
  }) : super(key: key);

  /// Widget shown when the video is not muted.
  ///
  /// Default - Icon(Icons.volume_off)
  final Widget? activeChild;

  /// Widget shown when the video is muted.
  ///
  /// Default - Icon(Icons.volume_up)
  final Widget? inactiveChild;

  /// Function called onTap of visible child.
  ///
  /// Default action -
  /// ``` dart
  ///    controlManager.toggleMute();
  /// ```
  final Function? toggleSubtitleVisibility;

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

    Widget activeWidget = activeChild ??
        Icon(
          Icons.closed_caption,
          size: size,
          color: color,
        );
    Widget inactiveWidget = inactiveChild ??
        Icon(
          Icons.closed_caption_off,
          size: size,
          color: color,
        );
    Widget child = controlManager.isSub ? activeWidget : inactiveWidget;
    if (videoManager.videoPlayerController!.closedCaptionFile != null) {
      return GestureDetector(
          key: key,
          onTap: () {
            if (toggleSubtitleVisibility != null) {
              toggleSubtitleVisibility!();
            } else {
              controlManager.toggleSubtitle();
            }
          },
          child: Container(
            padding: padding,
            decoration: decoration,
            child: child,
          ));
    } else {
      return Container();
    }
  }
}
