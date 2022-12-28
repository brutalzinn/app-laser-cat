import 'dart:convert';

import 'package:app_laser_cat/app_config.dart';
import 'package:app_laser_cat/modules/records/infra/models/record_model.dart';
import 'package:app_laser_cat/shared/infra/provider/file_provider.dart';
import 'package:app_laser_cat/shared/infra/routes/routes.dart';
import 'package:get/get.dart';

class RecordController extends GetxController {
  RxList<RecordModel> records = RxList<RecordModel>([]);

  void getRecordList() async {
    records.clear();
    final fileStorage = FileProvider();
    final List<String> files =
        await fileStorage.listFilesByDir(AppConfig.recordsDir, true);
    for (var fileName in files) {
      final filePath = "${AppConfig.recordsDir}/$fileName";
      var recordJson = await fileStorage.read(filePath);
      final record = RecordModel.fromJson(recordJson);
      print("file ${filePath} ${record}");
      records.add(record);
    }
  }

  RecordModel _getRecordById(String id) {
    return records.firstWhere((element) => element.id == id);
  }

  void _openRecordView(String id) {
    Get.toNamed(SharedRoutes.RecordViewRoute, arguments: {id: id});
  }
}
