import 'package:app_laser_cat/shared/ui/widgets/custom_visibility.dart';
import 'package:get/get.dart';

class OptionsMenuController extends GetxController {
  RxList<CustomVisibility> childrenList = RxList<CustomVisibility>([]);
  List<CustomVisibility> tempList = [];
  RxBool isExpanded = RxBool(false);
  static String getBuilderKey = "custom_scatfold";

  ///OH MY GOD. THREE DAYS AND STILL ZERO ACCIDENTS HERE.
  /// WE STILL THINKS THAT WE NEED A GLOBAL WIDGET THAT HANDLE STATE THAT HIDDE AND SHOW ICON BUTTONS ON SCATFOLD.
  /// IF WE REALLY NEEDS THIS, WHY DONT USE ACTUALLY WIDGETS THAT DO THIS? OH MY GOD!
  OptionsMenuController(List<CustomVisibility> children) {
    updateWidgetList(children);
    print("LENGHT children:  ${children.length} EXPANDED: ${isExpanded.value}");
  }

  void updateWidgetList(List<CustomVisibility> children) {
    tempList = children;
  }

  void setAllInvisible() {
    isExpanded.value = false;
    childrenList.clear();
    print("all visible false");
    for (var e in tempList) {
      childrenList.add(CustomVisibility(visible: false, child: e.child));
    }
    update([getBuilderKey]);
  }

  void setAllVisible() {
    isExpanded.value = true;
    childrenList.clear();
    print("all visible true");
    for (var e in tempList) {
      childrenList.add(CustomVisibility(visible: true, child: e.child));
    }
    update([getBuilderKey]);
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
  //   print("on dispose optins");
  //   childrenList.clear();
  //   super.dispose();
  // }
}
