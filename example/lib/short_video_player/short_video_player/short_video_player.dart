import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../feed_player/multi_manager/flick_multi_manager.dart';
import '../data/mock_data.dart';
import '../services/video_service.dart';
import './multi_manager/flick_multi_player.dart';

class ShortVideoPlayer extends StatefulWidget {
  const ShortVideoPlayer({Key? key}) : super(key: key);

  @override
  ShortVideoPlayerState createState() => ShortVideoPlayerState();
}

class ShortVideoPlayerState extends State<ShortVideoPlayer> {
  List items = [];

  late FlickMultiManager flickMultiManager;

  @override
  void initState() {
    super.initState();
    getVideoData();
    flickMultiManager = FlickMultiManager();
  }

  Future<void> getVideoData() async {
    List<String> paths = await Future.wait([
      for (var data in shortVideoMockData['items'])
        VideoService.getVideoPath(data['trailer_url'])
    ]);
    items.addAll(paths);
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: ObjectKey(flickMultiManager),
      onVisibilityChanged: (visibility) {
        if (visibility.visibleFraction == 0 && mounted) {
          flickMultiManager.pause();
        }
      },
      child: PageView.builder(
        scrollDirection: Axis.vertical,
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Container(
              height: 800,
              margin: const EdgeInsets.all(2),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: FlickMultiPlayer(
                  url: items[index],
                  flickMultiManager: flickMultiManager,
                  image: shortVideoMockData['items'][index]['image'],
                ),
              ));
        },
      ),
    );
  }
}
