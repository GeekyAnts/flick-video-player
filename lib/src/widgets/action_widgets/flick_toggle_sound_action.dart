import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// GestureDetector that calls [flickControlManager.toggleMute] onTap of opaque area/child.
class FlickToggleSoundAction extends StatelessWidget {
  const FlickToggleSoundAction(
      {Key? key,
      this.child,
      this.behavior = HitTestBehavior.opaque,
      this.toggleMute})
      : super(key: key);
  final Widget? child;
  final HitTestBehavior behavior;

  /// Function called onTap of the opaque area/child.
  ///
  /// Default action -
  /// ``` dart
  ///    controlManager.toggleMute();
  /// ```
  final Function? toggleMute;

  @override
  Widget build(BuildContext context) {
    FlickControlManager controlManager =
        Provider.of<FlickControlManager>(context);
    return Container(
      child: GestureDetector(
        key: key,
        child: child,
        behavior: behavior,
        onTap: () {
          if (toggleMute != null) {
            toggleMute!();
          } else {
            controlManager.toggleMute();
          }
        },
      ),
    );
  }
}
