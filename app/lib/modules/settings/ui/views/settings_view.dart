import 'package:app_laser_cat/app_config.dart';
import 'package:app_laser_cat/modules/settings/infra/controller/settings_controller.dart';
import 'package:app_laser_cat/modules/settings/ui/widgets/settings_text.dart';
import 'package:app_laser_cat/shared/ui/menu/custom_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsView extends StatelessWidget {
  final settingsController = Get.find<SettingsController>();

  SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        defaultNavigationMenu: true,
        lastPage: true,
        child: ListView(
          children: [
            SettingsText(label: "IP:", controller: settingsController.socketIp),
            const Text(
                "Auto reconnect will change this ip VALUE. Be sure your esp 8266 is connect same network this device."),
            SettingsText(
                label: "Port(number):",
                controller: settingsController.socketPort),
            SettingsText(
                label: "Velocity(decimal):",
                controller: settingsController.velocity),
            SettingsText(
                label: "Delivery delay(seconds):",
                controller: settingsController.deliveryDelay),
            SettingsText(
                label: "Timeout(Seconds):",
                controller: settingsController.timeout),
            SettingsText(
                label: "Auto reconnect timeout(Seconds):",
                controller: settingsController.autoReconnectInterval),
            SettingsText(
                label: "Auto reconnect attemps(number):",
                controller: settingsController.autoReconnectAttempts),
            Obx(
              () => Row(
                children: [
                  const Text("Auto reconnect:"),
                  Checkbox(
                      activeColor: AppConfig.primaryColor,
                      value: settingsController.isAutoReconnect.value,
                      onChanged: (bool? value) =>
                          settingsController.onChangeAutoReconnect(value!)),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: settingsController.saveSettings,
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            AppConfig.primaryColor)),
                    child: Text(
                      'Save',
                      style: TextStyle(color: AppConfig.secondaryColor),
                    )),
                ElevatedButton(
                    onPressed: settingsController.cancelSettings,
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            AppConfig.primaryColor)),
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: AppConfig.secondaryColor),
                    ))
              ],
            )
          ],
        ));
  }
}
