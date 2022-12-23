import 'dart:io';
import 'package:app_laser_cat/app_config.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class FileProvider {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return AppConfig.devMode == false
        ? directory.path
        : "/storage/emulated/0/Download";
  }

  Future<File> _localFile(String fileName) async {
    final path = await _localPath; //await _localPath;
    return File('$path/$fileName').create(recursive: true);
  }

  Future<File> write(String fileName, String data) async {
    final file = await _localFile(fileName);
    return file.writeAsString(data);
  }

  Future<String> read(String fileName) async {
    final file = await _localFile(fileName);
    final contents = await file.readAsString();
    return contents;
  }

  Future<List<String>> listFilesByDir(String directoryName,
      [bool baseName = false]) async {
    List<String> files = [];

    final path = await _localPath;
    final dirPath = Directory("$path/$directoryName");
    final dirExist = await dirPath.exists();
    //print("dir exists ${dirExist}");
    if (dirExist == false) {
      return [];
    }
    //  print("dir: ${dirPath.path}");

    await for (var entity
        in dirPath.list(recursive: true, followLinks: false)) {
      baseName ? files.add(basename(entity.path)) : files.add(entity.path);
    }
    // print("result: ${files}");
    return files;
  }
}
