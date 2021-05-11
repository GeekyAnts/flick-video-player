import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Circular progress bar which uses autoPlayNextVideo timeout duration.
class FlickAutoPlayCircularProgress extends StatefulWidget {
  const FlickAutoPlayCircularProgress({
    Key? key,
    this.colors,
    this.width = 50,
    this.height = 50,
    this.playChild = const Icon(
      Icons.play_arrow,
    ),
    this.cancelChild = const Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        'Cancel',
      ),
    ),
    this.playNextVideo,
    this.cancelAutoPlayTimer,
  }) : super(key: key);

  /// Colors for progress indicator.
  final FlickAutoPlayTimerProgressColors? colors;

  /// Width of the progress indicator.
  final double width;

  /// Height of the progress indicator.
  final double height;

  /// Widget shown in the center of progress indicator.
  ///
  /// Default action - [flickVideoManager.cancelAutoPlayTimer] is called with [playNext] set to true and next video starts playing immediately.
  final Widget playChild;

  /// Widget shown after progress indicator.
  ///
  /// Default action - [flickVideoManager.cancelAutoPlayTimer] is called with [playNext] set to false.
  final Widget cancelChild;

  /// Called on tap of [playChild].
  ///
  /// If this function is not null, then default onTap action of [playChild] is not called.
  final Function? playNextVideo;

  /// Called on tap of [cancelChild].
  ///
  /// If this function is not null, then default onTap action of [cancelChild] is not called.
  final Function? cancelAutoPlayTimer;

  @override
  _FlickAutoPlayCircularProgressState createState() =>
      _FlickAutoPlayCircularProgressState();
}

class _FlickAutoPlayCircularProgressState
    extends State<FlickAutoPlayCircularProgress> with TickerProviderStateMixin {
  AnimationController? controller;
  FlickVideoManager? _videoManager;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_videoManager == null) {
      _videoManager = Provider.of<FlickVideoManager>(context);
      controller = AnimationController(
          vsync: this, duration: _videoManager!.nextVideoAutoPlayDuration);
      controller!.forward();
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: controller!,
        builder: (context, child) {
          return Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: widget.width,
                  height: widget.height,
                  child: CustomPaint(
                    painter: FlickAutoPlayTimerProgressPainter(
                      animation: controller,
                      colors: widget.colors,
                    ),
                    child: Container(
                      child: GestureDetector(
                        onTap: () {
                          if (widget.playNextVideo != null) {
                            widget.playNextVideo!();
                          } else {
                            _videoManager!
                                .cancelVideoAutoPlayTimer(playNext: true);
                          }
                        },
                        child: widget.playChild,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (widget.cancelAutoPlayTimer != null) {
                      widget.cancelAutoPlayTimer!();
                    } else {
                      _videoManager!.cancelVideoAutoPlayTimer();
                    }
                  },
                  child: widget.cancelChild,
                ),
              ],
            ),
          );
        });
  }
}
