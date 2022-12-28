import 'dart:core';
import 'package:app_laser_cat/app_config.dart';
import 'package:app_laser_cat/modules/joystick/infra/controller/joystick_controller.dart';
import 'package:app_laser_cat/modules/records/infra/controller/record_controller.dart';
import 'package:app_laser_cat/modules/records/infra/models/record_model.dart';
import 'package:app_laser_cat/shared/infra/provider/file_provider.dart';
import 'package:app_laser_cat/shared/ui/dialogs/joystick_dialog.dart';
import 'package:app_laser_cat/shared/ui/menu/custom_scaffold.dart';
import 'package:app_laser_cat/shared/ui/widgets/custom_floating_action_button.dart';
import 'package:app_laser_cat/shared/ui/widgets/custom_visibility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RecordListView extends StatelessWidget {
  final recordController = Get.find<RecordController>();
  final joystickController = Get.find<JoystickController>();

  TextEditingController recordName = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        children: [
          CustomVisibility(
              child: CustomFloatingActionButton(
                  heroTag: "fsdfsfsdfds",
                  tooltip: "Add record",
                  onPressed: () {
                    JoystickDialog(
                      title: "Joystick Dialog",
                      controller: recordName,
                      joystickController: joystickController,
                      onSave: () {
                        final fileProvider = FileProvider();
                        String name = recordName.text.toLowerCase();
                        final mapper =
                            RecordModel(name, joystickController.packages);
                        fileProvider.write(
                            "records/${name}.json", mapper.toJson());
                        print("saving as ${name}.json");
                        Get.back();
                      },
                      onCancel: () => Get.back(),
                      label: "File name",
                    ).showDialog();
                  },
                  child: const Icon(Icons.add))),
        ],
        title: "Angule Records",
        onWidgetBuild: recordController.getRecordList,
        child: Obx(
          () => ListView.builder(
              itemCount: recordController.records.length,
              itemBuilder: (BuildContext context, int index) {
                final item = recordController.records[index];
                return ListTile(
                    onTap: () {},
                    leading: const Icon(Icons.list),
                    trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomFloatingActionButton(
                              onPressed: () {},
                              child: const Icon(Icons.play_arrow)),
                        ]),
                    title: Text(
                      item.name,
                      style: TextStyle(
                          color: AppConfig.primaryColor, fontSize: 15),
                    ));
              }),
        ));
  }
}
