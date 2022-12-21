import 'package:app_laser_cat/modules/joystick/infra/controller/joystick_controller.dart';
import 'package:get/get.dart';

class JoystickBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => JoystickController());
  }
}
