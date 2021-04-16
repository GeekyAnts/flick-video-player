import 'package:example/animation_player/data_manager.dart';
import 'package:flutter/material.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:provider/provider.dart';

class AnimationPlayerLandscapeControls extends StatelessWidget {
  const AnimationPlayerLandscapeControls(
      {Key? key, required this.animationPlayerDataManager})
      : super(key: key);

  final AnimationPlayerDataManager animationPlayerDataManager;

  @override
  Widget build(BuildContext context) {
    FlickVideoManager flickVideoManager =
        Provider.of<FlickVideoManager>(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      color: Colors.transparent,
      child: DefaultTextStyle(
        style: TextStyle(
          color: Colors.white,
        ),
        child: IconTheme(
          data: IconThemeData(color: Colors.white, size: 40),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      (animationPlayerDataManager).playNextVideo();
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Next',
                          style: TextStyle(color: Colors.white),
                        ),
                        Icon(
                          Icons.keyboard_arrow_right,
                          size: 20,
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Expanded(
                child: FlickShowControlsAction(
                  child: FlickSeekVideoAction(
                    child: Center(
                      child: flickVideoManager.nextVideoAutoPlayTimer != null
                          ? FlickAutoPlayCircularProgress(
                              colors: FlickAutoPlayTimerProgressColors(),
                            )
                          : FlickVideoBuffer(),
                    ),
                  ),
                ),
              ),
              FlickAutoHideChild(
                child: Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        (animationPlayerDataManager).getCurrentVideoTitle(),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    FlickVideoProgressBar(
                      flickProgressBarSettings:
                          FlickProgressBarSettings(height: 5),
                    ),
                    Row(
                      children: [
                        FlickPlayToggle(size: 30),
                        SizedBox(
                          width: 10,
                        ),
                        FlickSoundToggle(size: 30),
                        SizedBox(
                          width: 20,
                        ),
                        DefaultTextStyle(
                          style: TextStyle(color: Colors.white54),
                          child: Row(
                            children: <Widget>[
                              FlickCurrentPosition(
                                fontSize: 16,
                              ),
                              Text('/'),
                              FlickTotalDuration(
                                fontSize: 16,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Container(),
                        ),
                        FlickFullScreenToggle(
                          size: 30,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
