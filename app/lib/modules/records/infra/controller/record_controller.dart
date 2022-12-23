import 'dart:convert';

import 'package:app_laser_cat/app_config.dart';
import 'package:app_laser_cat/modules/joystick/infra/models/record_model.dart';
import 'package:app_laser_cat/shared/infra/provider/file_provider.dart';
import 'package:get/get.dart';

class RecordController extends GetxController {
  Rx<List<RecordModel>> records = Rx<List<RecordModel>>([]);

  Future<void> getRecordList() async {
    records.value.clear();
    print("record list");
    final fileStorage = FileProvider();
    final List<String> files =
        await fileStorage.listFilesByDir(AppConfig.recordsDir, true);
    print("files found ${files}");
    for (var filaName in files) {
      final filePath = "${AppConfig.recordsDir}/${filaName}";
      print("test file ${filePath}");
      var recordJson = await fileStorage.read(filePath);
      print(recordJson);
      final record = RecordModel.fromJson(recordJson);
      // var reco
      print("file ${filePath} ${record}");
      records.value.add(record);
    }
  }
}
