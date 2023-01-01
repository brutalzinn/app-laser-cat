import 'package:app_laser_cat/modules/records/infra/models/enums/item_record_enum.dart';
import 'package:app_laser_cat/modules/records/infra/models/enums/record_types_enum.dart';
import 'package:app_laser_cat/modules/records/infra/models/item_model.dart';
import 'package:app_laser_cat/modules/records/infra/models/record_model.dart';
import 'package:app_laser_cat/modules/records/infra/models/records/itens/item_coords.dart';
import 'package:app_laser_cat/modules/records/infra/models/records/itens/item_delay.dart';
import 'package:app_laser_cat/modules/records/infra/models/records/itens/item_laser.dart';
import 'package:app_laser_cat/modules/records/infra/models/records/record_options.dart';
import 'package:app_laser_cat/modules/records/ui/dialogs/record_add_dialog.dart';
import 'package:app_laser_cat/shared/infra/provider/file_provider.dart';
import 'package:app_laser_cat/shared/infra/provider/settings_provider.dart';
import 'package:app_laser_cat/shared/infra/services/connector_service.dart';
import 'package:app_laser_cat/shared/ui/dialogs/textfield_dialog.dart';
import 'package:app_laser_cat/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

///this controller is just for joystick widget.
///why we have web socket channel here? This cant be a dependency. Sometimes we need just connect to esp 8266 and close connection.
class JoystickController extends GetxController {
  bool isLaserToggle = false;
  int _xCoords = 0;
  int _yCoords = 0;
  List<ItemModel> packages = [];
  Rx<bool> isRecording = Rx<bool>(false);
  bool isPause = false;
  SettingsPref settings = Get.find<SettingsPref>();
  ConnectorService connectorService = Get.find<ConnectorService>();

  DateTime? lastSendPackage;

  ///init this instance

  @override
  void onInit() {
    initConnection();
  }

  ///init connection with esp8266
  void initConnection() async {
    clearFields();
    connectorService.connectESP();
  }

  /// map cartesian plan xCoords and yCoords to servo range.
  void _mapToServoRange(double dx, double dy) {
    double steps = settings.velocity.val;
    int x = Utils.remapper(-dx, 0, 1.0, 0, steps);
    int y = Utils.remapper(-dy, 0, 1.0, 0, steps);
    _xCoords += x;
    _yCoords -= y;

    if (_yCoords >= 180) {
      _yCoords = 180;
    }
    if (_yCoords <= 0) {
      _yCoords = 0;
    }

    if (_xCoords >= 180) {
      _xCoords = 180;
    }

    if (_xCoords <= 0) {
      _xCoords = 0;
    }
  }

  ///send earch angule that record captures to esp8266
  ///bug here. The first item doesnt have  a delay captured.
  void sendPackage(double dx, double dy) {
    _mapToServoRange(dx, dy);
    connectorService.sendPackage(_xCoords, _yCoords);
    if (isRecording.value) {
      final itemCoord = ItemCoord(_xCoords, _yCoords);
      tryAddToRecord(ItemModel(ItemRecordEnum.coord.index, itemCoord));
      if (lastSendPackage != null) {
        int delay = DateTime.now().difference(lastSendPackage!).inMilliseconds;
        final itemDelay = ItemDelay(delay);
        tryAddToRecord(ItemModel(ItemRecordEnum.delay.index, itemDelay));
      }
      lastSendPackage = DateTime.now();
    }
  }

  ///laser controllers
  void toggleLaser() {
    connectorService.toggleLaser(isLaserToggle ? 255 : 0);
    if (isRecording.value) {
      final itemLaser = ItemLaser(isLaserToggle ? 255 : 0);
      tryAddToRecord(ItemModel(ItemRecordEnum.laser.index, itemLaser));
    }
    isLaserToggle = !isLaserToggle;
  }

  void tryAddToRecord(ItemModel itemRecord) {
    if (connectorService.isConnected == false) {
      connectorService.setMessage("Connection lost. The record is paused.");
      isPause = true;
      return;
    }
    packages.add(itemRecord);
  }

  //future methods to record and playback laser moviments
  void _stopRecording() {
    RecordAddDialog(
      title: "Save as",
      packages: packages,
      onSave: (recordModel) async {
        final fileProvider = FileProvider();
        final name = recordModel.name;
        fileProvider.write("records/$name.json", recordModel.toJson());
        print("saving as $name.json");
        closeDialog();
      },
      onCancel: closeDialog,
      label: "Record name",
    ).showDialog();
  }

  void closeDialog() {
    isRecording.value = false;
    packages.clear();
    Get.back();
  }

  //start recording
  void _startRecording() {
    packages.clear();
    isRecording.value = true;
  }

  //toggle reconrding
  void toggleRecording() {
    if (isRecording.value) {
      _stopRecording();
      return;
    }
    _startRecording();
  }

  void clearFields() {
    isRecording.value = false;
    isPause = false;
    lastSendPackage = null;
  }
}
