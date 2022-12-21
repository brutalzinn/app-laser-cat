import 'package:app_laser_cat/modules/home/infra/controller/home_controller.dart';
import 'package:app_laser_cat/shared/infra/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app_config.dart';

class HomeView extends StatelessWidget {
  final homeController = Get.find<HomeController>();
  HomeView({super.key});
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
              const Text(
                "Connecting...",
                style: TextStyle(fontSize: 25),
              ),
              TextButton(
                  onPressed: homeController.connect,
                  child: const Text('Connect'))
            ],
          ))),
      floatingActionButton: FloatingActionButton(
          onPressed: () => Get.toNamed(SharedRoutes.SettingsRoute),
          // heroTag: 'settings',
          tooltip: 'Settings',
          child: const Icon(Icons.settings)),
    );
  }
}
