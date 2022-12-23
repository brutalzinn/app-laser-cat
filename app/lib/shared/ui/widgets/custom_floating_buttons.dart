// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:app_laser_cat/shared/infra/controllers/options_menu_controller.dart';
import 'package:app_laser_cat/shared/infra/routes/routes.dart';
import 'package:app_laser_cat/shared/ui/widgets/custom_floating_action_button.dart';
import 'package:app_laser_cat/shared/ui/widgets/custom_multiple_actions.dart';
import 'package:app_laser_cat/shared/ui/widgets/custom_visibility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomFloatingButtons extends StatelessWidget {
  OptionsMenuController controller;
  CustomFloatingButtons({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("expanded ${controller.isExpanded.value}");
    return CustomMultipleActions(
        child: CustomFloatingActionButton(
          heroTag: "btn1",
          onPressed: () {
            print("toggle expanded ${controller.isExpanded.value}");
            controller.toggleExpanded();
          },
          tooltip: 'Show options',
          child: const Icon(Icons.more_horiz),
        ),
        controller: controller,
        children: [
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
}
