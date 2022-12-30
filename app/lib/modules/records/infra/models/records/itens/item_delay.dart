// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:app_laser_cat/modules/records/infra/controller/record_controller.dart';
import 'package:app_laser_cat/modules/records/ui/dialogs/record_item_dialog.dart';
import 'package:app_laser_cat/shared/infra/provider/file_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../record_abstract.dart';

class ItemDelay extends RecordAbstract {
  @override
  RecordController? recordController;

  int value;
  ItemDelay(
    this.value,
  );

  ItemDelay copyWith({
    int? value,
  }) {
    return ItemDelay(
      value ?? this.value,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'value': value,
    };
  }

  factory ItemDelay.fromMap(Map<String, dynamic> map) {
    return ItemDelay(
      map['value'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory ItemDelay.fromJson(String source) =>
      ItemDelay.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ItemDelay(value: $value)';

  @override
  bool operator ==(covariant ItemDelay other) {
    if (identical(this, other)) return true;

    return other.value == value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  void showDialog(RecordController controller) {
    final TextEditingController valueController =
        TextEditingController(text: value.toString());
    recordController = controller;

    RecordItemDialog(
        child: _dialogWidget(valueController),
        title: "Delay Editor",
        onSave: () {
          value = int.parse(valueController.text);
          onSave();
          Get.back();
        },
        onCancel: () {
          Get.back();
        }).showDialog();
  }

  Widget _dialogWidget(TextEditingController valueController) {
    return TextField(
      controller: valueController,
      keyboardType: TextInputType.text,
      maxLines: 1,
      decoration: const InputDecoration(
          labelText: "Delay",
          hintMaxLines: 1,
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.green, width: 4.0))),
    );
  }

  @override
  void onSave() {
    final recordItens = recordController?.currentRecord.value?.itens ?? [];
    final currentRecord = recordController?.currentRecord.value;
    final currentRecordItem = recordController?.currentRecordItem.value;
    if (currentRecord == null || currentRecordItem == null) {
      print("current item doesnt exists");
      return;
    }
    final currentRecordItemIndex = recordItens.indexOf(currentRecordItem);
    recordItens[currentRecordItemIndex].object = toJson();
    currentRecord.save();
  }
}
