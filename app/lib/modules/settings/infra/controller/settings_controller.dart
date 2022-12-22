import 'package:app_laser_cat/modules/settings/infra/provider/settings_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController {
  TextEditingController socketIp = TextEditingController();
  TextEditingController socketPort = TextEditingController();
  TextEditingController velocity = TextEditingController();
  TextEditingController timeout = TextEditingController();
  TextEditingController deliveryDelay = TextEditingController();
  SettingsPref? settings;

  @override
  void onInit() {
    super.onInit();
    settings = Get.find<SettingsPref>();
    socketIp.text = settings!.socketIp.val;
    socketPort.text = settings!.socketPort.val.toString();
    velocity.text = settings!.velocity.val.toString();
    timeout.text = settings!.timeout.val.toString();
    deliveryDelay.text = settings!.deliveryDelay.val.toString();
  }

  void saveSettings() {
    settings!.socketIp.val = socketIp.text;
    settings!.deliveryDelay.val = int.parse(deliveryDelay.text);
    settings!.socketPort.val = int.parse(socketPort.text);
    settings!.velocity.val = int.parse(velocity.text);
    settings!.timeout.val = int.parse(timeout.text);
    Get.back();
  }
}
