// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:app_laser_cat/modules/records/infra/controller/record_controller.dart';
import 'package:flutter/material.dart';

import 'record_abstract.dart';

class ItemLaser extends RecordAbstract {
  int value;
  ItemLaser(
    this.value,
  );

  ItemLaser copyWith({
    int? value,
  }) {
    return ItemLaser(
      value ?? this.value,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'value': value,
    };
  }

  factory ItemLaser.fromMap(Map<String, dynamic> map) {
    return ItemLaser(
      map['value'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory ItemLaser.fromJson(String source) =>
      ItemLaser.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ItemLaser(value: $value)';

  @override
  bool operator ==(covariant ItemLaser other) {
    if (identical(this, other)) return true;

    return other.value == value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  Widget showDialog(RecordController recordController) {
    // TODO: implement showDialog
    throw UnimplementedError();
  }

  @override
  void onSave() {
    // TODO: implement onSave
  }
}
