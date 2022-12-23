import 'package:app_laser_cat/modules/records/infra/controller/record_controller.dart';
import 'package:get/get.dart';

class RecordBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(RecordController());
  }
}
