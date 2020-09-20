import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../flick_video_player.dart';

/// Returns a text widget with current position of the video.
class FlickCurrentPosition extends StatelessWidget {
  const FlickCurrentPosition({
    Key key,
    this.fontSize,
    this.colorr,
  }) : super(key: key);

  final double fontSize;
  final Color colorr;

  @override
  Widget build(BuildContext context) {
    FlickVideoManager videoManager = Provider.of<FlickVideoManager>(context);

    Duration position = videoManager?.videoPlayerValue?.position;

    String positionInSeconds = position != null
        ? (position - Duration(minutes: position.inMinutes))
            .inSeconds
            .toString()
            .padLeft(2, '0')
        : null;

    String textPosition =
        position != null ? '${position.inMinutes}:$positionInSeconds' : '0:00';

    return Text(
      textPosition,
      style: TextStyle(
        color: colorr,
        fontSize: fontSize,
      ),
    );
  }
}
