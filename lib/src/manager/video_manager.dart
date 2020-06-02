part of flick_manager;

typedef TimerCancelCallback(bool playNext);

/// Manages [VideoPlayerController].
///
/// Responsible to maintain life-cycle of [VideoPlayerController].
class FlickVideoManager extends ChangeNotifier {
  FlickVideoManager(
      {@required FlickManager flickManager,
      @required this.autoPlay,
      @required this.autoInitialize})
      : _flickManager = flickManager;

  final FlickManager _flickManager;
  bool _currentVideoEnded = false;
  bool _isBuffering = false;
  Timer _nextVideoAutoPlayTimer;
  TimerCancelCallback _timerCancelCallback;
  Duration _nextVideoAutoPlayDuration;
  Function _videoChangeCallback;
  VideoPlayerValue _videoPlayerValue;
  VideoPlayerController _videoPlayerController;
  bool _mounted = true;

  /// Auto-play the video after initialization.
  final bool autoPlay;

  final bool autoInitialize;

  /// Is current playing video ended.
  bool get isVideoEnded => _currentVideoEnded;

  /// Is video buffering.
  bool get isBuffering => _isBuffering;

  /// Next video auto-play timer.
  ///
  /// When a video is changed with a duration, this timer is responsible to switch the video after the duration.

  Timer get nextVideoAutoPlayTimer => _nextVideoAutoPlayTimer;

  /// Next video auto-play duration.
  ///
  ///  Use this duration to show next video auto-play progress indicators.
  ///
  /// This is the duration passed by the user in [flickManager.handleChangeVideo]
  Duration get nextVideoAutoPlayDuration => _nextVideoAutoPlayDuration;

  /// [videoPlayerController.value]
  VideoPlayerValue get videoPlayerValue => _videoPlayerValue;

  /// Current playing video controller.
  VideoPlayerController get videoPlayerController => _videoPlayerController;

  /// Error in initializing video.
  bool get errorInVideo => videoPlayerController?.value?.hasError ?? false;

  /// Is current video initialized.
  bool get isVideoInitialized =>
      videoPlayerController?.value?.initialized ?? false;
  bool get isPlaying => videoPlayerController?.value?.isPlaying ?? false;

  /// Cancel the current auto player timer with option of playing the next video directly.
  cancelVideoAutoPlayTimer({bool playNext = false}) {
    playNext = playNext ?? false;
    _nextVideoAutoPlayTimer?.cancel();
    _nextVideoAutoPlayTimer = null;
    _nextVideoAutoPlayDuration = null;

    if (_timerCancelCallback != null) {
      _timerCancelCallback(playNext);
      _timerCancelCallback = null;
    }

    if (playNext && _videoChangeCallback != null) {
      // _videoChangeCallback is set when handleChangeVideo is called with videoChangeDuration.
      _videoChangeCallback();
    }
    _videoChangeCallback = null;
    _notify();
  }

  _handleChangeVideo(VideoPlayerController newController,
      {Duration videoChangeDuration,
      TimerCancelCallback timerCancelCallback}) async {
    // If videoChangeDuration is not null, start the autoPlayTimer.
    if (videoChangeDuration != null) {
      _timerCancelCallback = timerCancelCallback;
      _videoChangeCallback = () {
        _changeVideo(newController);
        _nextVideoAutoPlayTimer = null;
        _nextVideoAutoPlayDuration = null;
        _videoChangeCallback = null;
      };

      _nextVideoAutoPlayDuration = videoChangeDuration;

      _nextVideoAutoPlayTimer =
          Timer(videoChangeDuration, _videoChangeCallback);
      _notify();
    } else {
      // If videoChangeDuration is null, directly change the video.
      _changeVideo(newController);
    }
  }

  // Immediately change the video.
  _changeVideo(VideoPlayerController newController) async {
    //  Change the videoPlayerController with the new controller,
    // notify the controller change and remove listeners from the old controller.
    VideoPlayerController oldController = videoPlayerController;
    _flickManager.flickControlManager.pause();
    _videoPlayerController = newController;
    oldController?.removeListener(_videoListener);
    videoPlayerController.addListener(_videoListener);
    // Video listener is called once video starts playing,
    // to reset the player UI immediately videoPlayerValue has to be changed here.
    _videoPlayerValue = videoPlayerController.value;
    _currentVideoEnded = false;
    _notify();

    // Dispose the old controller after 5 seconds.
    Future.delayed(Duration(seconds: 5), () => oldController?.dispose());

    // If movie already ended, restart the movie (Happens when previously used controller is
    // used again).
    if (videoPlayerController.value.position ==
        videoPlayerController.value.duration) {
      videoPlayerController
          .seekTo(Duration(hours: 0, minutes: 0, seconds: 0, milliseconds: 0));
    }

    // Initialize the video if not initialized
    // (User can initialize the video while passing to flick).
    if (!videoPlayerController.value.initialized && autoInitialize) {
      try {
        await videoPlayerController.initialize();
      } catch (err) {
        _flickManager._handleErrorInVideo();
      }
    }

    if (autoPlay && ModalRoute.of(_flickManager._context).isCurrent) {
      // Start playing the video.
      _flickManager.flickControlManager.play();
    }

    _notify();
  }

  // Listener for video change.
  _videoListener() {
    _videoPlayerValue = videoPlayerController.value;

    // If video position has reached the end, take action for videoEnd.
    if (videoPlayerValue != null &&
        videoPlayerValue.position != null &&
        videoPlayerValue?.duration != null &&
        (videoPlayerValue.position) >= (videoPlayerValue?.duration)) {
      if (!_currentVideoEnded) {
        handleVideoEnd();
      }
    } else {
      // Cancel the video end timer if running while user starts seeing the video again.
      _currentVideoEnded = false;
      if (_nextVideoAutoPlayTimer != null) {
        cancelVideoAutoPlayTimer();
        // Due to some bug in video player, have to play the video again after
        // video is seek or replayed once ended.
        _flickManager.flickControlManager.play();
      }
    }

    // Mark video is buffering if video has not ended, has no error,
    // and position is equal to buffered duration.
    _isBuffering = !isVideoEnded &&
        !videoPlayerValue.hasError &&
        videoPlayerController.value?.buffered?.isNotEmpty == true &&
        videoPlayerController.value.position.inSeconds >=
            videoPlayerController.value?.buffered[0]?.end?.inSeconds;

    _notify();
  }

  // Video-end handler.
  // Called when the current playing video is ended.
  handleVideoEnd() {
    _currentVideoEnded = true;
    _flickManager._handleVideoEnd();
  }

  _notify() {
    if (_mounted) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _mounted = false;
    _videoPlayerController?.pause();
    _videoPlayerController?.removeListener(_videoListener);
    _videoPlayerController?.dispose();

    super.dispose();
  }
}
