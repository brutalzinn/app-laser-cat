import 'dart:core';

import 'package:app_laser_cat/app_config.dart';
import 'package:app_laser_cat/modules/home/infra/controller/home_controller.dart';
import 'package:app_laser_cat/shared/ui/menu/custom_scaffold.dart';
import 'package:app_laser_cat/shared/ui/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeView extends StatelessWidget {
  final homeController = Get.find<HomeController>();
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        onWidgetBuild: homeController.connect,
        navigationMenu: true,
        child: Center(
            child: Column(
          children: [
            Obx(
              () => Text(
                homeController.notificationMessage.value,
                style: const TextStyle(fontSize: 25),
              ),
            ),
            CustomElevatedButton(
                onPressed: homeController.connect, label: "Connect")
          ],
        )));
  }
}
