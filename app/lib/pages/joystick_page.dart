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

  _JoystickPageState() {
    _channel = WebSocketChannel.connect(
        Uri.parse('ws://${AppConfig.socketIp}:${AppConfig.port}'));
    print('URL: ws://${AppConfig.socketIp}:${AppConfig.port}');
  }

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
            print('${foo.x} ${foo.y}');
            _channel?.sink.add('${foo.x},${foo.y}');
          }),
          child: Column(
            children: [
              TextButton(
                  onPressed: _toggleLaser, child: const Text("LASER ON")),
              Form(
                child: TextFormField(
                  controller: _controller,
                  decoration:
                      const InputDecoration(labelText: 'Send a message'),
                ),
              ),
              StreamBuilder(
                stream: _channel?.stream,
                builder: (context, snapshot) {
                  return Text(snapshot.hasData ? '${snapshot.data}' : '');
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
    _channel?.sink.add(_controller.text);
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
