import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// AutoHide child according to timeout managed by [FlickDisplayManager].
///
/// Hides the child with [FadeAnimation].
class FlickAutoHideChild extends StatelessWidget {
  const FlickAutoHideChild({
    Key? key,
    required this.child,
    this.autoHide = true,
    this.showIfVideoNotInitialized = true,
  }) : super(key: key);
  final Widget child;
  final bool autoHide;

  /// Show the child if video is not initialized.
  final bool showIfVideoNotInitialized;

  @override
  Widget build(BuildContext context) {
    FlickDisplayManager displayManager =
        Provider.of<FlickDisplayManager>(context);
    FlickVideoManager videoManager = Provider.of<FlickVideoManager>(context);

    return (!videoManager.isVideoInitialized && !showIfVideoNotInitialized)
        ? Container()
        : autoHide
            ? AnimatedSwitcher(
                duration: Duration(milliseconds: 300),
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
                child:
                    (displayManager.showPlayerControls) ? child : Container(),
              )
            : child;
  }
}
