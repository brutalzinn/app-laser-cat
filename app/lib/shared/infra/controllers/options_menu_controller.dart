import 'package:app_laser_cat/shared/ui/widgets/custom_visibility.dart';
import 'package:get/get.dart';

class OptionsMenuController extends GetxController {
  RxList<CustomVisibility> childrenList = RxList<CustomVisibility>([]);
  RxBool isExpanded = RxBool(false);
  static String getBuilderKey = "custom_scatfold";

  ///OH MY GOD. THREE DAYS AND STILL ZERO ACCIDENTS HERE.
  /// WE STILL THINKS THAT WE NEED A GLOBAL WIDGET THAT HANDLE STATE THAT HIDDE AND SHOW ICON BUTTONS ON SCATFOLD.
  /// IF WE REALLY NEEDS THIS, WHY DONT USE ACTUALLY WIDGETS THAT DO THIS? OH MY GOD!
  OptionsMenuController(List<CustomVisibility> children) {
    updateWidgetList(children);
  }

  void updateWidgetList(List<CustomVisibility> children) {
    print("update widget ${children.length} - ${isExpanded.value}");
    childrenList.value = children;
    //refreshAll();
  }

  void setAllInvisible() {
    for (var e in childrenList) {
      var index = childrenList.indexOf(e);
      childrenList[index].visible = false;
    }
    isExpanded.value = false;
  }

  void setAllVisible() {
    for (var e in childrenList) {
      var index = childrenList.indexOf(e);
      childrenList[index].visible = true;
    }
    isExpanded.value = true;
  }

  void toggleExpanded() {
    if (isExpanded.value) {
      setAllInvisible();
      refreshAll();
      return;
    }
    setAllVisible();
    refreshAll();
  }

  void refreshAll() {
    update([getBuilderKey]);
  }
}
