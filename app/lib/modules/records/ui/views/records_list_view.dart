import 'dart:core';

import 'package:app_laser_cat/modules/home/infra/controller/home_controller.dart';
import 'package:app_laser_cat/modules/records/infra/controller/record_controller.dart';
import 'package:app_laser_cat/shared/infra/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app_config.dart';

class RecordListView extends StatelessWidget {
  final recordController = Get.find<RecordController>();
  RecordListView({super.key}) {
    //  Future.delayed(Duration.zero, () => homeController.connect());
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
              const Text(
                "Record",
                style: TextStyle(fontSize: 25),
              ),
              TextButton(
                  onPressed: () => print("PLAY"), child: const Text('PLAY')),
              TextButton(
                  onPressed: () => print("EDIT"), child: const Text('EDIT')),
              TextButton(
                  onPressed: () => print("DELETE"),
                  child: const Text('DELETE')),
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
