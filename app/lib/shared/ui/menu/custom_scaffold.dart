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
  Function? onWidgetBuild;
  bool navigationMenu;
  bool lastPage;

  CustomScaffold({
    Key? key,
    required this.child,
    this.title,
    this.onWidgetBuild,
    this.navigationMenu = false,
    this.lastPage = false,
  }) {
    bool isWidgetBuild = onWidgetBuild != null;
    if (isWidgetBuild == false) {
      return;
    }
    Future.delayed(Duration.zero, onWidgetBuild!());
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
          floatingActionButtonLocation:
              navigationMenu ? FloatingActionButtonLocation.centerFloat : null,
          floatingActionButton: navigationMenu
              ? CustomMultipleActions(
                  child: CustomFloatingActionButton(
                    heroTag: "btn1",
                    onPressed: () {
                      if (lastPage) {
                        Get.back();
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
                      CustomVisibility(
                        child: CustomFloatingActionButton(
                            heroTag: "btn2",
                            tooltip: "Records",
                            onPressed: () =>
                                Get.toNamed(SharedRoutes.RecordRoute),
                            child: const Icon(Icons.receipt_rounded)),
                      ),
                      CustomVisibility(
                          child: CustomFloatingActionButton(
                              heroTag: "btn3",
                              tooltip: "Settings",
                              onPressed: () =>
                                  Get.toNamed(SharedRoutes.SettingsRoute),
                              child: const Icon(Icons.settings))),
                    ])
              : null),
    );
  }
}
