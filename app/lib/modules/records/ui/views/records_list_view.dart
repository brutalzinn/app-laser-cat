import 'dart:core';
import 'package:app_laser_cat/app_config.dart';
import 'package:app_laser_cat/modules/records/infra/controller/record_controller.dart';
import 'package:app_laser_cat/shared/infra/routes/routes.dart';
import 'package:app_laser_cat/shared/ui/menu/custom_scaffold.dart';
import 'package:app_laser_cat/shared/ui/widgets/custom_floating_action_button.dart';
import 'package:app_laser_cat/shared/ui/widgets/custom_visibility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RecordListView extends StatelessWidget {
  final recordController = Get.find<RecordController>();

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        children: [
          CustomVisibility(
              child: CustomFloatingActionButton(
                  heroTag: "btn555",
                  tooltip: "Add record",
                  onPressed: () => Get.toNamed(SharedRoutes.SettingsRoute),
                  child: const Icon(Icons.add))),
        ],
        title: "Angule Records",
        onWidgetBuild: () => recordController.getRecordList(),
        child: Obx(
          () => ListView.builder(
              itemCount: recordController.records.value.length,
              itemBuilder: (BuildContext context, int index) {
                final item = recordController.records.value[index];
                return ListTile(
                    onTap: () {},
                    leading: const Icon(Icons.list),
                    trailing: Text(
                      item.name,
                      style: TextStyle(
                          color: AppConfig.secondaryColor, fontSize: 15),
                    ),
                    title: Text(item.name));
              }),
        ));
  }
}
