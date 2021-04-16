import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// GestureDetector's that calls [flickControlManager.seekForward]/[flickControlManager.seekBackward] onTap of opaque area/child.
///
/// Renders two GestureDetector inside a row, the first detector is responsible to seekBackward and the second detector is responsible to seekForward.
class FlickSeekVideoAction extends StatelessWidget {
  const FlickSeekVideoAction({
    Key? key,
    this.child,
    this.forwardSeekIcon = const Icon(Icons.fast_forward),
    this.backwardSeekIcon = const Icon(Icons.fast_rewind),
    this.duration = const Duration(seconds: 10),
    this.seekForward,
    this.seekBackward,
  }) : super(key: key);

  /// Widget to be stacked above this action.
  final Widget? child;

  /// Widget to be shown when user forwardSeek the video.
  ///
  /// This widget is shown for a duration managed by [FlickDisplayManager].
  final Widget forwardSeekIcon;

  /// Widget to be shown when user backwardSeek the video.
  ///
  /// This widget is shown for a duration managed by [FlickDisplayManager].
  final Widget backwardSeekIcon;

  /// Function called onTap of [forwardSeekIcon].
  ///
  /// Default action -
  /// ``` dart
  ///    controlManager.seekForward(Duration(seconds: 10));
  /// ```
  final Function? seekForward;

  /// Function called onTap of [backwardSeekIcon].
  ///
  /// Default action -
  /// ``` dart
  ///     controlManager.seekBackward(Duration(seconds: 10));
  /// ```
  final Function? seekBackward;

  /// Duration by which video will be seek.
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    FlickDisplayManager displayManager =
        Provider.of<FlickDisplayManager>(context);
    FlickControlManager controlManager =
        Provider.of<FlickControlManager>(context);

    bool showForwardSeek = displayManager.showForwardSeek;
    bool showBackwardSeek = displayManager.showBackwardSeek;

    return Stack(children: <Widget>[
      Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onDoubleTap: () {
                if (seekBackward != null) {
                  seekBackward!();
                } else {
                  controlManager.seekBackward(duration);
                }
              },
              child: Align(
                alignment: Alignment.center,
                child: AnimatedCrossFade(
                  duration: Duration(milliseconds: 100),
                  firstChild: IconTheme(
                    data: IconThemeData(color: Colors.transparent),
                    child: backwardSeekIcon,
                  ),
                  crossFadeState: showBackwardSeek
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  secondChild: IconTheme(
                    data: IconThemeData(color: Colors.white),
                    child: backwardSeekIcon,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onDoubleTap: () {
                if (seekForward != null) {
                  seekForward!();
                } else {
                  controlManager.seekForward(duration);
                }
              },
              child: Align(
                alignment: Alignment.center,
                child: AnimatedCrossFade(
                  duration: Duration(milliseconds: 100),
                  firstChild: IconTheme(
                      data: IconThemeData(
                        color: Colors.transparent,
                      ),
                      child: forwardSeekIcon),
                  crossFadeState: showForwardSeek
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  secondChild: IconTheme(
                    data: IconThemeData(color: Colors.white),
                    child: forwardSeekIcon,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      if (child != null) SizedBox(child: child),
    ]);
  }
}
