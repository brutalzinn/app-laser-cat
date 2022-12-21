import 'package:app_laser_cat/modules/settings/infra/provider/settings_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController {
  TextEditingController socketIp = TextEditingController();
  TextEditingController socketPort = TextEditingController();
  TextEditingController velocity = TextEditingController();
  TextEditingController timeout = TextEditingController();
  TextEditingController deliveryDelay = TextEditingController();

  @override
  onInit() {
    final settings = Get.find<SettingsPref>();
    socketIp.text = settings.socketIp;
    socketPort.text = settings.socketPort.toString();
    velocity.text = settings.velocity.toString();
    timeout.text = settings.timeout.toString();
    deliveryDelay.text = settings.deliveryDelay.toString();
  }

  void saveSettings() {
    final settings = Get.find<SettingsPref>();
    settings.socketIp = socketIp.text;
    settings.deliveryDelay = int.parse(deliveryDelay.text);
    settings.socketPort = int.parse(socketPort.text);
    settings.velocity = int.parse(velocity.text);
    settings.timeout = int.parse(timeout.text);
  }
}
