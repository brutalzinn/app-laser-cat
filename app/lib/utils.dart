import 'dart:io';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
// Thanks to this stack overflow user :)
// https://stackoverflow.com/questions/67835616/flutter-dart-scan-local-network-to-get-ip-and-hostname-of-connected-devices

Future<String?> scanEspAddress(int port) async {
  await (NetworkInfo().getWifiIP()).then(
    (ip) async {
      final String subnet = ip!.substring(0, ip.lastIndexOf('.'));
      for (var i = 0; i < 256; i++) {
        String ip = '$subnet.$i';

        var socket = WebSocketChannel.connect(Uri.parse('ws://$ip:$port'));
        socket.sink.add('hand');
        socket.stream.listen(
          (dynamic message) {
            print('message $message');
          },
          onDone: () {
            print('ws channel closed');
          },
          onError: (error) {
            print('ws error $error');
          },
        );
      }
    },
  );
}
