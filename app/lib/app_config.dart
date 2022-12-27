import 'package:app_laser_cat/shared/infra/routes/routes.dart';
import 'package:app_laser_cat/shared/ui/widgets/custom_floating_action_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'shared/ui/widgets/custom_visibility.dart';

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

  static List<CustomVisibility> get getDefaultNavigationActions {
    return [
      CustomVisibility(
        child: CustomFloatingActionButton(
            tooltip: "Joystick test",
            onPressed: () => Get.toNamed(SharedRoutes.JoystickHomeRoute),
            child: const Icon(Icons.gamepad)),
      ),
      CustomVisibility(
        child: CustomFloatingActionButton(
            tooltip: "Records",
            onPressed: () =>
                Get.toNamed(SharedRoutes.RecordRoute, preventDuplicates: false),
            child: const Icon(Icons.receipt_rounded)),
      ),
      CustomVisibility(
          child: CustomFloatingActionButton(
              tooltip: "Settings",
              onPressed: () => Get.toNamed(SharedRoutes.SettingsRoute),
              child: const Icon(Icons.settings))),
    ];
  }
}
