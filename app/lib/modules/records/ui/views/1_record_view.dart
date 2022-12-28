import 'package:app_laser_cat/app_config.dart';
import 'package:app_laser_cat/modules/joystick/infra/controller/joystick_controller.dart';
import 'package:app_laser_cat/modules/records/infra/controller/record_controller.dart';
import 'package:app_laser_cat/shared/ui/menu/custom_scaffold.dart';
import 'package:app_laser_cat/shared/ui/widgets/custom_floating_action_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

class RecordView extends StatelessWidget {
  final recordController = Get.find<RecordController>();
  final joystickController = Get.find<JoystickController>();
  RecordView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        title: "Record view",
        onWidgetBuild: () =>
            recordController.getById(Get.parameters['id'] ?? ""),
        children: [],
        // onWidgetBuild: ,
        child: Obx(() => ListView.builder(
            itemCount: recordController.recordModel.value.itens.length,
            itemBuilder: (BuildContext context, int index) {
              final item = recordController.recordModel.value.itens[index];
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
                    item.id ?? "",
                    style:
                        TextStyle(color: AppConfig.primaryColor, fontSize: 15),
                  ));
            })));
  }
}
