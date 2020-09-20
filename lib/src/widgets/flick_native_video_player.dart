import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';

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
  final CachedVideoPlayerController videoPlayerController;

  @override
  Widget build(BuildContext context) {
    CachedVideoPlayer videoPlayer = CachedVideoPlayer(videoPlayerController);

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
