import 'package:app_laser_cat/shared/ui/widgets/custom_visibility.dart';
import 'package:get/get.dart';

class OptionsMenuController extends GetxController {
  Rx<List<CustomVisibility>> childList = Rx<List<CustomVisibility>>([]);
  Rx<bool> isExpanded = Rx<bool>(false);

  void updateList(List<CustomVisibility> children) {
    childList.value = children;
  }

  void setAllInvisible() {
    isExpanded.value = false;
    List<CustomVisibility> list = childList.value;
    childList.value = list.map((element) {
      element.visible = false;
      return element;
    }).toList();
  }

  void setAllVisible() {
    isExpanded.value = true;
    List<CustomVisibility> list = childList.value;
    childList.value = list.map((element) {
      element.visible = true;
      return element;
    }).toList();
  }

  void toggleExpanded() {
    if (isExpanded.value) {
      setAllInvisible();
      return;
    }
    setAllVisible();
  }

  // @override
  // void dispose() {
  //   setAllInvisible();
  //   Get.delete<OptionsMenuController>();
  //   super.dispose();
  // }
}
