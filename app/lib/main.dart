import 'package:app_laser_cat/modules/home/ui/views/home_view.dart';
import 'package:app_laser_cat/modules/joystick/ui/views/joystick_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'shared/infra/global_binding.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GlobalBinding().dependencies();
  runApp(GetMaterialApp(
    initialRoute: '/',
    getPages: [
      GetPage(name: '/', page: () => HomeView()),
      GetPage(name: '/joystick', page: () => JoystickView()),
    ],
  ));
}
