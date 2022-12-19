import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../app_config.dart';
import '../utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void connect() {
    print("try to find esp 8266");
    scanEspAddress(AppConfig.port).then((value) {
      print(value);
      if (value != null) {
        AppConfig.socketIp = value;
        Navigator.pushNamed(context, '/joystick');
      } else {
        print("esp 8266 not found on this network");
      }
    });
  }

  _HomePageState() {
    connect();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Padding(
            padding: EdgeInsets.all(20.0),
            child: Center(
                child: Column(
              children: [
                const Text(
                  "Conectando...",
                  style: TextStyle(fontSize: 25),
                ),
                TextButton(onPressed: connect, child: Text('Conectar'))
              ],
            ))));
  }
}
