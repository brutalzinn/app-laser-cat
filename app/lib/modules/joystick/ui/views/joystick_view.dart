import 'dart:async';
import 'package:app_laser_cat/app_config.dart';
import 'package:app_laser_cat/modules/joystick/infra/controller/joystick_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/joystick_widget.dart';

class JoystickView extends StatelessWidget {
  final joystickController = Get.find<JoystickController>();
  JoystickView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppConfig.appTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: JoystickWidget(
          callBack: ((data) {
            joystickController.sendPackage(data.x, data.y);
          }),
          onDragEnd: () {},
          child: Obx(
            () => Column(
              children: [
                TextButton(
                    onPressed: joystickController.toggleLaser,
                    child: const Text("TOGGLE LASER")),
                TextButton(
                    onPressed: joystickController.toggleRecording,
                    child: joystickController.isRecording.value
                        ? const Text("Stop")
                        : const Text("Record")),

                //get responses from esp
                Text(joystickController.lastResponse.value)
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10.0),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          FloatingActionButton(
              onPressed: joystickController.playRecording,
              tooltip: 'Settings',
              child: const Icon(Icons.settings)),
          FloatingActionButton(
              onPressed: joystickController.playRecording,
              tooltip: 'Play record',
              child: const Icon(Icons.play_arrow)),
        ]),
      ),
    );
  }
}
