import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Returns a text widget with total duration of the video.
class FlickTotalDuration extends StatelessWidget {
  const FlickTotalDuration({
    Key? key,
    this.fontSize,
    this.color,
  }) : super(key: key);

  final double? fontSize;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    FlickVideoManager videoManager = Provider.of<FlickVideoManager>(context);

    Duration? duration = videoManager.videoPlayerValue?.duration;

    String? durationInSeconds = duration != null
        ? (duration - Duration(minutes: duration.inMinutes))
            .inSeconds
            .toString()
            .padLeft(2, '0')
        : null;

    String textDuration =
        duration != null ? '${duration.inMinutes}:$durationInSeconds' : '0:00';

    return Text(
      textDuration,
      style: TextStyle(
        fontSize: fontSize,
        color: color,
      ),
    );
  }
}
