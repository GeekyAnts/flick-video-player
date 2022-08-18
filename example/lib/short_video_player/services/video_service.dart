import 'dart:io';
import 'package:path/path.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class VideoService {
  static Future<void> downloadVideo(String filePath) async {
    Dio dio = Dio();
    try {
      var dir = await getApplicationDocumentsDirectory();
      final File file = File(filePath);
      final String fileName = basename(file.path);
      print("path ${dir.path}, filename ");
      await dio.download(filePath, "${dir.path}/$fileName",
          onReceiveProgress: (rec, total) {
        // print("filename: $fileName,Rec: $rec , Total: $total");
      });
    } catch (e) {
      print('error $e');
    }
  }

  static Future<String> getVideoPath(String filePath) async {
    var dir = await getApplicationDocumentsDirectory();
    final File file = File(filePath);
    return "${dir.path}/${basename(file.path)}";
  }
}
