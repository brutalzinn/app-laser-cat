import 'package:app_laser_cat/joystick_widget.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'utils.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const title = 'WebSocket Demo';
    return const MaterialApp(
      title: title,
      home: MyHomePage(
        title: title,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.title,
  });

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _controller = TextEditingController();
  WebSocketChannel? _channel;

  _MyHomePageState() {
    _channel = null;
    scanEspAddress(7777).then((value) {
      print("TESTE: " + value);
      _channel = WebSocketChannel.connect(Uri.parse('ws://$value:7777'));
    });
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
