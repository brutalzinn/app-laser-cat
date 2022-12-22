import 'package:app_laser_cat/app_config.dart';
import 'package:app_laser_cat/modules/settings/infra/controller/settings_controller.dart';
import 'package:app_laser_cat/modules/settings/ui/widgets/settings_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

class SettingsView extends StatelessWidget {
  final settingsController = Get.find<SettingsController>();

  SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppConfig.appTitle),
        ),
        body: Column(
          children: [
            SettingsText(label: "IP:", controller: settingsController.socketIp),
            const Text(
                "Auto reconnect will change this ip VALUE. Be sure your esp 8266 is connect same network this device."),
            SettingsText(
                label: "Port:", controller: settingsController.socketPort),
            SettingsText(
                label: "Velocity:", controller: settingsController.velocity),
            SettingsText(
                label: "Delivery delay:",
                controller: settingsController.deliveryDelay),
            SettingsText(
                label: "Timeout:", controller: settingsController.timeout),
            Obx(
              () => Row(
                children: [
                  const Text("Auto reconnect:"),
                  Checkbox(
                      value: settingsController.isAutoReconnect.value,
                      onChanged: (bool? value) =>
                          settingsController.onChangeAutoReconnect(value!)),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                    onPressed: settingsController.saveSettings,
                    child: const Text('Save')),
                TextButton(
                    onPressed: settingsController.cancelSettings,
                    child: const Text('Cancel'))
              ],
            )
          ],
        ));
  }
}
