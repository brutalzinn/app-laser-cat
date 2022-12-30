// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:app_laser_cat/app_config.dart';
import 'package:app_laser_cat/shared/infra/controllers/options_menu_controller.dart';
import 'package:app_laser_cat/shared/ui/widgets/custom_floating_action_button.dart';
import 'package:app_laser_cat/shared/ui/widgets/custom_visibility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomScaffold extends StatelessWidget {
  final Widget child;
  String? title;
  VoidCallback? onWidgetBuild;
  List<CustomVisibility> children;
  bool lastPage;
  bool useNavigationMenu = false;

  CustomScaffold({
    super.key,
    required this.child,
    required this.children,
    this.title,
    this.onWidgetBuild,
    this.lastPage = false,
  }) {
    useNavigationMenu = children.isNotEmpty;
    bool isWidgetBuild = onWidgetBuild != null;
    if (isWidgetBuild == false) {
      return;
    }
    Future.delayed(Duration.zero, onWidgetBuild!);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OptionsMenuController>(
        id: "custom_scatfold",
        init: OptionsMenuController(children),
        builder: (controller) {
          controller.updateWidgetList(children);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            controller.setAllInvisible();
          });
          return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                controller.setAllInvisible();
                controller.refreshAll();
              },
              child: Scaffold(
                  appBar: AppBar(
                    backgroundColor: AppConfig.primaryColor,
                    title: Text(title ?? AppConfig.appTitle),
                  ),
                  body: Padding(
                      padding: const EdgeInsets.all(12.0), child: child),
                  floatingActionButtonLocation: useNavigationMenu
                      ? FloatingActionButtonLocation.centerFloat
                      : null,
                  floatingActionButton: useNavigationMenu
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                              ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: controller.childrenList.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final item = controller.childrenList[index];
                                    return Container(
                                        alignment: Alignment.bottomLeft,
                                        child: CustomVisibility(
                                            visible: item.visible,
                                            child: item.child));
                                  }),
                              SizedBox(width: 8),
                              CustomFloatingActionButton(
                                onPressed: () {
                                  controller.updateWidgetList(children);
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
                              SizedBox(width: 8),
                            ])
                      : null));
        });
  }
}
