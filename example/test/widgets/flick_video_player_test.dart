import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:video_player/video_player.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([
  VideoPlayerController,
  FlickManager,
  FlickVideoManager,
  FlickControlManager,
  FlickDisplayManager
])
import 'flick_video_player_test.mocks.dart';

void main() {
  late MockVideoPlayerController mockVideoPlayerController;
  late MockFlickManager mockFlickManager;
  late MockFlickVideoManager mockFlickVideoManager;
  late MockFlickControlManager mockFlickControlManager;
  late MockFlickDisplayManager mockFlickDisplayManager;

  const Duration testDuration = Duration(seconds: 60);

  void setUpMocks() {
    mockVideoPlayerController = MockVideoPlayerController();
    mockFlickManager = MockFlickManager();
    mockFlickVideoManager = MockFlickVideoManager();
    mockFlickControlManager = MockFlickControlManager();
    mockFlickDisplayManager = MockFlickDisplayManager();

    // Set up mock behavior for FlickManager
    when(mockFlickManager.flickVideoManager).thenReturn(mockFlickVideoManager);
    when(mockFlickManager.flickControlManager)
        .thenReturn(mockFlickControlManager);
    when(mockFlickManager.flickDisplayManager)
        .thenReturn(mockFlickDisplayManager);
    when(mockFlickManager.registerContext(any))
        .thenAnswer((_) => Future.value());
    when(mockFlickManager.handleChangeVideo(any))
        .thenAnswer((_) => Future.value());
    when(mockFlickManager.dispose()).thenAnswer((_) => Future.value());

    // Set up mock behavior for VideoPlayerController
    when(mockVideoPlayerController.initialize())
        .thenAnswer((_) => Future.value());
    final mockVideoPlayerValue = VideoPlayerValue(
      duration: testDuration,
      position: Duration.zero,
      playbackSpeed: 1.0,
      isPlaying: false,
      isLooping: false,
      isBuffering: false,
      volume: 1.0,
      errorDescription: null,
    );
    when(mockVideoPlayerController.value).thenReturn(mockVideoPlayerValue);
    when(mockVideoPlayerController.closedCaptionFile).thenReturn(null);

    // Set up mock behavior for FlickVideoManager
    when(mockFlickVideoManager.videoPlayerController)
        .thenReturn(mockVideoPlayerController);
    when(mockFlickVideoManager.errorInVideo).thenReturn(false);
    when(mockFlickVideoManager.isVideoInitialized).thenReturn(true);
    when(mockFlickVideoManager.isPlaying).thenReturn(false);
    when(mockFlickVideoManager.isVideoEnded).thenReturn(false);
    when(mockFlickVideoManager.isBuffering).thenReturn(false);
    when(mockFlickVideoManager.videoPlayerValue)
        .thenReturn(mockVideoPlayerValue);

    // Set up mock behavior for FlickControlManager
    when(mockFlickControlManager.isFullscreen).thenReturn(false);
    when(mockFlickControlManager.isMute).thenReturn(false);
    when(mockFlickControlManager.isSub).thenReturn(false);
    when(mockFlickControlManager.togglePlay()).thenAnswer((_) async {});

    // Set up mock behavior for FlickDisplayManager
    when(mockFlickDisplayManager.showPlayerControls).thenReturn(true);
    when(mockFlickDisplayManager.showForwardSeek).thenReturn(true);
    when(mockFlickDisplayManager.showBackwardSeek).thenReturn(false);
  }

  Widget buildTestWidget() {
    return MaterialApp(
      home: Scaffold(
        body: FlickVideoPlayer(
          flickManager: mockFlickManager,
        ),
      ),
    );
  }

  group('FlickVideoPlayer Widget Tests', () {
    setUp(setUpMocks);

    testWidgets('renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump(Duration(seconds: 1));

      expect(find.byType(FlickVideoPlayer), findsOneWidget,
          reason: 'FlickVideoPlayer should be rendered');
      expect(find.byType(FlickVideoWithControls), findsOneWidget,
          reason: 'FlickVideoWithControls should be rendered');
      expect(find.byType(FlickPortraitControls), findsOneWidget,
          reason: 'FlickPortraitControls should be rendered');
    });

    testWidgets('play button interaction works', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump(Duration(seconds: 1));

      expect(find.byIcon(Icons.play_arrow), findsNWidgets(2),
          reason: 'Two play buttons should be visible');
      await tester.tap(find.byIcon(Icons.play_arrow).at(0));
      await tester.pump();

      verify(mockFlickControlManager.togglePlay()).called(1);
    });

    testWidgets('volume button interaction works', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump(Duration(seconds: 1));

      expect(find.byIcon(Icons.volume_up), findsOneWidget,
          reason: 'Volume up icon should be visible');
      await tester.tap(find.byIcon(Icons.volume_up));
      await tester.pump();

      verify(mockFlickControlManager.toggleMute()).called(1);
    });

    testWidgets('fullscreen button interaction works',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump(Duration(seconds: 1));

      expect(find.byIcon(Icons.fullscreen), findsOneWidget,
          reason: 'Fullscreen icon should be visible');
      await tester.tap(find.byIcon(Icons.fullscreen));
      await tester.pump();

      verify(mockFlickControlManager.toggleFullscreen()).called(1);
    });
  });
}
