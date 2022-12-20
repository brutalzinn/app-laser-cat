import 'dart:async';

import 'package:app_laser_cat/app_config.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../joystick_widget.dart';

class JoystickPage extends StatefulWidget {
  const JoystickPage({
    super.key,
    required this.title,
  });

  final String title;

  @override
  State<JoystickPage> createState() => _JoystickPageState();
}

class _JoystickPageState extends State<JoystickPage> {
  final TextEditingController _controller = TextEditingController();
  WebSocketChannel? _channel;
  bool toggleLaser = false;
  bool isReconnect = false;
  int xCoords = 0;
  int yCoords = 0;
  StreamController<String> streamController =
      StreamController.broadcast(sync: true);

  void connectESP() {
    _channel = WebSocketChannel.connect(
        Uri.parse('ws://${AppConfig.socketIp}:${AppConfig.port}'));
    _channel!.stream.listen((streamData) {
      isReconnect = false;
      streamController.add(streamData);
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
    Future.delayed(const Duration(seconds: 1)).then((_) {
      print("trying to connect again... ");
      connectESP();
    });
  }

  void initConnection() async {
    print("trying to connect...");
    print('URL: ws://${AppConfig.socketIp}:${AppConfig.port}');
    connectESP();
  }

  _JoystickPageState() {
    initConnection();
    xCoords = 0;
    yCoords = 0;
  }

  int map(double value, double fromStart, double fromEnd, double toStart,
          double toEnd) =>
      ((value - fromStart) * (toEnd - toStart) ~/ (fromEnd - fromStart) +
              toStart)
          .round();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: JoystickWidget(
          callBack: ((foo) {
            int x = map(-foo.x, 0, 1.0, 0, 25);
            int y = map(-foo.y, 0, 1.0, 0, 25);
            xCoords += x;
            yCoords -= y;

            if (yCoords >= 180) {
              yCoords = 180;
            }
            if (yCoords <= 0) {
              yCoords = 0;
            }

            if (xCoords >= 180) {
              xCoords = 180;
            }

            if (xCoords <= 0) {
              xCoords = 0;
            }
            print('SEND: $xCoords,$yCoords');
            _channel?.sink.add('$xCoords,$yCoords');

            print('ok');
          }),
          onDragEnd: () {
            // print('SEND: $xCoords,$yCoords');
            // _channel!.sink.add('$xCoords,$yCoords');
            // print('ok');
          },
          child: Column(
            children: [
              TextButton(
                  onPressed: _toggleLaser, child: const Text("TOGGLE LASER")),
              Form(
                child: TextFormField(
                  controller: _controller,
                  decoration:
                      const InputDecoration(labelText: 'Send a message'),
                ),
              ),
              StreamBuilder(
                stream: streamController.stream,
                builder: (context, snapshot) {
                  return Text(
                      snapshot.hasData ? 'RECEIVE: ${snapshot.data}' : '');
                },
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _sendMessage,
        tooltip: 'Send message',
        child: const Icon(Icons.send),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _toggleLaser() {
    _channel?.sink.add(toggleLaser ? "LASER_ON" : "LASER_OFF");
    toggleLaser = !toggleLaser;
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      _channel?.sink.add(_controller.text);
    }
  }

  @override
  void dispose() {
    _channel?.sink.close();
    _controller.dispose();
    super.dispose();
  }
}
