import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// GestureDetector that calls [flickDisplayManager.togglePlay] onTap of opaque area/child.
class FlickTogglePlayAction extends StatelessWidget {
  const FlickTogglePlayAction(
      {Key? key,
      this.child,
      this.behavior = HitTestBehavior.opaque,
      this.togglePlay})
      : super(key: key);
  final Widget? child;
  final HitTestBehavior behavior;

  /// Function called onTap of the opaque area/child.
  ///
  /// Default action -
  /// ``` dart
  ///    displayManager.togglePlay();
  /// ```
  final Function? togglePlay;

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
          if (togglePlay != null) {
            togglePlay!();
          } else {
            controlManager.togglePlay();
          }
        },
      ),
    );
  }
}
