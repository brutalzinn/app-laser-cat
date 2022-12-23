import 'package:app_laser_cat/modules/home/ui/views/home_view.dart';
import 'package:app_laser_cat/shared/infra/provider/settings_provider.dart';
import 'package:app_laser_cat/shared/infra/routes/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController {
  TextEditingController socketIp = TextEditingController();
  TextEditingController socketPort = TextEditingController();
  TextEditingController velocity = TextEditingController();
  TextEditingController timeout = TextEditingController();
  TextEditingController autoReconnectInterval = TextEditingController();
  TextEditingController deliveryDelay = TextEditingController();
  Rx<bool> isAutoReconnect = Rx<bool>(true);
  SettingsPref settings = Get.find<SettingsPref>();

  @override
  void onInit() {
    super.onInit();
    loadSettings();
  }

  void loadSettings() {
    socketIp.text = settings.socketIp.val;
    socketPort.text = settings.socketPort.val.toString();
    velocity.text = settings.velocity.val.toStringAsFixed(2);
    timeout.text = settings.timeout.val.toString();
    deliveryDelay.text = settings.deliveryDelay.val.toString();
    autoReconnectInterval.text = settings.autoReconnectInterval.val.toString();

    ///states
    isAutoReconnect.value = settings.autoReconnect.val;
  }

  void saveSettings() {
    settings.socketIp.val = socketIp.text;
    settings.deliveryDelay.val = int.parse(deliveryDelay.text);
    settings.socketPort.val = int.parse(socketPort.text);
    settings.velocity.val = double.parse(velocity.text);
    settings.timeout.val = int.parse(timeout.text);
    settings.autoReconnectInterval.val = int.parse(autoReconnectInterval.text);
    settings.autoReconnect.val = isAutoReconnect.value;
    // Get.to(() => HomeView());
    Get.toNamed(SharedRoutes.HomeRoute);
  }

  void cancelSettings() {
    // Get.to(() => HomeView());
    Get.toNamed(SharedRoutes.HomeRoute);
  }

  void onChangeAutoReconnect(bool enabled) {
    isAutoReconnect.value = enabled;
  }
}
