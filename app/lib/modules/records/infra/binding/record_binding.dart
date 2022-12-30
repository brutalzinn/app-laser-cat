import 'package:app_laser_cat/modules/joystick/infra/controller/joystick_controller.dart';
import 'package:app_laser_cat/modules/records/infra/controller/record_controller.dart';
import 'package:app_laser_cat/shared/infra/services/connector_service.dart';
import 'package:get/get.dart';

class RecordBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(ConnectorService());
    Get.put(JoystickController());
    Get.put(RecordController());
  }
}
