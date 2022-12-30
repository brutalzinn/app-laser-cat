// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:app_laser_cat/app_config.dart';
import 'package:app_laser_cat/modules/records/infra/models/enums/record_types_enum.dart';
import 'package:app_laser_cat/modules/records/infra/models/item_model.dart';
import 'package:app_laser_cat/modules/records/infra/models/record_model.dart';
import 'package:app_laser_cat/modules/records/infra/models/records/record_options.dart';
import 'package:app_laser_cat/shared/ui/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RecordAddDialog {
  ///wrong way to do this.. BUT I ONLY HAVE THREE HOURS TO DO THIS.

  Rx<RecordModel?> recordModelChanged = Rx<RecordModel?>(null);
  Rx<RecordTypeEnum> recordType =
      Rx<RecordTypeEnum>(RecordTypeEnum.repeatOnPress);
  final String title;
  final RecordModel? recordModel;
  final List<ItemModel>? packages;
  final TextEditingController recordNameController = TextEditingController();
  final Function(RecordModel value) onSave;
  final Function() onCancel;

  final String label;
  RecordAddDialog(
      {Key? key,
      this.recordModel,
      this.packages,
      required this.title,
      required this.onSave,
      required this.onCancel,
      required this.label}) {
    recordModelChanged.value = recordModel;
  }

  void showDialog() {
    Get.defaultDialog(
      title: title,
      content: Obx(() => Column(children: [
            TextField(
              controller: recordNameController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  labelText: label,
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: AppConfig.primaryColor))),
            ),
            Text("Play option"),

            ///TODO: create a widget to do this more readable after...
            ListTile(
              title: Text(
                'On press',
              ),
              leading: Radio(
                value: RecordTypeEnum.repeatOnPress,
                groupValue: recordType.value,
                activeColor: AppConfig.primaryColor,
                onChanged: (RecordTypeEnum? value) {
                  recordType.value = value!;
                },
              ),
            ),
            ListTile(
              title: Text(
                'Repeat',
              ),
              leading: Radio(
                value: RecordTypeEnum.repeat,
                groupValue: recordType.value,
                activeColor: AppConfig.primaryColor,
                onChanged: (RecordTypeEnum? value) {
                  recordType.value = value!;
                },
              ),
            ),

            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              CustomElevatedButton(
                  onPressed: () {
                    final record = RecordModel(
                        recordNameController.text,
                        packages ?? [],
                        RecordOptions(recordType: recordType.value.index));
                    onSave(record);
                  },
                  label: "SAVE"),
              CustomElevatedButton(onPressed: onCancel, label: "CANCEL")
            ])
          ])),
    );
  }
}
