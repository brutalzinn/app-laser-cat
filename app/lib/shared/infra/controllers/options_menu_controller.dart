import 'package:app_laser_cat/shared/ui/widgets/custom_visibility.dart';
import 'package:get/get.dart';

class OptionsMenuController extends GetxController {
  Rx<List<CustomVisibility>> childList = Rx<List<CustomVisibility>>([]);
  Rx<bool> isExpanded = Rx<bool>(false);

  // OptionsMenuController() {
  //   print("create list with ${children.length} ${isExpanded.value}");
  //   isExpanded.value = false;
  //   childList.value = children;
  // }

  void createList(List<CustomVisibility> children) {
    print("LENGHT children:  ${children.length} EXPANDED: ${isExpanded.value}");
    childList.value = children;
    //isExpanded.value = false;
  }

  void setAllInvisible() {
    print("toggle all invisible ${isExpanded.value}");
    List<CustomVisibility> list = childList.value;
    childList.value = list.map((element) {
      element.visible = false;
      return element;
    }).toList();
    isExpanded.value = false;
  }

  void setAllVisible() {
    print("toggle all visible ${isExpanded.value}");
    List<CustomVisibility> list = childList.value;
    childList.value = list.map((element) {
      element.visible = true;
      return element;
    }).toList();

    isExpanded.value = true;
  }

  void toggleExpanded() {
    print(
        "toggle expanded ${isExpanded.value} LENGHT: ${childList.value.length}");
    if (isExpanded.value) {
      setAllInvisible();
      return;
    }
    setAllVisible();
  }

//   @override
//   void dispose() {
//     print("on dispose optins");
//     childList.value = [];
//     super.dispose();
//   }
// }
}
