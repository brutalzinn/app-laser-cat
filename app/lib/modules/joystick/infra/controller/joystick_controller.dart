import 'package:app_laser_cat/modules/records/infra/models/enums/item_record_enum.dart';
import 'package:app_laser_cat/modules/records/infra/models/enums/record_types_enum.dart';
import 'package:app_laser_cat/modules/records/infra/models/item_model.dart';
import 'package:app_laser_cat/modules/records/infra/models/record_model.dart';
import 'package:app_laser_cat/modules/records/infra/models/records/itens/item_coords.dart';
import 'package:app_laser_cat/modules/records/infra/models/records/itens/item_delay.dart';
import 'package:app_laser_cat/modules/records/infra/models/records/itens/item_laser.dart';
import 'package:app_laser_cat/modules/records/infra/models/records/record_options.dart';
import 'package:app_laser_cat/shared/infra/provider/file_provider.dart';
import 'package:app_laser_cat/shared/infra/provider/settings_provider.dart';
import 'package:app_laser_cat/shared/ui/dialogs/textfield_dialog.dart';
import 'package:app_laser_cat/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class JoystickController extends GetxController {
  WebSocketChannel? _channel;
  bool isLaserToggle = false;
  bool isReconnect = false;
  int _xCoords = 0;
  int _yCoords = 0;

  List<ItemModel> packages = [];
  final Rx<String> lastResponse = Rx<String>("");
  Rx<bool> isRecording = Rx<bool>(false);
  SettingsPref settings = Get.find<SettingsPref>();
  TextEditingController recordName = TextEditingController();
  DateTime? lastSendPackage;

  ///init this instance
  @override
  void onInit() {
    initConnection();
  }

  ///connect to esp 8266 and listen events. Call reconect if wrongs things happen.
  void connectESP() {
    _lastResponse("Connecting..");
    _channel = WebSocketChannel.connect(
        Uri.parse('ws://${settings.socketIp.val}:${settings.socketPort.val}'));
    _channel!.stream.listen((streamData) {
      lastResponse.value = streamData;
      isReconnect = false;
    }, onDone: () {
      _lastResponse("Oh no. ESP 8266 not responds hand shake :(");
      isReconnect = true;
      reconnect();
    }, onError: (e) {
      _lastResponse("Oh no. ESP 8266 still not responds hand shake :(");
      isReconnect = true;
      reconnect();
    }, cancelOnError: true);
  }

  ///auto reconnect
  void reconnect() {
    if (isReconnect == false) {
      return;
    }
    Future.delayed(Duration(seconds: settings.timeout.val)).then((_) {
      _lastResponse("trying to connect again... ");
      connectESP();
    });
  }

  ///init connection with esp8266
  void initConnection() async {
    _lastResponse("trying to connect...");
    clearFields();
    connectESP();
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
  void sendPackage(double dx, double dy) {
    _mapToServoRange(dx, dy);
    if (isRecording.value) {
      final itemCoord = ItemCoord(_xCoords, _yCoords);
      packages.add(ItemModel(ItemRecordEnum.coord.index, itemCoord));
      if (lastSendPackage != null) {
        int delay = DateTime.now().difference(lastSendPackage!).inMilliseconds;
        final itemDelay = ItemDelay(delay);
        packages.add(ItemModel(ItemRecordEnum.delay.index, itemDelay));
      }
      lastSendPackage = DateTime.now();
    }
    _sendPackage(_xCoords, _yCoords);
  }

  ///laser controllers
  void toggleLaser() {
    if (isRecording.value) {
      final itemLaser = ItemLaser(isLaserToggle ? 255 : 0);
      packages.add(ItemModel(ItemRecordEnum.laser.index, itemLaser));
    }
    _channel?.sink.add(isLaserToggle ? "LASER_ON" : "LASER_OFF");
    isLaserToggle = !isLaserToggle;
  }

  void _toggleLaser(int power) {
    _channel?.sink.add("LASER_${power}");
  }

  ///private generic send package to esp 8266
  void _sendPackage(int x, int y) {
    _channel?.sink.add('$x,$y');
  }

  /// to add last esp response.
  void _lastResponse(String response) {
    lastResponse.value = response;
  }

  //future methods to record and playback laser moviments
  void _stopRecording() {
    TextFieldDialog(
            title: "Save as",
            onSave: () async {
              final fileProvider = FileProvider();
              final name = recordName.text.toLowerCase();
              final options =
                  RecordOptions(recordType: RecordTypeEnum.none.index);
              final mapper = RecordModel(name, packages, options);
              fileProvider.write("records/${name}.json", mapper.toJson());
              print("saving as ${name}.json");
              Get.back();
            },
            onCancel: () => Get.back(),
            label: "File name",
            controller: recordName)
        .showDialog();
    isRecording.value = false;
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

  //play recording
  Future<void> playRecording() async {
    print("play reconrding");
    for (var item in packages) {
      if (item.type == ItemRecordEnum.coord.index) {
        final itemCoord = ItemCoord.fromMap(item.object);
        _sendPackage(itemCoord.x, itemCoord.y);
      }
      if (item.type == ItemRecordEnum.delay.index) {
        final itemDelay = ItemDelay.fromMap(item.object);
        await Future.delayed(Duration(milliseconds: itemDelay.value));
      }
      if (item.type == ItemRecordEnum.laser.index) {
        final itemLaser = ItemLaser.fromMap(item.object);
        _toggleLaser(itemLaser.value);
      }
    }
  }

  //temporary method. needs be moved to record controller
  void addRecord() {
    final fileProvider = FileProvider();
    String name = recordName.text.toLowerCase();
    final options = RecordOptions(recordType: RecordTypeEnum.none.index);
    final mapper = RecordModel(name, packages, options);
    fileProvider.write("records/${name}.json", mapper.toJson());
    print("saving as ${name}.json");
    Get.back();
  }

  void clearFields() {
    isRecording.value = false;
    lastSendPackage = null;
  }
}
