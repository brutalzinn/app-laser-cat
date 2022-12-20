import 'dart:async';
import 'dart:io';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/web_socket_channel.dart';

// Thanks to this stack overflow user :)
// https://stackoverflow.com/questions/67835616/flutter-dart-scan-local-network-to-get-ip-and-hostname-of-connected-devices
typedef ScanDetails = void Function(String? value);

Future<void> scanEspAddress(int port, ScanDetails callBack) async {
  await (NetworkInfo().getWifiIP()).then(
    (ip) async {
      final String subnet = ip!.substring(0, ip.lastIndexOf('.'));
      for (var i = 0; i < 256; i++) {
        String ip = '$subnet.$i';
        String url = 'ws://$ip:$port';
        bool connectedToWebSocketServer = false;

        var webSocketChannel = WebSocketChannel.connect(Uri.parse(url));
        webSocketChannel.sink.add("hand");
        webSocketChannel.stream.listen((dynamic dataFromServer) {
          if (dataFromServer is List<int>) {
            if (connectedToWebSocketServer) {
              callBack(ip);
            }
          } // dataFromServer is List<int>
          else {
            if (dataFromServer == "shake") {
              connectedToWebSocketServer = true;
            }

            if (connectedToWebSocketServer) {
              callBack(ip);
            }
          }
          callBack(ip);
          print("encontrado ${ip}");
          webSocketChannel.sink.close();
        },
            cancelOnError: true,
            onDone: () => {
                  webSocketChannel.sink.close(),
                  connectedToWebSocketServer = false,
                },
            onError: (err) => {
                  webSocketChannel.sink.close(),
                  connectedToWebSocketServer = false,
                }); // web
      }
    },
  );
}
