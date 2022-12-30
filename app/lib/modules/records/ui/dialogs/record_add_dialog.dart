// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:app_laser_cat/app_config.dart';
import 'package:app_laser_cat/modules/records/infra/models/enums/record_types_enum.dart';
import 'package:app_laser_cat/shared/ui/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RecordAddDialog {
  Rx<int> groupValue = Rx<int>(0);
  final String title;
  final TextEditingController controller;
  final Function(int value) onSave;
  final Function() onCancel;

  final String label;
  RecordAddDialog({
    Key? key,
    required this.title,
    required this.controller,
    required this.onSave,
    required this.onCancel,
    required this.label,
  });

  void showDialog() {
    Get.defaultDialog(
        title: title,
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(
            controller: controller,
            keyboardType: TextInputType.text,
            maxLines: 1,
            decoration: InputDecoration(
                labelText: label,
                hintMaxLines: 1,
                border: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green, width: 4.0))),
          ),
          Text("Play option"),

          ///TODO: create a widget to do this more readable after...
          optionRadioButton(),

          const SizedBox(
            height: 30.0,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            CustomElevatedButton(
                onPressed: onSave(groupValue.value), label: "SAVE"),
            CustomElevatedButton(onPressed: onCancel, label: "CANCEL")
          ])
        ]),
        radius: 10.0);
  }

  Widget optionRadioButton() {
    return Obx(
      () => ListView(
        shrinkWrap: true,
        children: [
          ListTile(
            title: Text(
              'On press',
            ),
            leading: Radio(
              value: RecordTypeEnum.repeatOnPress.index,
              groupValue: groupValue.value,
              activeColor: AppConfig.primaryColor,
              onChanged: (int? value) {
                groupValue.value = value ?? 0;
              },
            ),
          ),
          ListTile(
            title: Text(
              'Repeat',
            ),
            leading: Radio(
              value: RecordTypeEnum.repeat.index,
              groupValue: groupValue.value,
              activeColor: AppConfig.primaryColor,
              onChanged: (int? value) {
                groupValue.value = value ?? 0;
              },
            ),
          ),
        ],
      ),
    );
  }
}
