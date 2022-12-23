import 'dart:core';
import 'package:app_laser_cat/modules/records/infra/controller/record_controller.dart';
import 'package:app_laser_cat/shared/infra/routes/routes.dart';
import 'package:app_laser_cat/shared/ui/menu/custom_scaffold.dart';
import 'package:app_laser_cat/shared/ui/widgets/custom_floating_buttons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app_config.dart';

class RecordListView extends StatelessWidget {
  final recordController = Get.find<RecordController>();
  RecordListView({super.key}) {
    Future.delayed(Duration.zero, () => recordController.getRecordList());
  }
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        child: Center(
            child: ListView.builder(
                itemCount: recordController.records.value.length,
                itemBuilder: (BuildContext context, int index) {
                  final item = recordController.records.value[index];
                  return ListTile(
                      leading: const Icon(Icons.list),
                      trailing: Text(
                        item.name,
                        style:
                            const TextStyle(color: Colors.green, fontSize: 15),
                      ),
                      title: Text(item.name));
                })));
  }
}
