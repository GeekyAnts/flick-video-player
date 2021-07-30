import 'package:flick_video_player/src/manager/flick_manager.dart';
import 'package:universal_html/html.dart';

void flickDefaultWebKeyDownHandler(
    KeyboardEvent event, FlickManager flickManager) {
  if (event.keyCode == 70) {
    flickManager.flickControlManager?.toggleFullscreen();
    flickManager.flickDisplayManager?.handleShowPlayerControls();
  } else if (event.keyCode == 77) {
    flickManager.flickControlManager?.toggleMute();
    flickManager.flickDisplayManager?.handleShowPlayerControls();
  } else if (event.keyCode == 39) {
    flickManager.flickControlManager?.seekForward(Duration(seconds: 10));
    flickManager.flickDisplayManager?.handleShowPlayerControls();
  } else if (event.keyCode == 37) {
    flickManager.flickControlManager?.seekBackward(Duration(seconds: 10));
    flickManager.flickDisplayManager?.handleShowPlayerControls();
  } else if (event.keyCode == 32) {
    flickManager.flickControlManager?.togglePlay();
    flickManager.flickDisplayManager?.handleShowPlayerControls();
  } else if (event.keyCode == 38) {
    flickManager.flickControlManager?.increaseVolume(0.05);
    flickManager.flickDisplayManager?.handleShowPlayerControls();
  } else if (event.keyCode == 40) {
    flickManager.flickControlManager?.decreaseVolume(0.05);
    flickManager.flickDisplayManager?.handleShowPlayerControls();
  }
}
