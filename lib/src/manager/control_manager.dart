part of flick_manager;

/// Manages action on video player like play, mute and others.
///
/// FlickControlManager helps user interact with the player,
/// like change play state, change volume, seek video, enter/exit full-screen.
class FlickControlManager extends ChangeNotifier {
  FlickControlManager({
    @required FlickManager flickManager,
  }) : _flickManager = flickManager;

  final FlickManager _flickManager;
  bool _mounted = true;

  bool _isMute = false;
  bool _isFullscreen = false;
  bool _isAutoPause = false;

  /// Is player in full-screen.
  bool get isFullscreen => _isFullscreen;

  /// Is player mute.
  bool get isMute => _isMute;

  VideoPlayerController get _videoPlayerController =>
      _flickManager.flickVideoManager.videoPlayerController;
  bool get _isPlaying => _flickManager.flickVideoManager.isPlaying;

  /// Enter full-screen.
  void enterFullscreen() {
    _isFullscreen = true;
    _flickManager._handleToggleFullscreen();
    _notify();
  }

  /// Exit full-screen.
  void exitFullscreen() {
    _isFullscreen = false;
    _flickManager._handleToggleFullscreen();
    _notify();
  }

  /// Toggle full-screen.
  void toggleFullscreen() {
    if (_isFullscreen) {
      exitFullscreen();
    } else {
      enterFullscreen();
    }
  }

  /// Toggle play.
  void togglePlay() {
    _isPlaying ? pause() : play();
  }

  /// Replay the current playing video from beginning.
  void replay() {
    seekTo(Duration(minutes: 0));
    play();
  }

  /// Play the video.
  Future<void> play() async {
    _isAutoPause = false;

    // When video changes, the new video has to be muted.
    if (_isMute && _videoPlayerController.value.volume != 0) {
      _videoPlayerController.setVolume(0);
    }

    await _videoPlayerController.play();
    _flickManager.flickDisplayManager.handleShowPlayerControls();
    _notify();
  }

  /// Auto-resume video.
  ///
  /// Use to resume video after a programmatic pause ([autoPause()]).
  Future<void> autoResume() async {
    if (_isAutoPause == true) {
      _isAutoPause = false;
      await _videoPlayerController?.play();
    }
  }

  /// Pause the video.
  Future<void> pause() async {
    await _videoPlayerController?.pause();
    _flickManager.flickDisplayManager
        .handleShowPlayerControls(showWithTimeout: false);
    _notify();
  }

  /// Use this to programmatically pause the video.
  ///
  /// Example - on visibility change.
  Future<void> autoPause() async {
    _isAutoPause = true;
    await _videoPlayerController.pause();
  }

  /// Seek video to a duration.
  Future<void> seekTo(Duration moment) async {
    await _videoPlayerController.seekTo(moment);
  }

  /// Seek video forward by the duration.
  Future<void> seekForward(Duration videoSeekDuration) async {
    _flickManager._handleVideoSeek(forward: true);
    await seekTo(_videoPlayerController.value.position + videoSeekDuration);
  }

  /// Seek video backward by the duration.
  Future<void> seekBackward(Duration videoSeekDuration) async {
    _flickManager._handleVideoSeek(forward: false);
    await seekTo(
      _videoPlayerController.value.position - videoSeekDuration,
    );
  }

  /// Mute the video.
  Future<void> mute() async {
    _isMute = true;
    await setVolume(0);
  }

  /// Un-mute the video.
  Future<void> unmute() async {
    _isMute = false;
    await setVolume(1);
  }

  /// Toggle mute.
  Future<void> toggleMute() async {
    _isMute ? unmute() : mute();
  }

  /// Set volume between 0.0 - 1.0,
  /// 0.0 being mute and 1.0 full volume.
  Future<void> setVolume(double volume) async {
    await _videoPlayerController?.setVolume(volume);
    _notify();
  }

  _notify() {
    if (_mounted) {
      notifyListeners();
    }
  }

  dispose() {
    _mounted = false;
    super.dispose();
  }
}
