import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../data/mock_data.dart';
import '../services/video_service.dart';
import '../short_video_player/short_video_player.dart';

class ShortVideoHomePage extends StatefulWidget {
  const ShortVideoHomePage({Key? key}) : super(key: key);

  @override
  State<ShortVideoHomePage> createState() => _ShortVideoHomePageState();
}

class _ShortVideoHomePageState extends State<ShortVideoHomePage> {
  bool isDownloading = false;
  @override
  void initState() {
    super.initState();
    deleteExistingData().then((value) {
      saveVideosLocally();
    });
  }

  Future<void> deleteExistingData() async {
    var dirPath = await getApplicationDocumentsDirectory();
    final dir = Directory(dirPath.path);
    await dir.delete(recursive: true);
  }

  Future<void> saveVideosLocally() async {
    setState(() {
      isDownloading = true;
    });
    await Future.wait([
      for (var data in shortVideoMockData['items'])
        VideoService.downloadVideo(data['trailer_url'])
    ]);
    setState(() {
      isDownloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isDownloading
          ? const Center(child: CircularProgressIndicator())
          : const ShortVideoPlayer(),
    );
  }
}
