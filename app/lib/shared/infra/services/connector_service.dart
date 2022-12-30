import 'package:app_laser_cat/shared/infra/provider/settings_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ConnectorService extends GetxService {
  Rx<String> statusMessage = Rx<String>("");
  bool isReconnect = false;
  SettingsPref settings = Get.find<SettingsPref>();
  WebSocketChannel? _channel;

  ///connect to esp 8266 and listen events. Call reconect if wrongs things happen.
  void connectESP() {
    _setStatus("Connecting..");
    _channel = WebSocketChannel.connect(
        Uri.parse('ws://${settings.socketIp.val}:${settings.socketPort.val}'));
    _channel!.stream.listen((streamData) {
      _setStatus(streamData);
      isReconnect = false;
    }, onDone: () {
      _setStatus("Oh no. ESP 8266 not responds hand shake :(");
      isReconnect = true;
      reconnect();
    }, onError: (e) {
      _setStatus("Oh no. ESP 8266 still not responds hand shake :(");
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
      _setStatus("trying to connect again... ");
      connectESP();
    });
  }

  void disconnect() {
    _setStatus("Disconnected");
    _channel?.sink.close();
    isReconnect = false;
    Get.delete<GetxService>(force: true);
  }

  void _toggleLaser(int power) {
    _channel?.sink.add("LASER_$power");
  }

  ///private generic send package to esp 8266
  void _sendPackage(int x, int y) {
    _channel?.sink.add('$x,$y');
  }

  void sendPackage(int dxMapped, int dyMapped, [VoidCallback? afterAction]) {
    _sendPackage(dxMapped, dyMapped);
    afterAction!();
  }

  void toggleLaser(int power, [VoidCallback? afterAction]) {
    _toggleLaser(power);
    afterAction!();
  }

  void _setStatus(String response) {
    statusMessage.value = response;
  }
}
