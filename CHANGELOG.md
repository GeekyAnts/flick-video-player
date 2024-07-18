## 0.1.0

Initial version of FlickVideoPlayer.

## 0.1.1

Added homepage in pubspec.yaml

## 0.2.0

Upgraded the packages to make it compatible with Flutter 2.0.0.

## 0.2.1

Added `setPlaybackSpeed` method in `FlickControlManager` to change video playback speed with `FlickSetPlayBack` UI helper widget.

## 0.3.0

Migrated to dart null safety.

## 0.3.1

Fix for NullPointerException for video_player in release mode.

## 0.4.0

Updated Flutter to 2.8.0

Added an example for web platform, with some fixes on the player for web.

Added keyboard shortcuts for web player.

Added default closed caption show feature.

Added caption toggle UI widget(FlickSubtitleToggle) and functionality.

Updated video_player to latest version video_player: ^2.2.10

Updated wakelock to wakelock: ^0.5.6

`setEnabledSystemUIOverlays` is deprecated and shouldn't be used. Migrate to `setEnabledSystemUIMode`

Fix - Only show buffering is video is buffering and playing.

Fix - Only disable Wakelock if setting enabled by the user.

Web Fix - Chrome auto-play policy fix, video to be muted by default if auto-play enabled.

Fix - Video player initialization issue.

Fix - Player control on Mobile browser.

Fix - Aspect ratio issue.

Fix - Updated third-party packages

## 0.5.0

Updated minimum Flutter version to 2.10.

Updated dependencies

Added option to immediately hide player controls in `FlickDisplayManager`

Fix - Static analysis

## 0.6.0

Updated Flutter version to 3.16.

Upgraded dependencies

## 0.7.0

Fix - pub.dev warnings

Fix - Deprecated widgets

Fix - Web full screen issue.

## 0.8.0

Updated wakelock to wakelock_plus: ^1.1.4

Updated video_player to latest version video_player: ^2.8.6

Fix - Formatting
