part of flick_manager;

typedef Duration GetPlayerControlsTimeout({
  bool errorInVideo,
  bool isVideoInitialized,
  bool isPlaying,
  bool isVideoEnded,
});

GetPlayerControlsTimeout getPlayerControlsTimeoutDefault = ({
  bool errorInVideo,
  bool isVideoInitialized,
  bool isPlaying,
  bool isVideoEnded,
}) {
  Duration duration;

  if (errorInVideo || !isVideoInitialized || !isPlaying || isVideoEnded) {
    duration = Duration(days: 365);
  } else {
    duration = Duration(seconds: 3);
  }

  return duration;
};
