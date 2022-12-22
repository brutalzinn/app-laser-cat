import 'package:app_laser_cat/shared/infra/provider/settings_provider.dart';
import 'package:get/get.dart';

class GlobalBinding implements Bindings {
  @override
  void dependencies() {
    // Get.lazyPut(() => SettingsPref(), fenix: true);
  }
}
