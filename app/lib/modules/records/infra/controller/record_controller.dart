import 'dart:convert';

import 'package:app_laser_cat/app_config.dart';
import 'package:app_laser_cat/modules/joystick/infra/models/coord_package.dart';
import 'package:app_laser_cat/shared/infra/provider/file_provider.dart';
import 'package:get/get.dart';

class RecordController extends GetxController {
  Future<List<CoordPackage>> getRecordList() async {
    final fileStorage = new FileProvider();
    final files = await fileStorage.listFilesByDir(AppConfig.recordsDir, true);
    final packages = await files.map((e) async {
      Iterable packageListJson = jsonDecode(await fileStorage.read(e));
      return List<CoordPackage>.from(
          packageListJson.map((model) => CoordPackage.fromJson(model)));
    });
    return packages;
  }
}
