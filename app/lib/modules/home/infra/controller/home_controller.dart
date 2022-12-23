import 'dart:async';

import 'package:app_laser_cat/app_config.dart';
import 'package:app_laser_cat/shared/infra/provider/settings_provider.dart';
import 'package:app_laser_cat/shared/infra/routes/routes.dart';
import 'package:app_laser_cat/utils.dart';
import 'package:get/get.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

// Thanks to this stack overflow user :)
// https://stackoverflow.com/questions/67835616/flutter-dart-scan-local-network-to-get-ip-and-hostname-of-connected-devices
typedef ScanDetails = void Function(String? value);

class HomeController extends GetxController {
  SettingsPref settings = Get.find<SettingsPref>();

  @override
  void onInit() {
    //connect();
  }

  void connect() {
    print("try to find esp 8266");
    if (settings.autoReconnect.val == false) {
      print(
          "trying to connect with ${settings.socketIp.val}:${settings.socketPort.val}");
      return;
    }
    int attemps = 0;
    int maxAttemps = settings.autoReconnectAttempts.val;
    Timer.periodic(Duration(seconds: settings.autoReconnectInterval.val),
        (timer) {
      //print("try to find esp 8266, attemp of ${attemps}/${maxAttemps}");
      scanEspAddress(settings.socketPort.val, (value) {
        settings.socketIp.val = value!;
        timer.cancel();
        Get.toNamed(SharedRoutes.JoystickHomeRoute);
      });
      if (attemps >= maxAttemps) {
        print("cancel timer because max attemps catch.");
        timer.cancel();
      }
      attemps++;
    });
  }

  String getAutoConnectStatus() {
    return settings.autoReconnect.val
        ? "Connecting..."
        : "Auto connection is off";
  }

  Future<void> scanEspAddress(int port, ScanDetails callBack) async {
    await (NetworkInfo().getWifiIP()).then(
      (ip) async {
        final String subnet = ip!.substring(0, ip.lastIndexOf('.'));
        for (var i = 0; i < 256; i++) {
          String ip = '$subnet.$i';
          String url = 'ws://$ip:$port';
          var webSocketChannel = WebSocketChannel.connect(Uri.parse(url));
          webSocketChannel.sink.add("hand");
          webSocketChannel.stream.listen((dynamic dataFromServer) {
            callBack(ip);
            webSocketChannel.sink.close();
          },
              cancelOnError: true,
              onDone: () => {
                    webSocketChannel.sink.close(),
                  },
              onError: (err) => {
                    webSocketChannel.sink.close(),
                  }); // web
        }
      },
    );
  }
}
