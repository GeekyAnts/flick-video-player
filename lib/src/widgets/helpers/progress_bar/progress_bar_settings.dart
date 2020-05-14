import 'package:flutter/material.dart';

typedef Paint GetProgressBarBackgroundPaint({
  double width,
  double height,
  double handleRadius,
});

typedef Paint GetProgressBarPlayedPaint({
  double width,
  double height,
  double playedPart,
  double handleRadius,
});

typedef Paint GetProgressBarBufferedPaint({
  double width,
  double height,
  double playedPart,
  double handleRadius,
  double bufferedStart,
  double bufferedEnd,
});

typedef Paint GetProgressBarHandlePaint({
  double width,
  double height,
  double playedPart,
  double handleRadius,
});

class FlickProgressBarSettings {
  FlickProgressBarSettings({
    this.playedColor: const Color.fromRGBO(255, 255, 255, 1),
    this.bufferedColor: const Color.fromRGBO(255, 255, 255, 0.38),
    this.handleColor: const Color.fromRGBO(255, 255, 255, 1),
    this.backgroundColor: const Color.fromRGBO(255, 255, 255, 0.24),
    this.padding = const EdgeInsets.symmetric(
      vertical: 10,
    ),
    this.height = 3,
    this.handleRadius = 3.3,
    this.curveRadius = 4,
    this.getPlayedPaint,
    this.getBufferedPaint,
    this.getHandlePaint,
    this.getBackgroundPaint,
  });

  /// Color for played area, not applied if [getPlayedPaint] is provided.
  final Color playedColor;

  /// Color for buffered area, not applied if [getBufferedPaint] is provided.
  final Color bufferedColor;

  /// Color for handle, not applied if [getHandlePaint] is provided.
  final Color handleColor;

  /// Color for background area, not applied if [getBackgroundPaint] is provided.
  final Color backgroundColor;

  /// Paint for played area.
  final GetProgressBarPlayedPaint getPlayedPaint;

  /// Paint for buffered area.
  final GetProgressBarBufferedPaint getBufferedPaint;

  /// Paint for handle.
  final GetProgressBarHandlePaint getHandlePaint;

  /// Paint for background area.
  final GetProgressBarBackgroundPaint getBackgroundPaint;

  /// Height of the progress bar.
  final double height;

  /// Padding for the progress bar.
  /// Padding area is included in the [GestureDetector].
  final EdgeInsetsGeometry padding;

  /// Handle radius.
  /// Should be bigger then [height] so that handle is visible.
  /// 0.0 will hide the handle.
  final double handleRadius;

  /// Radius to curve the ends of the bar.
  final double curveRadius;
}
