import 'package:app_laser_cat/modules/settings/infra/provider/settings_provider.dart';
import 'package:get/get.dart';

class GlobalBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(() => SettingsPref());
  }
}
