import 'package:app_laser_cat/modules/settings/infra/controller/settings_controller.dart';
import 'package:app_laser_cat/modules/settings/infra/provider/settings_provider.dart';
import 'package:get/get.dart';

class SettingsBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(SettingsController());
  }
}
