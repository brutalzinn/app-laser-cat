import 'dart:convert';

import 'package:app_laser_cat/modules/records/infra/controller/record_controller.dart';
import 'package:app_laser_cat/modules/records/infra/models/record_model.dart';
import 'package:app_laser_cat/shared/infra/provider/file_provider.dart';
import 'package:app_laser_cat/shared/ui/dialogs/record_item_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../record_abstract.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class ItemCoord extends RecordAbstract {
  @override
  RecordController? recordController;
  int x;
  int y;
  ItemCoord(
    this.x,
    this.y,
  );

  ItemCoord copyWith({
    int? x,
    int? y,
  }) {
    return ItemCoord(
      x ?? this.x,
      y ?? this.y,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'x': x,
      'y': y,
    };
  }

  factory ItemCoord.fromMap(Map<String, dynamic> map) {
    return ItemCoord(
      map['x'] as int,
      map['y'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory ItemCoord.fromJson(String source) =>
      ItemCoord.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ItemCoord(x: $x, y: $y)';

  @override
  bool operator ==(covariant ItemCoord other) {
    if (identical(this, other)) return true;

    return other.x == x && other.y == y;
  }

  @override
  int get hashCode => x.hashCode ^ y.hashCode;

  /// in this project, we dont need to do this.
  /// we are working on this after one week justily to solve the indenpendency principle.
  /// to do that, we need to handle this in controller. Like we do with joystick widget.
  /// we will put thos dialog to controller again.
  /// and we will only pass controller and return widget.
  @override
  void showDialog(RecordController controller) {
    final TextEditingController coordX =
        TextEditingController(text: x.toString());
    final TextEditingController coordY =
        TextEditingController(text: y.toString());

    recordController = controller;
    RecordItemDialog(
        child: _dialogWidget(coordX, coordY),
        title: "Record editor",
        onSave: () {
          x = int.parse(coordX.text);
          y = int.parse(coordY.text);
          onSave();
          Get.back();
        },
        onCancel: () {
          Get.back();
        }).showDialog();
  }

  Widget _dialogWidget(
      TextEditingController coordX, TextEditingController coordY) {
    return Column(
      children: [
        TextField(
          controller: coordX,
          keyboardType: TextInputType.text,
          maxLines: 1,
          decoration: const InputDecoration(
              labelText: "x",
              hintMaxLines: 1,
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green, width: 4.0))),
        ),
        TextField(
          keyboardType: TextInputType.text,
          controller: coordY,
          maxLines: 1,
          decoration: const InputDecoration(
              labelText: "y",
              hintMaxLines: 1,
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green, width: 4.0))),
        ),
      ],
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
