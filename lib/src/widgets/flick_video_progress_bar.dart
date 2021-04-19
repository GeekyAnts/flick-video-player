import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

/// Renders progress bar for the video using custom paint.
class FlickVideoProgressBar extends StatelessWidget {
  FlickVideoProgressBar({
    this.onDragEnd,
    this.onDragStart,
    this.onDragUpdate,
    FlickProgressBarSettings? flickProgressBarSettings,
  }) : flickProgressBarSettings = flickProgressBarSettings != null
            ? flickProgressBarSettings
            : FlickProgressBarSettings();

  final FlickProgressBarSettings flickProgressBarSettings;
  final Function()? onDragStart;
  final Function()? onDragEnd;
  final Function()? onDragUpdate;

  @override
  Widget build(BuildContext context) {
    FlickControlManager controlManager =
        Provider.of<FlickControlManager>(context);
    FlickVideoManager videoManager = Provider.of<FlickVideoManager>(context);
    VideoPlayerValue? videoPlayerValue = videoManager.videoPlayerValue;

    if (videoPlayerValue == null) return Container();

    void seekToRelativePosition(Offset globalPosition) {
      final box = context.findRenderObject() as RenderBox;
      final Offset tapPos = box.globalToLocal(globalPosition);
      final double relative = tapPos.dx / box.size.width;
      final Duration position = videoPlayerValue.duration * relative;
      controlManager.seekTo(position);
    }

    return LayoutBuilder(builder: (context, size) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        child: Container(
          width: size.maxWidth,
          padding: flickProgressBarSettings.padding,
          child: Container(
            height: flickProgressBarSettings.height,
            child: CustomPaint(
              painter: _ProgressBarPainter(
                videoPlayerValue,
                flickProgressBarSettings: flickProgressBarSettings,
              ),
            ),
          ),
        ),
        onHorizontalDragStart: (DragStartDetails details) {
          if (!videoPlayerValue.isInitialized) {
            return;
          }
          // _controllerWasPlaying = flickControlManager.isPlaying;
          if (videoManager.isPlaying) {
            controlManager.autoPause();
          }

          if (onDragStart != null) {
            onDragStart!();
          }
        },
        onHorizontalDragUpdate: (DragUpdateDetails details) {
          if (!videoPlayerValue.isInitialized) {
            return;
          }
          seekToRelativePosition(details.globalPosition);

          if (onDragUpdate != null) {
            onDragUpdate!();
          }
        },
        onHorizontalDragEnd: (DragEndDetails details) {
          controlManager.autoResume();

          if (onDragEnd != null) {
            onDragEnd!();
          }
        },
        onTapDown: (TapDownDetails details) {
          if (!videoPlayerValue.isInitialized) {
            return;
          }
          seekToRelativePosition(details.globalPosition);
        },
      );
    });
  }
}

class _ProgressBarPainter extends CustomPainter {
  _ProgressBarPainter(this.value, {this.flickProgressBarSettings});

  VideoPlayerValue value;
  FlickProgressBarSettings? flickProgressBarSettings;

  @override
  bool shouldRepaint(CustomPainter painter) {
    return true;
  }

  @override
  void paint(Canvas canvas, Size size) {
    double height = flickProgressBarSettings!.height;
    double width = size.width;
    double curveRadius = flickProgressBarSettings!.curveRadius;
    double handleRadius = flickProgressBarSettings!.handleRadius;
    Paint backgroundPaint = flickProgressBarSettings!.getBackgroundPaint != null
        ? flickProgressBarSettings!.getBackgroundPaint!(
            width: width,
            height: height,
            handleRadius: handleRadius,
          )
        : Paint()
      ..color = flickProgressBarSettings!.backgroundColor;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromPoints(
          Offset(0.0, 0),
          Offset(width, height),
        ),
        Radius.circular(curveRadius),
      ),
      backgroundPaint,
    );
    if (value.isInitialized == false) {
      return;
    }

    final double playedPartPercent =
        value.position.inMilliseconds / value.duration.inMilliseconds;
    final double playedPart =
        playedPartPercent > 1 ? width : playedPartPercent * width;

    for (DurationRange range in value.buffered) {
      final double start = range.startFraction(value.duration) * width;
      final double end = range.endFraction(value.duration) * width;

      Paint bufferedPaint = flickProgressBarSettings!.getBufferedPaint != null
          ? flickProgressBarSettings!.getBufferedPaint!(
              width: width,
              height: height,
              playedPart: playedPart,
              handleRadius: handleRadius,
              bufferedStart: start,
              bufferedEnd: end)
          : Paint()
        ..color = flickProgressBarSettings!.bufferedColor;

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromPoints(
            Offset(start, 0),
            Offset(end, height),
          ),
          Radius.circular(curveRadius),
        ),
        bufferedPaint,
      );
    }

    Paint playedPaint = flickProgressBarSettings!.getPlayedPaint != null
        ? flickProgressBarSettings!.getPlayedPaint!(
            width: width,
            height: height,
            playedPart: playedPart,
            handleRadius: handleRadius,
          )
        : Paint()
      ..color = flickProgressBarSettings!.playedColor;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromPoints(
          Offset(0.0, 0.0),
          Offset(playedPart, height),
        ),
        Radius.circular(curveRadius),
      ),
      playedPaint,
    );

    Paint handlePaint = flickProgressBarSettings!.getHandlePaint != null
        ? flickProgressBarSettings!.getHandlePaint!(
            width: width,
            height: height,
            playedPart: playedPart,
            handleRadius: handleRadius,
          )
        : Paint()
      ..color = flickProgressBarSettings!.handleColor;

    canvas.drawCircle(
      Offset(playedPart, height / 2),
      handleRadius,
      handlePaint,
    );
  }
}
