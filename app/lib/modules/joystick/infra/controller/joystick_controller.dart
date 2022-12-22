import 'package:app_laser_cat/app_config.dart';
import 'package:app_laser_cat/modules/joystick/infra/models/coord_package.dart';
import 'package:app_laser_cat/modules/settings/infra/provider/settings_provider.dart';
import 'package:app_laser_cat/utils.dart';
import 'package:get/get.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class JoystickController extends GetxController {
  WebSocketChannel? _channel;
  bool isLaserToggle = false;
  bool isReconnect = false;
  int _xCoords = 0;
  int _yCoords = 0;

  final Rx<List<CoordPackage>> packages = Rx<List<CoordPackage>>([]);
  final Rx<String> lastResponse = Rx<String>("");
  Rx<bool> isRecording = Rx<bool>(false);
  SettingsPref settings = Get.find<SettingsPref>();

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

    _lastResponse("connected.");
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
      packages.value.add(CoordPackage(_xCoords, _yCoords));
    }
    _sendPackage(_xCoords, _yCoords);
  }

  ///laser controllers
  void toggleLaser() {
    _channel?.sink.add(isLaserToggle ? "LASER_ON" : "LASER_OFF");
    isLaserToggle = !isLaserToggle;
  }

  //private generic send package to esp 8266

  void _sendPackage(int x, int y) {
    _channel?.sink.add('$x,$y');
  }

  /// to add last esp response.
  void _lastResponse(String response) {
    lastResponse.value = response;
  }

  //future methods to record and playback laser moviments
  void _stopRecording() {
    isRecording.value = false;
  }

  //start recording
  void _startRecording() {
    packages.value.clear();
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
    for (var coords in packages.value) {
      _sendPackage(coords.x, coords.y);
      await Future.delayed(Duration(seconds: settings.deliveryDelay.val));
    }
  }
}
