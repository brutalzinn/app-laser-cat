import 'dart:async';
import 'package:app_laser_cat/app_config.dart';
import 'package:app_laser_cat/modules/joystick/infra/controller/joystick_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/joystick_widget.dart';

class JoystickView extends StatelessWidget {
  final joystickController = Get.find<JoystickController>();

  JoystickView({super.key});

  StreamController<String> streamController =
      StreamController.broadcast(sync: true);

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
            child: Column(
              children: [
                TextButton(
                    onPressed: joystickController.toggleLaser,
                    child: const Text("TOGGLE LASER")),
                //get responses from esp
                Text(joystickController.responses.value.first)
              ],
            ),
          ),
        ),
        floatingActionButton: Column(
          children: [
            FloatingActionButton(
              onPressed: joystickController.startRecording,
              tooltip: 'Record',
              child: joystickController.isRecording
                  ? const Icon(Icons.play_arrow)
                  : const Icon(IconData(0xe606, fontFamily: 'MaterialIcons')),
            ),
          ],
        ));
  }
}
