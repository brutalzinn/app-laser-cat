// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:app_laser_cat/shared/ui/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RecordItemDialog {
  final String title;
  final Widget child;
  final Function() onSave;
  final Function() onCancel;
  const RecordItemDialog({
    Key? key,
    required this.title,
    required this.child,
    required this.onSave,
    required this.onCancel,
  });

  void showDialog() {
    Get.defaultDialog(
        title: title,
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          child,
          const SizedBox(
            height: 30.0,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            CustomElevatedButton(onPressed: onSave, label: "SAVE"),
            CustomElevatedButton(onPressed: onCancel, label: "CANCEL")
          ])
        ]),
        radius: 10.0);
  }
}
