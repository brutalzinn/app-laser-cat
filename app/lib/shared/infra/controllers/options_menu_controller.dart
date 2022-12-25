import 'package:app_laser_cat/shared/ui/widgets/custom_visibility.dart';
import 'package:get/get.dart';

class OptionsMenuController extends GetxController {
  Rx<List<CustomVisibility>> childList = Rx<List<CustomVisibility>>([]);
  Rx<bool> isExpanded = Rx<bool>(false);

  @override
  void onInit() {}

  void updateList(List<CustomVisibility> children) {
    isExpanded.value = false;
    childList.value = children;
  }

  void setAllInvisible() {
    List<CustomVisibility> list = childList.value;
    childList.value = list.map((element) {
      element.visible = false;
      return element;
    }).toList();
    isExpanded.value = false;
  }

  void setAllVisible() {
    List<CustomVisibility> list = childList.value;
    childList.value = list.map((element) {
      element.visible = true;
      return element;
    }).toList();
    isExpanded.value = true;
  }

  void toggleExpanded() {
    if (isExpanded.value) {
      setAllInvisible();
      return;
    }
    setAllVisible();
  }
}
