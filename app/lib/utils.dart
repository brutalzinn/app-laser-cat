import 'dart:io';
import 'package:network_info_plus/network_info_plus.dart';
// Thanks to this stack overflow user :)
// https://stackoverflow.com/questions/67835616/flutter-dart-scan-local-network-to-get-ip-and-hostname-of-connected-devices

Future<String> scanEspAddress(int port) async {
  await (NetworkInfo().getWifiIP()).then(
    (ip) async {
      final String subnet = ip!.substring(0, ip.lastIndexOf('.'));
      for (var i = 0; i < 256; i++) {
        String ip = '$subnet.$i';
        await Socket.connect(ip, port, timeout: Duration(milliseconds: 50))
            .then((socket) async {
          await InternetAddress(socket.address.address).reverse().then((value) {
            // print(value.host);
            // print(socket.address.address);
            return value.host;
          }).catchError((error) {
            throw Exception("esp 8266 not found.");
            // print(socket.address.address);
            // print('Error: $error');
          });
          socket.destroy();
        }).catchError((error) => null);
      }
    },
  );
  return "";
}
