import 'package:app_laser_cat/shared/ui/widgets/custom_visibility.dart';
import 'package:get/get.dart';

class OptionsMenuController extends GetxController {
  Rx<List<CustomVisibility>> childVisible = Rx<List<CustomVisibility>>([]);
  Rx<bool> isExpanded = Rx<bool>(false);
  void onExpand() {}

  void updateList(List<CustomVisibility> children) {
    childVisible.value = children;
  }

  void setUnexpanded() {
    List<CustomVisibility> list = childVisible.value;
    childVisible.value = list.map((element) {
      element.visible = false;
      return element;
    }).toList();
    isExpanded.value = false;
  }

  void setExpanded() {
    List<CustomVisibility> list = childVisible.value;
    childVisible.value = list.map((element) {
      element.visible = true;
      return element;
    }).toList();
    isExpanded.value = true;
  }

  void toggleExpanded() {
    if (isExpanded.value) {
      setUnexpanded();
      return;
    }
    setExpanded();
  }
}
