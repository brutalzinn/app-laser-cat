import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';

class FileProvider {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    print(directory.path);
    return directory.path;
  }

  Future<String> get _localExternalPath async {
    return "/storage/emulated/0/Download";
  }

  Future<File> _localFile(String fileName) async {
    final path = await _localExternalPath; //await _localPath;
    print(path);
    return File('$path/$fileName').create(recursive: true);
  }

  Future<File> write(String fileName, String data) async {
    final file = await _localFile(fileName);
    return file.writeAsString(data);
  }

  Future<String> read(String fileName, String data) async {
    final file = await _localFile(fileName);
    final contents = await file.readAsString();
    return contents;
  }
}
