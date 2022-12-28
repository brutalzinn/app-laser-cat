import 'package:app_laser_cat/modules/home/infra/binding/home_binding.dart';
import 'package:app_laser_cat/modules/home/ui/views/home_view.dart';
import 'package:app_laser_cat/modules/joystick/infra/binding/joystick_binding.dart';
import 'package:app_laser_cat/modules/joystick/ui/views/joystick_view.dart';
import 'package:app_laser_cat/modules/records/infra/binding/record_binding.dart';
import 'package:app_laser_cat/modules/records/ui/views/0_records_list_view.dart';
import 'package:app_laser_cat/modules/records/ui/views/1_record_view.dart';
import 'package:app_laser_cat/modules/settings/infra/binding/settings_binding.dart';
import 'package:app_laser_cat/shared/infra/provider/settings_provider.dart';
import 'package:app_laser_cat/modules/settings/ui/views/settings_view.dart';
import 'package:app_laser_cat/shared/infra/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'shared/infra/bindings/global_binding.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  Future<void> initialConfig() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.storage,
    ].request();
    await Get.putAsync(() => SettingsPref().init());
  }

  WidgetsFlutterBinding.ensureInitialized();
  await initialConfig();
  GlobalBinding().dependencies();
  runApp(GetMaterialApp(
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
      GetPage(
          name: SharedRoutes.RecordListRoute,
          page: () => RecordListView(),
          binding: RecordBinding()),
      GetPage(
          name: SharedRoutes.RecordViewRoute,
          page: () => RecordView(),
          binding: RecordBinding()),
    ],
  ));
}
