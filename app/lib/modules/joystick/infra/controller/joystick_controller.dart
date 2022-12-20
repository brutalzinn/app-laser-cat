import 'package:app_laser_cat/app_config.dart';
import 'package:app_laser_cat/modules/joystick/infra/models/coord_package.dart';
import 'package:app_laser_cat/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class JoystickController extends GetxController {
  final TextEditingController _controller = TextEditingController();
  final Rx<List<CoordPackage>> packages = Rx<List<CoordPackage>>([]);
  final Rx<List<String>> responses = Rx<List<String>>([]);

  WebSocketChannel? _channel;
  bool isLaserToggle = false;
  bool isReconnect = false;
  bool isRecording = false;
  int _xCoords = 0;
  int _yCoords = 0;

  void connectESP() {
    _channel = WebSocketChannel.connect(
        Uri.parse('ws://${AppConfig.socketIp}:${AppConfig.port}'));
    _channel!.stream.listen((streamData) {
      responses.value.add(streamData);
      isReconnect = false;
    }, onDone: () {
      isReconnect = true;
      reconnect();
    }, onError: (e) {
      isReconnect = true;
      reconnect();
    }, cancelOnError: true);

    print("connected.");
  }

  void reconnect() {
    if (isReconnect == false) {
      return;
    }
    Future.delayed(const Duration(seconds: 3)).then((_) {
      print("trying to connect again... ");
      connectESP();
    });
  }

  void initConnection() async {
    print("trying to connect...");
    print('URL: ws://${AppConfig.socketIp}:${AppConfig.port}');
    connectESP();
  }

  void sendPackage(double dx, double dy) {
    int x = Utils.remapper(-dx, 0, 1.0, 0, 25);
    int y = Utils.remapper(-dy, 0, 1.0, 0, 25);
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

    _sendPackage(_xCoords, _yCoords);

    if (isRecording) {
      packages.value.add(CoordPackage(x, y));
    }
  }

  void stopRecording() {
    isRecording = false;
  }

  void startRecording() {
    isRecording = true;
  }

  void playRecording() {
    for (var coords in packages.value) {
      _sendPackage(coords.x, coords.y);
    }
  }

  void toggleLaser() {
    _channel?.sink.add(isLaserToggle ? "LASER_ON" : "LASER_OFF");
    isLaserToggle = !isLaserToggle;
  }

  void _sendPackage(int x, int y) {
    _channel?.sink.add('$x,$y');
  }
}
