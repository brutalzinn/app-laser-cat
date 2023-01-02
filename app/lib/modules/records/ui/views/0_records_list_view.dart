import 'dart:async';

import 'package:app_laser_cat/app_config.dart';
import 'package:app_laser_cat/modules/joystick/infra/controller/joystick_controller.dart';
import 'package:app_laser_cat/modules/records/infra/controller/record_controller.dart';
import 'package:app_laser_cat/modules/records/infra/models/enums/record_types_enum.dart';
import 'package:app_laser_cat/shared/infra/routes/routes.dart';
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
                      joystickController: joystickController,
                      onSave: () {
                        print("click on save");
                      },
                      onCancel: () => Get.back(),
                      label: "File name",
                    ).showDialog();
                  },
                  child: const Icon(Icons.add))),
        ],

        ///we will separe this after
        title: "Angule Records",
        onWidgetBuild: recordController.getRecordList,
        child: Obx(
          () => recordController.isLoading.value
              ? const Text("Loading..")
              : ListView.builder(
                  itemCount: recordController.records.length,
                  itemBuilder: (BuildContext context, int index) {
                    final item = recordController.records[index];
                    return ListTile(
                        onTap: () {},
                        leading: const Icon(Icons.list),
                        trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CustomFloatingActionButton(
                                  onPressed: () {
                                    recordController.setCurrentRecord(item);
                                    Get.toNamed(SharedRoutes.RecordViewRoute);
                                  },
                                  child: const Icon(Icons.settings)),
                              CustomFloatingActionButton(
                                  onLongPressed: () =>
                                      recordController.playLongRecord(item),

                                  /// this is wrong way to do this. The logic part needs be in controller. This a rule of this escturure pattern. But..
                                  onPressed: () async {
                                    await recordController.playRecord(item);
                                  },
                                  child: recordController.isPlay.value
                                      ? const Icon(Icons.stop)
                                      : const Icon(Icons.play_arrow))
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
