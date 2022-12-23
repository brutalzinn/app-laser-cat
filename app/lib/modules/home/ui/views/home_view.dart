import 'dart:core';

import 'package:app_laser_cat/modules/home/infra/controller/home_controller.dart';
import 'package:app_laser_cat/shared/infra/routes/routes.dart';
import 'package:app_laser_cat/shared/ui/menu/custom_scaffold.dart';
import 'package:app_laser_cat/shared/ui/widgets/custom_floating_buttons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app_config.dart';

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
            Text(
              homeController.getAutoConnectStatus(),
              style: const TextStyle(fontSize: 25),
            ),
            ElevatedButton(
                onPressed: homeController.connect,
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        AppConfig.primaryColor)),
                child: Text(
                  'Connect',
                  style: TextStyle(color: AppConfig.secondaryColor),
                ))
          ],
        )));
  }
}
