import 'package:flick_video_player/src/utils/web_key_bindings.dart';
import 'package:universal_html/html.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wakelock/wakelock.dart';

class FlickVideoPlayer extends StatefulWidget {
  const FlickVideoPlayer({
    Key? key,
    required this.flickManager,
    this.flickVideoWithControls = const FlickVideoWithControls(
      controls: const FlickPortraitControls(),
    ),
    this.flickVideoWithControlsFullscreen,
    this.systemUIOverlay = SystemUiOverlay.values,
    this.systemUIOverlayFullscreen = const [],
    this.preferredDeviceOrientation = const [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
    this.preferredDeviceOrientationFullscreen = const [
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ],
    this.wakelockEnabled = true,
    this.wakelockEnabledFullscreen = true,
    this.webKeyDownHandler = flickDefaultWebKeyDownHandler,
  }) : super(key: key);

  final FlickManager flickManager;

  /// Widget to render video and controls.
  final Widget flickVideoWithControls;

  /// Widget to render video and controls in full-screen.
  final Widget? flickVideoWithControlsFullscreen;

  /// SystemUIOverlay to show.
  ///
  /// SystemUIOverlay is changed in init.
  final List<SystemUiOverlay> systemUIOverlay;

  /// SystemUIOverlay to show in full-screen.
  final List<SystemUiOverlay> systemUIOverlayFullscreen;

  /// Preferred device orientation.
  ///
  /// Use [preferredDeviceOrientationFullscreen] to manage orientation for full-screen.
  final List<DeviceOrientation> preferredDeviceOrientation;

  /// Preferred device orientation in full-screen.
  final List<DeviceOrientation> preferredDeviceOrientationFullscreen;

  /// Prevents the screen from turning off automatically.
  ///
  /// Use [wakeLockEnabledFullscreen] to manage wakelock for full-screen.
  final bool wakelockEnabled;

  /// Prevents the screen from turning off automatically in full-screen.
  final bool wakelockEnabledFullscreen;

  /// Callback called on keyDown for web, used for keyboard shortcuts.
  final Function(KeyboardEvent, FlickManager) webKeyDownHandler;

  @override
  _FlickVideoPlayerState createState() => _FlickVideoPlayerState();
}

class _FlickVideoPlayerState extends State<FlickVideoPlayer> {
  late FlickManager flickManager;
  bool _isFullscreen = false;
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    flickManager = widget.flickManager;
    flickManager.registerContext(context);
    flickManager.flickControlManager!.addListener(listener);
    _setSystemUIOverlays();
    _setPreferredOrientation();

    if (widget.wakelockEnabled) {
      Wakelock.enable();
    }

    if (kIsWeb) {
      document.documentElement?.onFullscreenChange
          .listen(_webFullscreenListener);
      document.documentElement?.onKeyDown.listen(_webKeyListener);
    }

    super.initState();
  }

  @override
  void dispose() {
    flickManager.flickControlManager!.removeListener(listener);
    if (widget.wakelockEnabled) {
      Wakelock.disable();
    }
    super.dispose();
  }

  // Listener on [FlickControlManager],
  // Pushes the full-screen if [FlickControlManager] is changed to full-screen.
  void listener() async {
    if (flickManager.flickControlManager!.isFullscreen && !_isFullscreen) {
      _switchToFullscreen();
    } else if (_isFullscreen &&
        !flickManager.flickControlManager!.isFullscreen) {
      _exitFullscreen();
    }
  }

  _switchToFullscreen() {
    if (widget.wakelockEnabledFullscreen) {
      /// Disable previous wakelock setting.
      Wakelock.disable();
      Wakelock.enable();
    }

    _isFullscreen = true;
    _setPreferredOrientation();
    _setSystemUIOverlays();
    if (kIsWeb) {
      document.documentElement?.requestFullscreen();
    }

    _overlayEntry = OverlayEntry(builder: (context) {
      return Scaffold(
        body: FlickManagerBuilder(
          flickManager: flickManager,
          child: widget.flickVideoWithControlsFullscreen ??
              widget.flickVideoWithControls,
        ),
      );
    });

    Overlay.of(context)!.insert(_overlayEntry!);
  }

  _exitFullscreen() {
    if (widget.wakelockEnabled) {
      /// Disable previous wakelock setting.
      Wakelock.disable();
      Wakelock.enable();
    }

    _isFullscreen = false;

    if (kIsWeb) {
      document.exitFullscreen();
    }

    _overlayEntry?.remove();
    _overlayEntry = null;
    _setPreferredOrientation();
    _setSystemUIOverlays();
  }

  _setPreferredOrientation() {
    if (_isFullscreen) {
      SystemChrome.setPreferredOrientations(
          widget.preferredDeviceOrientationFullscreen);
    } else {
      SystemChrome.setPreferredOrientations(widget.preferredDeviceOrientation);
    }
  }

  _setSystemUIOverlays() {
    if (_isFullscreen) {
      SystemChrome.setEnabledSystemUIOverlays(widget.systemUIOverlayFullscreen);
    } else {
      SystemChrome.setEnabledSystemUIOverlays(widget.systemUIOverlay);
    }
  }

  void _webFullscreenListener(Event event) {
    final isFullscreen =
        window != null && (window.screenTop == 0 && window.screenY == 0);
    if (isFullscreen && !flickManager.flickControlManager!.isFullscreen) {
      flickManager.flickControlManager!.enterFullscreen();
    } else if (!isFullscreen &&
        flickManager.flickControlManager!.isFullscreen) {
      flickManager.flickControlManager!.exitFullscreen();
    }
  }

  void _webKeyListener(KeyboardEvent event) {
    widget.webKeyDownHandler(event, flickManager);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (_overlayEntry != null) {
          flickManager.flickControlManager!.exitFullscreen();
          return Future.value(false);
        }
        return Future.value(true);
      },
      child: FlickManagerBuilder(
        flickManager: flickManager,
        child: widget.flickVideoWithControls,
      ),
    );
  }
}
