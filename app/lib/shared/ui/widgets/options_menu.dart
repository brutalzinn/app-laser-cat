import 'package:app_laser_cat/shared/infra/controllers/options_menu_controller.dart';
import 'package:app_laser_cat/shared/infra/routes/routes.dart';
import 'package:app_laser_cat/shared/ui/widgets/custom_multiple_actions.dart';
import 'package:app_laser_cat/shared/ui/widgets/custom_visibility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsFloatingButton extends StatelessWidget {
  final controller = Get.find<OptionsMenuController>();
  SettingsFloatingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomMultipleActions(controller: controller, children: [
      CustomVisibility(
          child: FloatingActionButton(
              onPressed: () => print("floating action 0"),
              child: const Icon(Icons.account_balance))),
      CustomVisibility(
        child: FloatingActionButton(
            onPressed: () => print("floating action 1"),
            child: const Icon(Icons.e_mobiledata)),
      ),
      CustomVisibility(
        child: FloatingActionButton(
            onPressed: () => print("floating action 2"),
            child: const Icon(Icons.e_mobiledata_outlined)),
      ),
    ]);
  }
}
