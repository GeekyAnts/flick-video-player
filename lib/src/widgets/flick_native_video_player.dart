import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// Renders [VideoPlayer] with [BoxFit] configurations.
class FlickNativeVideoPlayer extends StatelessWidget {
  const FlickNativeVideoPlayer({
    Key key,
    this.fit,
    this.aspectRatioWhenLoading,
    @required this.videoPlayerController,
  }) : super(key: key);

  final BoxFit fit;
  final double aspectRatioWhenLoading;
  final VideoPlayerController videoPlayerController;

  @override
  Widget build(BuildContext context) {
    VideoPlayer videoPlayer = VideoPlayer(videoPlayerController);

    double videoHeight = videoPlayerController?.value?.size?.height;
    double videoWidth = videoPlayerController?.value?.size?.width;

    return LayoutBuilder(
      builder: (context, size) {
        double aspectRatio = (size.maxHeight == double.infinity ||
                size.maxWidth == double.infinity)
            ? videoPlayerController?.value?.initialized == true
                ? videoPlayerController?.value?.aspectRatio
                : aspectRatioWhenLoading
            : size.maxWidth / size.maxHeight;

        return AspectRatio(
          aspectRatio: aspectRatio,
          child: FittedBox(
            fit: fit,
            child: videoPlayerController?.value?.initialized == true
                ? Container(
                    height: videoHeight,
                    width: videoWidth,
                    child: videoPlayer,
                  )
                : Container(),
          ),
        );
      },
    );
  }
}
