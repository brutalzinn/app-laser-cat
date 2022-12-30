import 'dart:async';
import 'package:app_laser_cat/app_config.dart';
import 'package:app_laser_cat/modules/joystick/infra/controller/joystick_controller.dart';
import 'package:app_laser_cat/shared/infra/routes/routes.dart';
import 'package:app_laser_cat/shared/ui/menu/custom_scaffold.dart';
import 'package:app_laser_cat/shared/ui/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/joystick_widget.dart';

class JoystickView extends StatelessWidget {
  final joystickController = Get.find<JoystickController>();
  JoystickView({super.key});
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      children: AppConfig.getDefaultNavigationActions,
      title: "Joystick controller",
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: JoystickWidget(
          callBack: ((data) {
            joystickController.sendPackage(data.x, data.y);
          }),
          onDragEnd: () {},
          child: Obx(
            () => Column(
              children: [
                CustomElevatedButton(
                    onPressed: joystickController.toggleLaser,
                    label: "TOGGLE LASER"),

                ///TODO: the next implement is the record function.
                ///we need to do a shared widget with joystick same we already but only for record view.
                CustomElevatedButton(
                    onPressed: joystickController.toggleRecording,
                    label: joystickController.isRecording.value
                        ? "Stop"
                        : "Record"),

                //get responses from esp
                Text(joystickController.connectorService.statusMessage.value)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
