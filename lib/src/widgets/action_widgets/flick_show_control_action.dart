import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// GestureDetector that calls [flickDisplayManager.handleVideoTap] onTap of opaque area/child.
class FlickShowControlsAction extends StatelessWidget {
  const FlickShowControlsAction(
      {Key? key,
      this.child,
      this.behavior = HitTestBehavior.opaque,
      this.handleVideoTap})
      : super(key: key);

  final Widget? child;
  final HitTestBehavior behavior;

  /// Function called onTap of the opaque area/child.
  ///
  /// Default action -
  /// ``` dart
  ///    displayManager.handleVideoTap();
  /// ```
  final Function? handleVideoTap;

  @override
  Widget build(BuildContext context) {
    FlickDisplayManager displayManager =
        Provider.of<FlickDisplayManager>(context);
    return Container(
      child: GestureDetector(
        key: key,
        child: child,
        behavior: behavior,
        onTap: () {
          if (handleVideoTap != null) {
            handleVideoTap!();
          } else {
            displayManager.handleVideoTap();
          }
        },
      ),
    );
  }
}
