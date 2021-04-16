import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Show a widget based on the full-screen state of the player and toggle the same.
class FlickFullScreenToggle extends StatelessWidget {
  const FlickFullScreenToggle(
      {Key? key,
      this.enterFullScreenChild,
      this.exitFullScreenChild,
      this.toggleFullscreen,
      this.size,
      this.color,
      this.padding,
      this.decoration})
      : super(key: key);

  /// Widget shown when player is not in full-screen.
  ///
  /// Default - [Icon(Icons.fullscreen)]
  final Widget? enterFullScreenChild;

  /// Widget shown when player is in full-screen.
  ///
  ///  Default - [Icon(Icons.fullscreen_exit)]
  final Widget? exitFullScreenChild;

  /// Function called onTap of the visible child.
  ///
  /// Default action -
  /// ```dart
  ///     controlManager.toggleFullscreen();
  /// ```
  final Function? toggleFullscreen;

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
    Widget enterFullScreenWidget = enterFullScreenChild ??
        Icon(
          Icons.fullscreen,
          size: size,
          color: color,
        );
    Widget exitFullScreenWidget = exitFullScreenChild ??
        Icon(
          Icons.fullscreen_exit,
          size: size,
          color: color,
        );

    Widget child = controlManager.isFullscreen
        ? exitFullScreenWidget
        : enterFullScreenWidget;

    return GestureDetector(
      key: key,
      onTap: () {
        if (toggleFullscreen != null) {
          toggleFullscreen!();
        } else {
          controlManager.toggleFullscreen();
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
