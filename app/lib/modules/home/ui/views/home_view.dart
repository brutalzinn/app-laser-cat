import 'dart:core';

import 'package:app_laser_cat/modules/home/infra/controller/home_controller.dart';
import 'package:app_laser_cat/shared/infra/routes/routes.dart';
import 'package:app_laser_cat/shared/ui/widgets/options_menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app_config.dart';

class HomeView extends StatelessWidget {
  final homeController = Get.find<HomeController>();
  HomeView({super.key}) {
    Future.delayed(Duration.zero, () => homeController.connect());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppConfig.appTitle),
        ),
        body: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Center(
                child: Column(
              children: [
                Text(
                  homeController.getAutoConnectStatus(),
                  style: const TextStyle(fontSize: 25),
                ),
                TextButton(
                    onPressed: homeController.connect,
                    child: const Text('Connect'))
              ],
            ))),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton:  SettingsFloatingButton());
  }
}
