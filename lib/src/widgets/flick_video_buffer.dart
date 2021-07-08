import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Shows a widget when the video is buffering (and video is playing).
class FlickVideoBuffer extends StatelessWidget {
  const FlickVideoBuffer({
    Key? key,
    this.bufferingChild = const CircularProgressIndicator(),
    this.child,
  }) : super(key: key);

  /// Widget to be shown when the video is buffering.
  final Widget bufferingChild;

  /// Widget to be shown when the video is not buffering.
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    FlickVideoManager videoManager = Provider.of<FlickVideoManager>(context);

    return Container(
      child: (videoManager.isBuffering && videoManager.isPlaying)
          ? bufferingChild
          : child,
    );
  }
}
