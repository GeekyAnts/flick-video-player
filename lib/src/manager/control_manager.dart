part of flick_manager;

/// Manages action on video player like play, mute and others.
///
/// FlickControlManager helps user interact with the player,
/// like change play state, change volume, seek video, enter/exit full-screen.
class FlickControlManager extends ChangeNotifier {
  FlickControlManager({
    required FlickManager flickManager,
  }) : _flickManager = flickManager;

  final FlickManager _flickManager;
  bool _mounted = true;

  bool _isMute = false;
  bool _isSub = false;
  bool _isFullscreen = false;
  bool _isAutoPause = false;
  double? _volume;

  /// Is player in full-screen.
  bool get isFullscreen => _isFullscreen;

  /// Is player mute.
  bool get isMute => _isMute;

  /// Is subtitle visible.
  bool get isSub => _isSub;

  VideoPlayerController? get _videoPlayerController =>
      _flickManager.flickVideoManager!.videoPlayerController;
  bool get _isPlaying => _flickManager.flickVideoManager!.isPlaying;

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
    if (_isMute && _videoPlayerController!.value.volume != 0) {
      _videoPlayerController!.setVolume(0);
    }

    await _videoPlayerController!.play();
    _flickManager.flickDisplayManager!.handleShowPlayerControls();
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
    _flickManager.flickDisplayManager!
        .handleShowPlayerControls(showWithTimeout: false);
    _notify();
  }

  /// Use this to programmatically pause the video.
  ///
  /// Example - on visibility change.
  Future<void> autoPause() async {
    _isAutoPause = true;
    await _videoPlayerController!.pause();
  }

  /// Seek video to a duration.
  Future<void> seekTo(Duration moment) async {
    await _videoPlayerController!.seekTo(moment);
  }

  /// Seek video forward by the duration.
  Future<void> seekForward(Duration videoSeekDuration) async {
    _flickManager._handleVideoSeek(forward: true);
    await seekTo(_videoPlayerController!.value.position + videoSeekDuration);
  }

  /// Seek video backward by the duration.
  Future<void> seekBackward(Duration videoSeekDuration) async {
    _flickManager._handleVideoSeek(forward: false);
    await seekTo(
      _videoPlayerController!.value.position - videoSeekDuration,
    );
  }

  /// Mute the video.
  Future<void> mute() async {
    _isMute = true;
    await setVolume(0, isMute: true);
  }

  /// Un-mute the video.
  Future<void> unmute() async {
    _isMute = false;
    await setVolume(_volume ?? 1);
  }

  /// Toggle mute.
  Future<void> toggleMute() async {
    _isMute ? unmute() : mute();
  }

  /// hide the subtitle.
  Future<void> hideSubtitle() async {
    _isSub = false;
    _notify();
  }

  /// show the subtitle.
  Future<void> showSubtitle() async {
    _isSub = true;
    _notify();
  }

  /// Toggle subtitle.
  Future<void> toggleSubtitle() async {
    _isSub ? hideSubtitle() : showSubtitle();
  }

  /// Set volume between 0.0 - 1.0,
  /// 0.0 being mute and 1.0 full volume.
  Future<void> setVolume(double volume, {bool isMute = false}) async {
    await _videoPlayerController?.setVolume(volume);
    if (!isMute) {
      _volume = volume;
    }
    _notify();
  }

  /// Sets the playback speed of [this].
  ///
  /// [speed] indicates a speed value with different platforms accepting
  /// different ranges for speed values. The [speed] must be greater than 0.
  ///
  /// The values will be handled as follows:
  /// * On web, the audio will be muted at some speed when the browser
  ///   determines that the sound would not be useful anymore. For example,
  ///   "Gecko mutes the sound outside the range `0.25` to `5.0`" (see https://developer.mozilla.org/en-US/docs/Web/API/HTMLMediaElement/playbackRate).
  /// * On Android, some very extreme speeds will not be played back accurately.
  ///   Instead, your video will still be played back, but the speed will be
  ///   clamped by ExoPlayer (but the values are allowed by the player, like on
  ///   web).
  /// * On iOS, you can sometimes not go above `2.0` playback speed on a video.
  ///   An error will be thrown for if the option is unsupported. It is also
  ///   possible that your specific video cannot be slowed down, in which case
  ///   the plugin also reports errors.
  Future<void> setPlaybackSpeed(double speed) async {
    await _videoPlayerController!.setPlaybackSpeed(speed);
    notifyListeners();
  }

  /// Increase volume between 0.0 - 1.0,
  /// 0.0 being mute and 1.0 full volume.
  Future<void> increaseVolume(double increaseBy) async {
    final currentVolume = _videoPlayerController?.value.volume ?? 0;
    final volumeAfterIncrease = currentVolume + increaseBy;
    final volume = _verifyVolumeBounds(volumeAfterIncrease);
    await setVolume(volume);
    _flickManager._handleVolumeChange(volume: volume);
  }

  /// Decrease volume between 0.0 - 1.0,
  /// 0.0 being mute and 1.0 full volume.
  Future<void> decreaseVolume(double decreaseBy) async {
    final currentVolume = _videoPlayerController?.value.volume ?? 0;
    final volumeAfterDecrease = currentVolume - decreaseBy;
    final volume = _verifyVolumeBounds(volumeAfterDecrease);
    await setVolume(volume);
    _flickManager._handleVolumeChange(volume: volume);
  }

  double _verifyVolumeBounds(double volume) {
    var boundedVolume;
    if (volume > 1) {
      boundedVolume = 1;
    } else if (volume < 0) {
      boundedVolume = 0;
    } else {
      boundedVolume = double.parse(volume.toStringAsFixed(2));
    }

    if (boundedVolume == 0) {
      _isMute = true;
    } else {
      _isMute = false;
    }

    return boundedVolume;
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
