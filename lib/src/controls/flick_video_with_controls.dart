import 'package:flutter/material.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

/// Default Video with Controls.
///
/// Returns a Stack with the following arrangement.
///    * [FlickVideoPlayer]
///    * Stack (Wrapped with [Positioned.fill()])
///      * Video Player loading fallback (conditionally rendered if player is not initialized).
///      * Video player error fallback (conditionally rendered if error in initializing the player).
///      * Controls.
class FlickVideoWithControls extends StatefulWidget {
  const FlickVideoWithControls({
    Key key,
    this.controls,
    this.videoFit = BoxFit.cover,
    this.playerLoadingFallback = const Center(
      child: CircularProgressIndicator(),
    ),
    this.playerErrorFallback = const Center(
      child: const Icon(
        Icons.error,
        color: Colors.white,
      ),
    ),
    this.backgroundColor = Colors.black,
    this.iconThemeData = const IconThemeData(
      color: Colors.white,
      size: 20,
    ),
    this.textStyle = const TextStyle(
      color: Colors.white,
      fontSize: 12,
    ),
    this.aspectRatioWhenLoading = 16 / 9,
    this.willVideoPlayerControllerChange = true,
  }) : super(key: key);

  /// Create custom controls or use any of these [FlickPortraitControls], [FlickLandscapeControls]
  final Widget controls;

  /// Conditionally rendered if player is not initialized.
  final Widget playerLoadingFallback;

  /// Conditionally rendered if player is has errors.
  final Widget playerErrorFallback;

  /// Property passed to [FlickVideoPlayer]
  final BoxFit videoFit;
  final Color backgroundColor;

  /// Used in [DefaultTextStyle]
  ///
  /// Use this property if you require to override the text style provided by the default Flick widgets.
  ///
  /// If any text style property is passed to Flick Widget at the time of widget creation, that style wont be overridden.
  final TextStyle textStyle;

  /// Used in [IconTheme]
  ///
  /// Use this property if you require to override the icon style provided by the default Flick widgets.
  ///
  /// If any icon style is passed to Flick Widget at the time of widget creation, that style wont be overridden.
  final IconThemeData iconThemeData;

  /// If [FlickPlayer] has unbounded constraints this aspectRatio is used to take the size on the screen.
  ///
  /// Once the video is initialized, video determines size taken.
  final double aspectRatioWhenLoading;

  /// If false videoPlayerController will not be updated.
  final bool willVideoPlayerControllerChange;

  get videoPlayerController => null;

  @override
  _FlickVideoWithControlsState createState() => _FlickVideoWithControlsState();
}

class _FlickVideoWithControlsState extends State<FlickVideoWithControls> {
  VideoPlayerController _videoPlayerController;

  @override
  void didChangeDependencies() {
    VideoPlayerController newController =
        Provider.of<FlickVideoManager>(context).videoPlayerController;
    if ((widget.willVideoPlayerControllerChange &&
            _videoPlayerController != newController) ||
        _videoPlayerController == null) {
      _videoPlayerController = newController;
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return IconTheme(
      data: widget.iconThemeData,
      child: LayoutBuilder(builder: (context, size) {
        return Container(
          color: widget.backgroundColor,
          child: DefaultTextStyle(
            style: widget.textStyle,
            child: Stack(
              children: <Widget>[
                Center(
                  child: FlickNativeVideoPlayer(
                    videoPlayerController: _videoPlayerController,
                    fit: widget.videoFit,
                    aspectRatioWhenLoading: widget.aspectRatioWhenLoading,
                  ),
                ),
                Positioned.fill(
                  child: Stack(
                    children: <Widget>[
                      if (_videoPlayerController?.value?.hasError == false &&
                          _videoPlayerController?.value?.isInitialized == false)
                        widget.playerLoadingFallback,
                      if (_videoPlayerController?.value?.hasError == true)
                        widget.playerErrorFallback,
                      widget.controls ?? Container(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
