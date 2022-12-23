// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:app_laser_cat/app_config.dart';
import 'package:app_laser_cat/shared/infra/controllers/options_menu_controller.dart';
import 'package:app_laser_cat/shared/ui/widgets/custom_floating_buttons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomScaffold extends StatelessWidget {
  final controller = Get.find<OptionsMenuController>();
  final Function? onWidgetBuild;
  final Widget child;
  String? title;
  CustomScaffold({
    Key? key,
    this.onWidgetBuild,
    this.title,
    required this.child,
  }) {
    Future.delayed(Duration.zero, () => onWidgetBuild ?? onWidgetBuild);
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
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: CustomFloatingButtons(controller: controller)),
    );
  }
}
