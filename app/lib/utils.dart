import 'dart:async';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;

// Thanks to this stack overflow user :)
// https://stackoverflow.com/questions/67835616/flutter-dart-scan-local-network-to-get-ip-and-hostname-of-connected-devices

Future<String?> scanEspAddress(int port) async {
  await (NetworkInfo().getWifiIP()).then(
    (ip) async {
      final String subnet = ip!.substring(0, ip.lastIndexOf('.'));
      String? ipFound = "localhost";
      for (var i = 0; i < 256; i++) {
        String ip = '$subnet.$i';
        var channel = IOWebSocketChannel.connect(Uri.parse('ws://$ip:$port'));
        channel.stream.listen((message) {
          channel.sink.add('hand');
          print("message ${message}");
          channel.sink.close(status.goingAway);
        });
        //await Future.delayed(Duration(milliseconds: 50));
      }
      return ipFound;
    },
  );
}
