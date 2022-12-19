import 'package:app_laser_cat/pages/joystick_page.dart';
import 'package:flutter/material.dart';

import 'pages/home_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(title: 'Web Socket connector'),
        '/joystick': (context) => JoystickPage(title: 'Laser Controller'),
      },
    );
  }
}
