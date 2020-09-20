import 'dart:math';

import 'package:flutter/material.dart';

import 'auto_play_timer_progress_colors.dart';

class FlickAutoPlayTimerProgressPainter extends CustomPainter {
  FlickAutoPlayTimerProgressPainter({
    this.animation,
    FlickAutoPlayTimerProgressColors colors,
  })  : this.colors = colors ?? FlickAutoPlayTimerProgressColors(),
        super(repaint: animation);

  final Animation<double> animation;
  final FlickAutoPlayTimerProgressColors colors;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = colors.backgroundColor
      ..strokeWidth = 5.0
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2.0, paint);
    paint.color = colors.color;
    double progress = (1.0 - animation.value) * 2 * pi;
    canvas.drawArc(Offset.zero & size, pi * 1.5, -progress, false, paint);
  }

  @override
  bool shouldRepaint(FlickAutoPlayTimerProgressPainter old) {
    return false;
  }
}
