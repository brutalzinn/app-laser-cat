// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:app_laser_cat/app_config.dart';
import 'package:app_laser_cat/shared/infra/controllers/options_menu_controller.dart';
import 'package:app_laser_cat/shared/infra/routes/routes.dart';
import 'package:app_laser_cat/shared/ui/widgets/custom_floating_action_button.dart';
import 'package:app_laser_cat/shared/ui/widgets/custom_visibility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomScaffold extends StatelessWidget {
  OptionsMenuController controller = Get.find<OptionsMenuController>();
  final Widget child;
  String? title;
  VoidCallback? onWidgetBuild;
  List<CustomVisibility>? children;
  bool defaultNavigationMenu;
  bool lastPage;
  bool _useNavigationOptions = false;

  CustomScaffold({
    super.key,
    required this.child,
    this.title,
    this.onWidgetBuild,
    this.children,
    this.defaultNavigationMenu = false,
    this.lastPage = false,
  }) {
    bool isWidgetBuild = onWidgetBuild != null;
    _useNavigationOptions =
        defaultNavigationMenu || children != null && children!.isNotEmpty;
    Future.delayed(Duration.zero,
        () => controller.createList(children ?? defaultNavigationOptions));
    if (isWidgetBuild == false) {
      return;
    }
    Future.delayed(Duration.zero, onWidgetBuild!);
  }
  static List<CustomVisibility> get defaultNavigationOptions {
    return [
      CustomVisibility(
        child: CustomFloatingActionButton(
            heroTag: "btn1",
            tooltip: "Joystick test",
            onPressed: () => Get.toNamed(SharedRoutes.JoystickHomeRoute),
            child: const Icon(Icons.gamepad)),
      ),
      CustomVisibility(
        child: CustomFloatingActionButton(
            heroTag: "btn2",
            tooltip: "Records",
            onPressed: () =>
                Get.toNamed(SharedRoutes.RecordRoute, preventDuplicates: false),
            child: const Icon(Icons.receipt_rounded)),
      ),
      CustomVisibility(
          child: CustomFloatingActionButton(
              heroTag: "btn3",
              tooltip: "Settings",
              onPressed: () => Get.toNamed(SharedRoutes.SettingsRoute),
              child: const Icon(Icons.settings))),
    ];
  }

  List<CustomVisibility> get customNavigationOptions {
    return children ?? defaultNavigationOptions;
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero,
        () => controller.createList(children ?? defaultNavigationOptions));
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          controller.createList(children ?? defaultNavigationOptions);
          if (controller.isExpanded.value) {
            controller.setAllInvisible();
          }
        },
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: AppConfig.primaryColor,
              title: Text(title ?? AppConfig.appTitle),
            ),
            body: Padding(padding: const EdgeInsets.all(12.0), child: child),
            floatingActionButtonLocation: _useNavigationOptions
                ? FloatingActionButtonLocation.centerFloat
                : null,
            floatingActionButton: _useNavigationOptions
                ? Obx(() => Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: controller.childList.value.length,
                              itemBuilder: (BuildContext context, int index) {
                                final item = controller.childList.value[index];
                                return Container(
                                    alignment: Alignment.bottomLeft,
                                    child: item);
                              }),
                          CustomFloatingActionButton(
                            onPressed: () {
                              if (lastPage) {
                                Get.back();
                                return;
                              }
                              controller.createList(
                                  children ?? defaultNavigationOptions);
                              controller.toggleExpanded();
                            },
                            tooltip: 'Show options',
                            child: lastPage
                                ? const Icon(Icons.arrow_back)
                                : const Icon(Icons.more_horiz),
                          ),
                        ]))
                : null));
  }
}
