// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:app_laser_cat/shared/ui/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TextFieldDialog {
  final String title;
  final TextEditingController controller;
  final Function() onSave;
  final Function() onCancel;

  final String label;
  const TextFieldDialog({
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
