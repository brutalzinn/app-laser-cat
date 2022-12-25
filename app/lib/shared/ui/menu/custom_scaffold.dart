// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:app_laser_cat/app_config.dart';
import 'package:app_laser_cat/shared/infra/controllers/options_menu_controller.dart';
import 'package:app_laser_cat/shared/infra/routes/routes.dart';
import 'package:app_laser_cat/shared/ui/widgets/custom_floating_action_button.dart';
import 'package:app_laser_cat/shared/ui/widgets/custom_multiple_actions.dart';
import 'package:app_laser_cat/shared/ui/widgets/custom_visibility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomScaffold extends StatelessWidget {
  final controller = Get.find<OptionsMenuController>();
  final Widget child;
  String? title;
  VoidCallback? onWidgetBuild;
  List<CustomVisibility>? children = [];
  bool defaultNavigationMenu;
  bool lastPage;

  bool _useNavigationOptions = false;
  bool _useCustomChildren = false;

  bool _useDefaultNavigationOptions = false;

  CustomScaffold({
    Key? key,
    required this.child,
    this.title,
    this.onWidgetBuild,
    this.children,
    this.defaultNavigationMenu = false,
    this.lastPage = false,
  }) {
    _useCustomChildren = children != null;
    _useDefaultNavigationOptions = defaultNavigationMenu;
    _useNavigationOptions = _useCustomChildren || _useDefaultNavigationOptions;
    bool isWidgetBuild = onWidgetBuild != null;
    if (isWidgetBuild == false) {
      return;
    }
    Future.delayed(Duration.zero, onWidgetBuild!);
  }

  List<CustomVisibility> get defaultNavigationOptions {
    return List<CustomVisibility>.from([
      CustomVisibility(
        child: CustomFloatingActionButton(
            heroTag: "666",
            tooltip: "Joystick test",
            onPressed: () => Get.toNamed(SharedRoutes.JoystickHomeRoute),
            child: const Icon(Icons.gamepad)),
      ),
      CustomVisibility(
        child: CustomFloatingActionButton(
            heroTag: "btn2",
            tooltip: "Records",
            onPressed: () => Get.toNamed(SharedRoutes.RecordRoute),
            child: const Icon(Icons.receipt_rounded)),
      ),
      CustomVisibility(
          child: CustomFloatingActionButton(
              heroTag: "btn3",
              tooltip: "Settings",
              onPressed: () => Get.toNamed(SharedRoutes.SettingsRoute),
              child: const Icon(Icons.settings))),
    ]);
  }

  List<CustomVisibility> get customNavigationOptions {
    return List<CustomVisibility>.from(children ?? []);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
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
              ? CustomMultipleActions(
                  child: CustomFloatingActionButton(
                    heroTag: "btn1",
                    onPressed: () {
                      if (lastPage) {
                        Get.back();
                        return;
                      }
                      controller.toggleExpanded();
                    },
                    tooltip: 'Show options',
                    child: lastPage
                        ? const Icon(Icons.arrow_back)
                        : const Icon(Icons.more_horiz),
                  ),
                  controller: controller,
                  children: [
                      ...customNavigationOptions,
                      if (_useDefaultNavigationOptions)
                        ...defaultNavigationOptions,
                    ])
              : null),
    );
  }
}
