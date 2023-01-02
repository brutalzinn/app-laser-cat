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
  Rx<RecordTypeEnum> currentRecordType =
      Rx<RecordTypeEnum>(RecordTypeEnum.none);
  List<RecordAbstract> recordItemsLoaded = [];
  RxBool isLoading = RxBool(false);
  RxBool isPlay = RxBool(false);
  bool isRunning = false;
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
    switch (type) {
      case ItemRecordEnum.coord:
        final item = ItemCoord.fromJson(currentItem.object);
        return "${item.title} x: ${item.x} y: ${item.y}";
      case ItemRecordEnum.delay:
        final item = ItemDelay.fromJson(currentItem.object);
        return "${item.title} delay: ${item.value} ms";
      case ItemRecordEnum.laser:
        final item = ItemLaser.fromJson(currentItem.object);
        return "${item.title} potency: ${item.value} PWD";
    }
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
    connectorService.toggleLaser(0);
    connectorService.sendPackage(90, 90);
  }

  bool get isConnected => connectorService.isConnected;

  void showDisconnectionDialog() {
    Get.defaultDialog(
        title: "Disconnected",
        content: const Text("Esp 8266 is offline."),
        onConfirm: () => Get.back());
  }

  bool isShowDisconnectionDialog() {
    if (isConnected == false) {
      showDisconnectionDialog();
      return true;
    }
    return false;
  }

  ///lets do go horse here. Because i already learned what i want learn with this project.
  /// we will separe this after.
  Future<void> playRecord(RecordModel record) async {
    if (isShowDisconnectionDialog()) {
      return;
    }
    print("Play on press");
    isRunning = !isRunning;
    await playRecording(record.itens);
  }

  /// we will separe this after.
  Future<void> playLongRecord(RecordModel record) async {
    if (isShowDisconnectionDialog()) {
      return;
    }
    print("Play on press");
    isRunning = !isRunning;
    while (isRunning) {
      await playRecording(record.itens);
    }
  }

  //play recording
  Future<void> playRecording(List<ItemModel> records) async {
    resetPosition();
    print("play recordings");
    List<RecordAbstract> recordsLoaded = _loadRecordItems(records);
    for (var item in recordsLoaded) {
      if (isShowDisconnectionDialog() || isRunning == false) {
        resetPosition();
        print("force stop or disconnected.");
        break;
      }
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
