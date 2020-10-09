import 'package:cached_flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/mock_data.dart';
import 'landscape_player_controls.dart';

class LandscapePlayer extends StatefulWidget {
  LandscapePlayer({Key key}) : super(key: key);

  @override
  _LandscapePlayerState createState() => _LandscapePlayerState();
}

class _LandscapePlayerState extends State<LandscapePlayer> {
  FlickManager flickManager;

  @override
  void initState() {
    super.initState();
    flickManager = FlickManager(
        videoPlayerController: CachedVideoPlayerController.network(
            mockData["items"][2]["trailer_url"]));
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlickVideoPlayer(
        flickManager: flickManager,
        preferredDeviceOrientation: [
          DeviceOrientation.landscapeRight,
          DeviceOrientation.landscapeLeft
        ],
        systemUIOverlay: [],
        flickVideoWithControls: FlickVideoWithControls(
          controls: LandscapePlayerControls(),
        ),
      ),
    );
  }
}
