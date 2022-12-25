import 'package:app_laser_cat/shared/infra/controllers/options_menu_controller.dart';
import 'package:get/get.dart';

class GlobalBinding implements Bindings {
  @override
  void dependencies() {
    // Get.lazyPut(() => OptionsMenuController());
  }
}
