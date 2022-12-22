import 'package:app_laser_cat/modules/home/infra/binding/home_binding.dart';
import 'package:app_laser_cat/modules/home/ui/views/home_view.dart';
import 'package:app_laser_cat/modules/joystick/infra/binding/joystick_binding.dart';
import 'package:app_laser_cat/modules/joystick/ui/views/joystick_view.dart';
import 'package:app_laser_cat/modules/settings/infra/binding/settings_binding.dart';
import 'package:app_laser_cat/modules/settings/infra/provider/settings_provider.dart';
import 'package:app_laser_cat/modules/settings/ui/views/settings_view.dart';
import 'package:app_laser_cat/shared/infra/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'shared/infra/bindings/global_binding.dart';

void main() async {
  Future<void> initialConfig() async {
    await Get.putAsync(() => SettingsPref().init());
  }

  WidgetsFlutterBinding.ensureInitialized();
  // GlobalBinding().dependencies();
  await initialConfig();
  runApp(GetMaterialApp(
    initialBinding: GlobalBinding(),
    initialRoute: SharedRoutes.HomeRoute,
    getPages: [
      GetPage(
          name: SharedRoutes.HomeRoute,
          page: () => HomeView(),
          binding: HomeBinding()),
      GetPage(
          name: SharedRoutes.JoystickHomeRoute,
          page: () => JoystickView(),
          binding: JoystickBinding()),
      GetPage(
          name: SharedRoutes.SettingsRoute,
          page: () => SettingsView(),
          binding: SettingsBinding()),
    ],
  ));
}
