import 'dart:convert';

import 'package:app_laser_cat/app_config.dart';
import 'package:app_laser_cat/modules/records/infra/models/enums/item_record_enum.dart';
import 'package:app_laser_cat/modules/records/infra/models/item_model.dart';
import 'package:app_laser_cat/modules/records/infra/models/record_model.dart';
import 'package:app_laser_cat/modules/records/infra/models/record_types/item_coords.dart';
import 'package:app_laser_cat/modules/records/infra/models/record_types/item_delay.dart';
import 'package:app_laser_cat/modules/records/infra/models/record_types/record_abstract.dart';
import 'package:app_laser_cat/shared/infra/provider/file_provider.dart';
import 'package:app_laser_cat/shared/infra/routes/routes.dart';
import 'package:app_laser_cat/shared/ui/dialogs/record_item_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class RecordController extends GetxController {
  RxList<RecordModel> records = RxList<RecordModel>([]);
  Rx<RecordModel?> currentRecord = Rx<RecordModel?>(null);
  Rx<GenericItemModel?> currentRecordItem = Rx<GenericItemModel?>(null);

  @override
  void onInit() {
    super.onInit();
  }

  void setCurrentRecord(RecordModel record) {
    currentRecord.value = record;
  }

  void getRecordList() async {
    records.clear();
    final fileStorage = FileProvider();
    final List<String> files =
        await fileStorage.listFilesByDir(AppConfig.recordsDir, true);
    if (files.isEmpty) {
      return;
    }
    for (var fileName in files) {
      final filePath = "${AppConfig.recordsDir}/$fileName";
      var recordJson = await fileStorage.read(filePath);
      final record = RecordModel.fromJson(recordJson);
      print("file ${filePath} ${record}");
      records.add(record);
    }
  }

  void setCurrentWidget(GenericItemModel currentItem) {
    currentRecordItem.value = currentItem;
  }

  void showItemWidget(GenericItemModel currentItem) {
    ItemRecordEnum type = ItemRecordEnum.values[currentItem.type];
    RecordAbstract? item;
    switch (type) {
      case ItemRecordEnum.coord:
        item = ItemCoord.fromJson(currentItem.object);
        break;
      case ItemRecordEnum.delay:
        item = ItemDelay.fromJson(currentItem.object);
        break;
    }

    item?.showDialog(this);
  }

  ///we can do better here after.
  String getItemRecordTitle(GenericItemModel currentItem) {
    ItemRecordEnum type = ItemRecordEnum.values[currentItem.type];
    final title = _getItemRecordType(currentItem);
    switch (type) {
      case ItemRecordEnum.coord:
        final item = ItemCoord.fromJson(currentItem.object);
        return "${title} x: ${item.x} y: ${item.y}";
      case ItemRecordEnum.delay:
        // item = ItemDelay.fromJson(currentItem.object);
        break;
    }
    return "";
  }

  ///we need extend enum to do this. This is wrong.. but its 23:43
  String _getItemRecordType(GenericItemModel currentItem) {
    ItemRecordEnum type = ItemRecordEnum.values[currentItem.type];
    switch (type) {
      case ItemRecordEnum.coord:
        return "Coord";
      case ItemRecordEnum.delay:
        return "Delay";
    }
    return "";
  }

  RecordModel _getRecordById(String id) {
    return records.firstWhere((element) => element.id == id);
  }

  void _openRecordView(String id) {
    Get.toNamed(SharedRoutes.RecordViewRoute, arguments: {id: id});
  }
}
