import 'package:app_laser_cat/modules/settings/infra/provider/settings_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController {
  TextEditingController socketIp = TextEditingController();
  TextEditingController socketPort = TextEditingController();
  TextEditingController velocity = TextEditingController();
  TextEditingController timeout = TextEditingController();
  TextEditingController deliveryDelay = TextEditingController();

  void saveSettings() {
    final settings = Get.find<SettingsPref>();
    settings.deliveryDelay = deliveryDelay.text as int;
    settings.socketIp = socketIp.text;
    settings.socketPort = socketPort.text as int;
    settings.velocity = velocity.text as int;
    settings.timeout = timeout.text as int;
  }
}
