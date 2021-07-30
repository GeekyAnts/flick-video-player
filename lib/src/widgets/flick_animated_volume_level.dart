import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Shows a widget when the volume level changes.
class FlickAnimatedVolumeLevel extends StatelessWidget {
  const FlickAnimatedVolumeLevel({
    Key? key,
    this.textStyle,
    this.padding,
    this.decoration,
  }) : super(key: key);

  /// TextStyle for the font.
  final TextStyle? textStyle;

  /// Padding around the text.
  final EdgeInsetsGeometry? padding;

  /// Decoration around the text.
  final Decoration? decoration;

  @override
  Widget build(BuildContext context) {
    FlickDisplayManager displayManager =
        Provider.of<FlickDisplayManager>(context);

    bool showVolumeLevel = displayManager.showVolumeLevel;
    double? volume = displayManager.volume;

    return AnimatedSwitcher(
      duration: Duration(milliseconds: 300),
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      child: volume != null && showVolumeLevel
          ? Container(
              padding: padding,
              decoration: decoration,
              child: Text(
                '${(volume * 100).toStringAsFixed(0)}%',
                style: textStyle,
              ),
            )
          : SizedBox(),
    );
  }
}
