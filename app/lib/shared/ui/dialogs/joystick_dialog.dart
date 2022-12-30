// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:app_laser_cat/modules/joystick/infra/controller/joystick_controller.dart';
import 'package:app_laser_cat/modules/joystick/ui/widgets/joystick_widget.dart';
import 'package:app_laser_cat/shared/ui/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class JoystickDialog {
  final String title;
  final JoystickController joystickController;
  final Function() onSave;
  final Function() onCancel;

  final String label;
  const JoystickDialog({
    Key? key,
    required this.title,
    required this.joystickController,
    required this.onSave,
    required this.onCancel,
    required this.label,
  });

  void showDialog() {
    Get.defaultDialog(
        title: title,
        content: Expanded(
          child: JoystickWidget(
              callBack: ((data) {
                joystickController.sendPackage(data.x, data.y);
              }),
              onDragEnd: () {},
              child:
                  Obx(() => Column(mainAxisSize: MainAxisSize.max, children: [
                        CustomElevatedButton(
                            onPressed: joystickController.toggleLaser,
                            label: "TOGGLE LASER"),
                        CustomElevatedButton(
                            onPressed: joystickController.toggleRecording,
                            label: joystickController.isRecording.value
                                ? "Stop"
                                : "Record"),
                        Text(joystickController
                            .connectorService.statusMessage.value),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CustomElevatedButton(
                                  onPressed: onSave, label: "SAVE"),
                              CustomElevatedButton(
                                  onPressed: onCancel, label: "CANCEL")
                            ])
                      ]))),
        ),
        radius: 10.0);
  }
}
