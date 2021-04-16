import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Uses [MultiProviders] to add all the managers as providers.
class FlickManagerBuilder extends StatelessWidget {
  const FlickManagerBuilder(
      {Key? key, required this.child, required this.flickManager})
      : super(key: key);
  final Widget child;
  final FlickManager flickManager;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<FlickVideoManager>.value(
          value: flickManager.flickVideoManager!,
        ),
        ChangeNotifierProvider<FlickDisplayManager>.value(
          value: flickManager.flickDisplayManager!,
        ),
        ChangeNotifierProvider<FlickControlManager>.value(
          value: flickManager.flickControlManager!,
        ),
      ],
      child: child,
    );
  }
}
