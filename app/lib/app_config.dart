import 'package:flutter/material.dart';

class AppConfig {
  // static String socketIp = "localhost";
  // static int port = 7777;
  static String appVersion = "1.0.0";
  static String appName = "Laser Cat";
  static bool devMode = true;
  static String recordsDir = 'records';
  static String get appTitle => "$appName V${appVersion}";

  static Color primaryColor = Colors.black;
  static Color secondaryColor = Colors.white;
}
