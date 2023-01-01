import 'dart:async';
import 'dart:convert';

import 'package:app_laser_cat/app_config.dart';
import 'package:app_laser_cat/modules/records/infra/models/enums/item_record_enum.dart';
import 'package:app_laser_cat/modules/records/infra/models/enums/record_types_enum.dart';
import 'package:app_laser_cat/modules/records/infra/models/item_model.dart';
import 'package:app_laser_cat/modules/records/infra/models/record_model.dart';
import 'package:app_laser_cat/modules/records/infra/models/records/itens/item_coords.dart';
import 'package:app_laser_cat/modules/records/infra/models/records/itens/item_delay.dart';
import 'package:app_laser_cat/modules/records/infra/models/records/itens/item_laser.dart';
import 'package:app_laser_cat/modules/records/infra/models/records/record_abstract.dart';
import 'package:app_laser_cat/shared/infra/provider/file_provider.dart';
import 'package:app_laser_cat/shared/infra/routes/routes.dart';
import 'package:app_laser_cat/shared/infra/services/connector_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../models/records/record_options.dart';

class RecordController extends GetxController {
  RxList<RecordModel> records = RxList<RecordModel>([]);
  Rx<RecordModel?> currentRecord = Rx<RecordModel?>(null);
  List<RecordAbstract> recordItemsLoaded = [];
  RxBool isLoading = RxBool(false);
  RxBool isPlay = RxBool(false);

  Rx<ItemModel?> currentRecordItem = Rx<ItemModel?>(null);
  ConnectorService connectorService = Get.find<ConnectorService>();
  static final fileStorage = FileProvider();

  @override
  void onInit() {
    super.onInit();
  }

  void setCurrentRecord(RecordModel record) {
    currentRecord.value = record;
  }

  void getRecordList() async {
    isLoading.value = true;
    records.clear();
    final List<String> fileNames = await _getRecordFiles();
    if (fileNames.isEmpty) {
      return;
    }
    records.value = await _getRecordList(fileNames);
    isLoading.value = false;
  }

  Future<List<RecordModel>> _getRecordList(List<String> files) async {
    List<RecordModel> result = [];
    for (var fileName in files) {
      final filePath = "${AppConfig.recordsDir}/$fileName";
      var recordJson = await fileStorage.read(filePath);
      final record = RecordModel.fromJson(recordJson);
      result.add(record);
    }
    return result;
  }

  Future<List<String>> _getRecordFiles() async {
    final List<String> files =
        await fileStorage.listFilesByDir(AppConfig.recordsDir, true);
    return files;
  }

  void setCurrentWidget(ItemModel currentItem) {
    currentRecordItem.value = currentItem;
  }

  void showItemWidget(ItemModel currentItem) {
    ItemRecordEnum type = ItemRecordEnum.values[currentItem.type];
    RecordAbstract? item;
    switch (type) {
      case ItemRecordEnum.coord:
        item = ItemCoord.fromJson(currentItem.object);
        break;
      case ItemRecordEnum.delay:
        item = ItemDelay.fromJson(currentItem.object);
        break;
      case ItemRecordEnum.laser:
        item = ItemLaser.fromJson(currentItem.object);
        break;
    }

    item.showDialog(this);
  }

  ///we can do better here after.
  String getItemRecordTitle(ItemModel currentItem) {
    ItemRecordEnum type = ItemRecordEnum.values[currentItem.type];
    final title = _getItemRecordType(currentItem);
    switch (type) {
      case ItemRecordEnum.coord:
        final item = ItemCoord.fromJson(currentItem.object);
        return "$title x: ${item.x} y: ${item.y}";
      case ItemRecordEnum.delay:
        final item = ItemDelay.fromJson(currentItem.object);
        return "$title delay: ${item.value} ms";
      case ItemRecordEnum.laser:
        final item = ItemLaser.fromJson(currentItem.object);
        return "$title potency: ${item.value} PWD";
    }
  }

  ///we need extend enum to do this. This is wrong.. but its 23:43
  String _getItemRecordType(ItemModel currentItem) {
    ItemRecordEnum type = ItemRecordEnum.values[currentItem.type];
    switch (type) {
      case ItemRecordEnum.coord:
        return "Coord";
      case ItemRecordEnum.delay:
        return "Delay";
      case ItemRecordEnum.laser:
        return "Laser";
    }
  }

  RecordModel _getRecordById(String id) {
    return records.firstWhere((element) => element.id == id);
  }

  void _openRecordView(String id) {
    Get.toNamed(SharedRoutes.RecordViewRoute, arguments: {id: id});
  }

  void addRecord(String recordName) {
    final fileProvider = FileProvider();
    String name = recordName.toLowerCase();
    final options = RecordOptions(recordType: RecordTypeEnum.playOnPress.index);
    final mapper = RecordModel(name, currentRecord.value?.itens ?? [], options);
    fileProvider.write("records/$name.json", mapper.toJson());
    print("saving as $name.json");
    Get.back();
  }

  void resetPosition() {
    connectorService.sendPackage(90, 90);
  }

  /// we will separe this after.
  Future<void> playRecord(RecordModel record) async {
    if (connectorService.isConnected == false) {
      Get.defaultDialog(
          title: "Disconnected",
          content: const Text("Esp 8266 is offline."),
          onConfirm: () => Get.back());
      return;
    }
    final type = RecordTypeEnum.values[record.options.recordType];
    switch (type) {
      case RecordTypeEnum.playOnPress:
        print("Play on press");
        isPlay.value = true;
        await playRecording(record.itens);
        isPlay.value = false;
        break;
      case RecordTypeEnum.repeat:
        print("Play on repeat");
        isPlay.value = true;
        while (isPlay.value) {
          await playRecording(record.itens);
        }
    }
  }

  //play recording
  Future<void> playRecording(List<ItemModel> records) async {
    resetPosition();
    print("play recordings");
    List<RecordAbstract> recordsLoaded = _loadRecordItems(records);
    for (var item in recordsLoaded) {
      print("execute item. ${item.title}");
      await item.execute(connectorService);
    }
  }

  ///pre load item
  List<RecordAbstract> _loadRecordItems(List<ItemModel> records) {
    print("load records itens");
    List<RecordAbstract> itemsLoaded = [];
    for (var item in records) {
      if (item.type == ItemRecordEnum.coord.index) {
        final itemCoord = ItemCoord.fromJson(item.object);
        itemsLoaded.add(itemCoord);
      }
      if (item.type == ItemRecordEnum.delay.index) {
        final itemDelay = ItemDelay.fromJson(item.object);
        itemsLoaded.add(itemDelay);
      }
      if (item.type == ItemRecordEnum.laser.index) {
        final itemLaser = ItemLaser.fromJson(item.object);
        itemsLoaded.add(itemLaser);
      }
    }
    return itemsLoaded;
  }
}
