import 'dart:convert';

import 'package:app_laser_cat/app_config.dart';
import 'package:app_laser_cat/modules/joystick/infra/models/record_model.dart';
import 'package:app_laser_cat/shared/infra/provider/file_provider.dart';
import 'package:get/get.dart';

class RecordController extends GetxController {
  Rx<List<RecordModel>> records = Rx<List<RecordModel>>([]);

  Future<void> getRecordList() async {
    print("record list");
    final fileStorage = FileProvider();
    final List<String> files =
        await fileStorage.listFilesByDir(AppConfig.recordsDir, true);
    for (var e in files) {
      var recordList = jsonDecode(await fileStorage.read(e));
      records.value = recordList;
    }
  }
}
